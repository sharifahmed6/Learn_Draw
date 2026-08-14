import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import '../../../../core/error/exceptions.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<void> createProfile({
    required String name,
    required String country,
    required String city,
    required String mobileNumber,
    required String zipCode,
    String? profileImage,
  });
  Future<ProfileModel> getProfile();
  Future<void> updateProfile({
    required String name,
    required String country,
    required String city,
    required String mobileNumber,
    required String zipCode,
    String? profileImage,
  });
  Future<String> uploadProfileImage(File file);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;
  final _logger = Logger();

  ProfileRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<ProfileModel> getProfile() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw const ServerException(message: 'User is not logged in');
    }

    try {
      final response = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
          
      if (response == null) {
        _logger.w('Profile not found for ${user.id}. Returning empty profile.');
        return ProfileModel(
          id: user.id,
          name: user.userMetadata?['name'] ?? 'Unknown User',
          country: user.userMetadata?['country'] ?? '',
          city: user.userMetadata?['city'] ?? '',
        );
      }
          
      _logger.i('Profile fetched successfully for ${user.id}');
      return ProfileModel.fromJson(response);
    } on PostgrestException catch (e) {
      _logger.e('Failed to get profile: ${e.message}');
      throw ServerException(message: e.message);
    } catch (e) {
      _logger.e('Failed to get profile: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> createProfile({
    required String name,
    required String country,
    required String city,
    required String mobileNumber,
    required String zipCode,
    String? profileImage,
  }) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw const ServerException(message: 'User is not logged in');
    }

    try {
      final insertData = {
        'id': user.id,
        'name': name,
        'country': country,
        'city': city,
        'mobile_number': mobileNumber,
        'zip_code': zipCode,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (profileImage != null && profileImage.isNotEmpty) {
        insertData['profile_image'] = profileImage;
      }

      await supabaseClient
          .from('profiles')
          .insert(insertData);
          
      _logger.i('Profile created successfully for ${user.id}');
    } on PostgrestException catch (e) {
      _logger.e('Failed to create profile: ${e.message}');
      throw ServerException(message: e.message);
    } catch (e) {
      _logger.e('Failed to create profile: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateProfile({
    required String name,
    required String country,
    required String city,
    required String mobileNumber,
    required String zipCode,
    String? profileImage,
  }) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw const ServerException(message: 'User is not logged in');
    }

    try {
      final updateData = {
        'name': name,
        'country': country,
        'city': city,
        'mobile_number': mobileNumber,
        'zip_code': zipCode,
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      if (profileImage != null && profileImage.isNotEmpty) {
        updateData['profile_image'] = profileImage;
      }

      await supabaseClient
          .from('profiles')
          .upsert({'id': user.id, ...updateData}); // Upsert handles insert if not exists
          
      _logger.i('Profile updated successfully for ${user.id}');
    } on PostgrestException catch (e) {
      _logger.e('Failed to update profile: ${e.message}');
      throw ServerException(message: e.message);
    } catch (e) {
      _logger.e('Failed to update profile: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> uploadProfileImage(File file) async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      throw const ServerException(message: 'User is not logged in');
    }

    try {
      final String filePath = '${user.id}/profile.jpg';
      
      await supabaseClient.storage.from('profile-images').upload(
        filePath,
        file,
        fileOptions: const FileOptions(upsert: true),
      );
      
      // We append a timestamp to the public URL just to bypass any local caching issues in the UI
      final String publicUrl = '${supabaseClient.storage.from('profile-images').getPublicUrl(filePath)}?t=${DateTime.now().millisecondsSinceEpoch}';
      _logger.i('Profile image uploaded to: $publicUrl');
      return publicUrl;
    } catch (e) {
      _logger.e('Failed to upload profile image: $e');
      throw ServerException(message: e.toString());
    }
  }
}
