// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Business_logic_layer/user/user_cubit.dart';
import '../../../data_layer/user/user.dart';
import '../../../styles/color.dart';
import '../favorite/favorite.dart';
import '../login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // جلب بيانات المستخدم عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserCubit>().fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primColor,
        elevation: 0,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserSuccess) {
            return _buildProfileContent(state.user);
          } else if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${state.message}"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.read<UserCubit>().fetchUser(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else {
            // UserInitial - لم يتم تسجيل الدخول
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Please login to view your profile"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text("Login"),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(User user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // --- الجزء العلوي: الخلفية والصورة الشخصية ---
          _buildHeader(user),

          const SizedBox(height: 30),

          // --- معلومات المستخدم الإضافية ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Personal Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildInfoRow(Icons.person, "Username", user.username!),
                  const SizedBox(height: 10),
                  _buildInfoRow(Icons.email, "Email", user.email!),
                  if (user.firstName != null) ...[
                    const SizedBox(height: 10),
                    _buildInfoRow(Icons.person_outline, "First Name", user.firstName!),
                  ],
                  if (user.lastName != null) ...[
                    const SizedBox(height: 10),
                    _buildInfoRow(Icons.person_outline, "Last Name", user.lastName!),
                  ],



                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // --- الجزء السفلي: قائمة الإعدادات والأزرار ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.favorite_rounded,
                    title: "My Wishlist",
                    iconColor: Colors.redAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FavoriteScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuTile(
                    icon: Icons.edit_rounded,
                    title: "Edit Profile",
                    iconColor: Colors.greenAccent,
                    onTap: () {
                      // الانتقال لصفحة تعديل الملف الشخصي
                    },
                  ),
                  _buildDivider(),
                  _buildMenuTile(
                    icon: Icons.settings_rounded,
                    title: "Settings",
                    iconColor: Colors.blueAccent,
                    onTap: () {
                      // الانتقال لصفحة الإعدادات
                    },
                  ),
                  _buildDivider(),
                  _buildMenuTile(
                    icon: Icons.help_outline_rounded,
                    title: "Help & Support",
                    iconColor: Colors.orangeAccent,
                    onTap: () {
                      // الدعم الفني
                    },
                  ),
                  _buildDivider(),
                  _buildMenuTile(
                    icon: Icons.logout_rounded,
                    title: "Logout",
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () => _showLogoutDialog(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "App Version 1.0.0",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: primColor, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- واجهة الجزء العلوي (الصورة والبيانات الشخصية) ---
  Widget _buildHeader(User user) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: primColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
        Positioned(
          bottom: 0,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey[200],
                      child: user.image != null
                          ? ClipOval(
                        child: Image.network(
                          user.image!,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18,
                    child: CircleAvatar(
                      backgroundColor: primColor,
                      radius: 16,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                user.username!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email!,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- واجهة عنصر القائمة Reusable ListTile ---
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color iconColor,
    Color textColor = Colors.black87,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
    );
  }

  // --- نافذة التأكيد قبل تسجيل الخروج ---
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              // تسجيل الخروج من UserCubit
              context.read<UserCubit>().logout();

              // الانتقال لشاشة Login
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}