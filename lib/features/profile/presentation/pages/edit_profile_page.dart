import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/toast_utils.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.saveSuccess) {
          ToastUtils.showTopMessage(context, 'Profile updated successfully!', isError: false);
          Navigator.pop(context);
        } else if (state.status == ProfileStatus.failure && state.errorMessage != null) {
          ToastUtils.showTopMessage(context, state.errorMessage!, isError: true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFF9C4), // Match app theme
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Edit Profile', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
            iconTheme: const IconThemeData(color: Colors.deepPurple),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _showImageSourceBottomSheet(context);
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.deepPurple.shade100,
                        backgroundImage: state.imageUrl.isNotEmpty ? NetworkImage(state.imageUrl) : null,
                        child: state.imageUrl.isEmpty ? const Icon(Icons.person, size: 50, color: Colors.deepPurple) : null,
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.deepPurple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                      if (state.status == ProfileStatus.saving && state.isUploadingImage)
                        const Positioned.fill(
                          child: CircularProgressIndicator(color: Colors.deepPurple),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  context,
                  label: 'Name',
                  icon: Icons.person_outline,
                  initialValue: state.name,
                  onChanged: (val) => context.read<ProfileBloc>().add(UpdateProfileField('name', val)),
                ),
                _buildTextField(
                  context,
                  label: 'Mobile Number',
                  icon: Icons.phone_outlined,
                  initialValue: state.mobileNumber,
                  keyboardType: TextInputType.phone,
                  onChanged: (val) => context.read<ProfileBloc>().add(UpdateProfileField('mobileNumber', val)),
                ),
                _buildTextField(
                  context,
                  label: 'Country',
                  icon: Icons.public,
                  initialValue: state.country,
                  onChanged: (val) => context.read<ProfileBloc>().add(UpdateProfileField('country', val)),
                ),
                _buildTextField(
                  context,
                  label: 'City',
                  icon: Icons.location_city,
                  initialValue: state.city,
                  onChanged: (val) => context.read<ProfileBloc>().add(UpdateProfileField('city', val)),
                ),
                _buildTextField(
                  context,
                  label: 'Zip Code',
                  icon: Icons.markunread_mailbox_outlined,
                  initialValue: state.zipCode,
                  keyboardType: TextInputType.number,
                  onChanged: (val) => context.read<ProfileBloc>().add(UpdateProfileField('zipCode', val)),
                ),
                const SizedBox(height: 32),
                if (state.status == ProfileStatus.saving && !state.isUploadingImage)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      context.read<ProfileBloc>().add(SaveProfile());
                    },
                    child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String initialValue,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  void _showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.deepPurple),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(bottomSheetContext).pop();
                  context.read<ProfileBloc>().add(const PickAndUploadImage(ImageSource.gallery));
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.deepPurple),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(bottomSheetContext).pop();
                  context.read<ProfileBloc>().add(const PickAndUploadImage(ImageSource.camera));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
