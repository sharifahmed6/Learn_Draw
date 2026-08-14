import '../../domain/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
  });

  factory UserModel.fromSupabaseUser(sb.User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
    );
  }
}
