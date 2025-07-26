import 'package:flutter/material.dart';
import 'package:spicebite/pages/CartPage.dart';
import 'package:spicebite/pages/Register/login.dart';
import 'EditProfilePage.dart';
import 'dart:io';
import 'package:spicebite/pages/GlobalState.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:spicebite/pages/Payment/PaymentMethodSheet.dart';
import 'package:spicebite/pages/Profile/PromoCodesPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final globalState = GlobalState();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 248, 145, 10),
        elevation: 0,
      ),
      body: globalState.isLoggedIn ? _buildProfileView(globalState) : _buildLoginPrompt(),
    );
  }

  Widget _buildProfileView(GlobalState globalState) {
    final profile = globalState.userProfile;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color.fromARGB(255, 248, 145, 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _onProfileImageTap(profile),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: globalState.getProfileImage(),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile['name'], style: const TextStyle(color: Colors.white, fontSize: 18)),
                  Text(profile['email'], style: const TextStyle(color: Colors.white70)),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  ).then((_) {
                    if (context.mounted) {
                      setState(() {});
                    }
                  });
                },
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            children: [
              _buildListTile(Icons.payment, "Payment Method", () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => PaymentMethodSheet(
                    amount: globalState.cartTotal,
                    tableNumber: globalState.tableNo ?? 0,
                    orderItems: List<Map<String, dynamic>>.from(globalState.cartItems),
                  ),
                );
              }),
              _buildListTile(Icons.card_giftcard, "My Promocodes", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PromocodesPage()),
                );
              }),
              _buildListTile(Icons.favorite_border, "My Orders", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  CartPage()),
                );
              }),
              _buildListTile(Icons.logout, "Sign Out", _handleSignOut),
            ],
          ),
        ),
      ],
    );
  }

  ImageProvider getProfileImage(String path) {
    if (path.startsWith('assets/')) {
      return AssetImage(path);
    } else if (kIsWeb) {
      // On web, FileImage is not supported. Use a placeholder or network image.
      return AssetImage('assets/logo.png'); // fallback
    } else {
      return FileImage(File(path));
    }
  }

  void _onProfileImageTap(Map<String, dynamic> profile) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Profile Picture'),
        children: [
          SimpleDialogOption(
            child: const Text('Preview'),
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Image(
                      image: getProfileImage(profile['imagePath']),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
          SimpleDialogOption(
            child: const Text('Change Profile Image'),
            onPressed: () async {
              Navigator.pop(context);
              final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
              if (picked != null) {
                setState(() {
                  GlobalState().userProfile['imagePath'] = picked.path;
                  GlobalState().updateProfileImage(picked.path);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_off_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            'You are not logged in.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              ).then((_) => setState(() {}));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 248, 145, 10),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text('Please Login', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handleSignOut() {
    final globalState = GlobalState();
    setState(() {
      globalState.isLoggedIn = false;
    });
  }

  Widget _buildListTile(IconData icon, String title, [VoidCallback? onTap]) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap ?? () {},
    );
  }
}