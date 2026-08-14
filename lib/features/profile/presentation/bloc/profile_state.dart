import 'package:equatable/equatable.dart';

enum ProfileStatus { initial, loading, success, failure, saving, saveSuccess, deleteSuccess }

class ProfileState extends Equatable {
  final String name;
  final String imageUrl;
  final String mobileNumber;
  final String country;
  final String city;
  final String zipCode;
  final ProfileStatus status;
  final String? errorMessage;
  final bool isUploadingImage;

  const ProfileState({
    this.name = '',
    this.imageUrl = '',
    this.mobileNumber = '',
    this.country = '',
    this.city = '',
    this.zipCode = '',
    this.status = ProfileStatus.initial,
    this.errorMessage,
    this.isUploadingImage = false,
  });

  ProfileState copyWith({
    String? name,
    String? imageUrl,
    String? mobileNumber,
    String? country,
    String? city,
    String? zipCode,
    ProfileStatus? status,
    String? errorMessage,
    bool? isUploadingImage,
  }) {
    return ProfileState(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      country: country ?? this.country,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      status: status ?? this.status,
      errorMessage: errorMessage,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
    );
  }

  @override
  List<Object?> get props => [
        name,
        imageUrl,
        mobileNumber,
        country,
        city,
        zipCode,
        status,
        errorMessage,
        isUploadingImage,
      ];
}
