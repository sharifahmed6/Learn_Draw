import '../repositories/profile_repository.dart';

class CreateProfile {
  final ProfileRepository repository;

  CreateProfile(this.repository);

  Future<void> call({
    required String name,
    required String country,
    required String city,
    required String mobileNumber,
    required String zipCode,
    String? profileImage,
  }) {
    return repository.createProfile(
      name: name,
      country: country,
      city: city,
      mobileNumber: mobileNumber,
      zipCode: zipCode,
      profileImage: profileImage,
    );
  }
}
