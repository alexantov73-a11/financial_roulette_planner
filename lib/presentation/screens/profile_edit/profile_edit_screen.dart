import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../viewmodels/profile_edit_viewmodel.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: Consumer<ProfileEditViewModel>(
          builder: (context, viewModel, _) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showPhotoOptions(context, viewModel),
                  child: Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: viewModel.photoPath.isNotEmpty
                          ? FileImage(File(viewModel.photoPath))
                          : null,
                      child: viewModel.photoPath.isEmpty
                          ? Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (v) => viewModel.setName(v),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () async {
                            await viewModel.saveProfile();
                            if (mounted) {
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            }
                          },
                    child: viewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPhotoOptions(BuildContext context, ProfileEditViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final path = await viewModel.pickFromCamera();
                if (path != null) {
                  viewModel.setPhoto(path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final path = await viewModel.pickFromGallery();
                if (path != null) {
                  viewModel.setPhoto(path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
