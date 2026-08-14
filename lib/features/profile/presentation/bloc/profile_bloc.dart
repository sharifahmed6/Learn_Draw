import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/upload_profile_image.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final SupabaseClient supabaseClient;
  final GetProfile getProfile;
  final UpdateProfile updateProfile;
  final UploadProfileImage uploadProfileImage;
  
  RealtimeChannel? _profileChannel;

  ProfileBloc({
    required this.supabaseClient,
    required this.getProfile,
    required this.updateProfile,
    required this.uploadProfileImage,
  }) : super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileField>(_onUpdateProfileField);
    on<SaveProfile>(_onSaveProfile);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
    on<PickAndUploadImage>(_onPickAndUploadImage);
    on<ProfileUpdatedExternally>(_onProfileUpdatedExternally);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final profileModel = await getProfile();
      emit(state.copyWith(
        name: profileModel.name,
        imageUrl: profileModel.profileImage ?? '',
        mobileNumber: profileModel.mobileNumber ?? '',
        country: profileModel.country ?? '',
        city: profileModel.city ?? '',
        zipCode: profileModel.zipCode ?? '',
        status: ProfileStatus.success,
      ));
      // Setup realtime listener
      final user = supabaseClient.auth.currentUser;
      if (user != null && _profileChannel == null) {
        _profileChannel = supabaseClient.channel('my-profile-${user.id}').onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'profiles',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'id',
                value: user.id,
              ),
              callback: (payload) {
                add(ProfileUpdatedExternally(payload.newRecord));
              },
            )
            .subscribe();
      }
    } catch (e) {
      // In case they just signed up and there's no profile row, or error occurs
      emit(state.copyWith(status: ProfileStatus.failure, errorMessage: e.toString()));
      // Reset back to success so UI doesn't hang in error
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(status: ProfileStatus.success));
    }
  }
  
  void _onProfileUpdatedExternally(ProfileUpdatedExternally event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
      name: event.newRecord['name'] as String? ?? state.name,
      imageUrl: event.newRecord['profile_image'] as String? ?? state.imageUrl,
      mobileNumber: event.newRecord['mobile_number'] as String? ?? state.mobileNumber,
      country: event.newRecord['country'] as String? ?? state.country,
      city: event.newRecord['city'] as String? ?? state.city,
      zipCode: event.newRecord['zip_code'] as String? ?? state.zipCode,
    ));
  }

  void _onUpdateProfileField(UpdateProfileField event, Emitter<ProfileState> emit) {
    switch (event.field) {
      case 'name':
        emit(state.copyWith(name: event.value));
        break;
      case 'mobileNumber':
        emit(state.copyWith(mobileNumber: event.value));
        break;
      case 'country':
        emit(state.copyWith(country: event.value));
        break;
      case 'city':
        emit(state.copyWith(city: event.value));
        break;
      case 'zipCode':
        emit(state.copyWith(zipCode: event.value));
        break;
    }
  }

  Future<void> _onSaveProfile(SaveProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.saving));
    try {
      await updateProfile(
        name: state.name,
        country: state.country,
        city: state.city,
        mobileNumber: state.mobileNumber,
        zipCode: state.zipCode,
        profileImage: state.imageUrl,
      );
      
      emit(state.copyWith(status: ProfileStatus.saveSuccess));
      // Revert to success status after a delay so it doesn't keep triggering success UI
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(status: ProfileStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure, errorMessage: e.toString()));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(status: ProfileStatus.success)); // Revert back to view mode
    }
  }

  Future<void> _onDeleteAccountRequested(DeleteAccountRequested event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.saving));
    try {
      await supabaseClient.auth.signOut();
      emit(state.copyWith(status: ProfileStatus.deleteSuccess));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onPickAndUploadImage(PickAndUploadImage event, Emitter<ProfileState> emit) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: event.source);
      
      if (image != null) {
        emit(state.copyWith(status: ProfileStatus.saving, isUploadingImage: true));
        final File file = File(image.path);
        
        final String publicUrl = await uploadProfileImage(file);
        
        // Update the profile table immediately with the new image URL
        await updateProfile(
          name: state.name,
          country: state.country,
          city: state.city,
          mobileNumber: state.mobileNumber,
          zipCode: state.zipCode,
          profileImage: publicUrl,
        );
        
        emit(state.copyWith(imageUrl: publicUrl, status: ProfileStatus.success, isUploadingImage: false));
      } else {
        emit(state.copyWith(status: ProfileStatus.success, isUploadingImage: false));
      }
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure, errorMessage: e.toString(), isUploadingImage: false));
      await Future.delayed(const Duration(milliseconds: 100));
      emit(state.copyWith(status: ProfileStatus.success, isUploadingImage: false));
    }
  }

  @override
  Future<void> close() {
    if (_profileChannel != null) {
      supabaseClient.removeChannel(_profileChannel!);
    }
    return super.close();
  }
}
