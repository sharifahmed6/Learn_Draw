import '../repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<void> call({
    required String name,
    required String country,
    required String city,
    required String mobileNumber,
    required String zipCode,
    String? profileImage,
  }) {
    return repository.updateProfile(
      name: name,
      country: country,
      city: city,
      mobileNumber: mobileNumber,
      zipCode: zipCode,
      profileImage: profileImage,
    );
  }
}
