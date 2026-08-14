import 'dart:io';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createProfile({
    required String name,
    required String country,
    required String city,
    required String mobileNumber,
    required String zipCode,
    String? profileImage,
  }) async {
    return await remoteDataSource.createProfile(
      name: name,
      country: country,
      city: city,
      mobileNumber: mobileNumber,
      zipCode: zipCode,
      profileImage: profileImage,
    );
  }

  @override
  Future<ProfileModel> getProfile() async {
    return await remoteDataSource.getProfile();
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
    return await remoteDataSource.updateProfile(
      name: name,
      country: country,
      city: city,
      mobileNumber: mobileNumber,
      zipCode: zipCode,
      profileImage: profileImage,
    );
  }

  @override
  Future<String> uploadProfileImage(File file) async {
    return await remoteDataSource.uploadProfileImage(file);
  }
}
