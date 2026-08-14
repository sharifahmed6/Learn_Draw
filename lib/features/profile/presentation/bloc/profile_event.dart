import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfileField extends ProfileEvent {
  final String field;
  final String value;

  const UpdateProfileField(this.field, this.value);

  @override
  List<Object?> get props => [field, value];
}

class SaveProfile extends ProfileEvent {}

class DeleteAccountRequested extends ProfileEvent {}

class PickAndUploadImage extends ProfileEvent {
  final ImageSource source;
  const PickAndUploadImage(this.source);

  @override
  List<Object> get props => [source];
}

class ProfileUpdatedExternally extends ProfileEvent {
  final Map<String, dynamic> newRecord;
  const ProfileUpdatedExternally(this.newRecord);

  @override
  List<Object> get props => [newRecord];
}
