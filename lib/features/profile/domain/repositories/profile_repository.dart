import 'dart:io';
import '../../data/models/profile_model.dart';

abstract class ProfileRepository {
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
