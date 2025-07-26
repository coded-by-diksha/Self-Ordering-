import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'ProfileModel.dart';
import '../GlobalState.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late ImagePicker imagePicker;
  File? imageFile;
  String? currentImagePath;

  @override
  void initState() {
    final profile = GlobalState().userProfile;
    nameController = TextEditingController(text: profile['name']);
    emailController = TextEditingController(text: profile['email']);
    phoneController = TextEditingController(text: profile['phone']);
    locationController = TextEditingController(text: profile['location']);
    currentImagePath = profile['imagePath'];
    super.initState();
  }

  Widget _buildProfileImage() {
    if (currentImagePath == null) {
      return const CircleAvatar(
        radius: 45,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, size: 45, color: Colors.white),
      );
    }

    if (currentImagePath!.startsWith('assets/')) {
      return CircleAvatar(
        radius: 45,
        backgroundImage: AssetImage(currentImagePath!),
        onBackgroundImageError: (exception, stackTrace) {
          print('Error loading asset image: $exception');
        },
      );
    } else {
      return CircleAvatar(
        radius: 45,
        backgroundImage: FileImage(File(currentImagePath!)),
        onBackgroundImageError: (exception, stackTrace) {
          print('Error loading file image: $exception');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = GlobalState().userProfile;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Edit Profile", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                if (pickedFile != null) {
                  setState(() {
                    currentImagePath = pickedFile.path;
                  });
                  GlobalState().userProfile['imagePath'] = pickedFile.path;
                }
              },
              child: Stack(
                children: [
                  _buildProfileImage(),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit, size: 16),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField("Name", nameController),
            _buildTextField("Email", emailController),
            _buildTextField("Phone", phoneController),
            _buildTextField("Location", locationController),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 155, 15),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  GlobalState().userProfile['name'] = nameController.text;
                  GlobalState().userProfile['email'] = emailController.text;
                  GlobalState().userProfile['phone'] = phoneController.text;
                  GlobalState().userProfile['location'] = locationController.text;
                  Navigator.pop(context);
                },
                child: const Text("SAVE CHANGES", style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }
}
