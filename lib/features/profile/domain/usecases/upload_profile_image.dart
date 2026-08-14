import 'dart:io';
import '../repositories/profile_repository.dart';

class UploadProfileImage {
  final ProfileRepository repository;

  UploadProfileImage(this.repository);

  Future<String> call(File file) {
    return repository.uploadProfileImage(file);
  }
}
