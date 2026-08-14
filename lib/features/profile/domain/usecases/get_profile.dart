import '../../data/models/profile_model.dart';
import '../repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;

  GetProfile(this.repository);

  Future<ProfileModel> call() {
    return repository.getProfile();
  }
}
