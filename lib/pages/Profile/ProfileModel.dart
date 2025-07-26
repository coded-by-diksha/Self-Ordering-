import 'package:flutter/material.dart';

class ProfileModel with ChangeNotifier {
  String name;
  String email;
  String phone;
  String location;
  String imagePath;

  ProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.imagePath,
  });

  void updateProfile({
    String? newName,
    String? newEmail,
    String? newPhone,
    String? newLocation,
    String? newImagePath,
  }) {
    if (newName != null) name = newName;
    if (newEmail != null) email = newEmail;
    if (newPhone != null) phone = newPhone;
    if (newLocation != null) location = newLocation;
    if (newImagePath != null) imagePath = newImagePath;

    notifyListeners();
  }

  void updateImage(String path) {
    imagePath = path;
    notifyListeners();
  }
}
