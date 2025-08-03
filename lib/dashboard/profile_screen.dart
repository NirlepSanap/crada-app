import 'package:flutter/material.dart';
import 'settings_screen.dart'; // Import the settings screen

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;
  
  const ProfileScreen({
    super.key,
    this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF5C5C5C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5C5C5C),
              Color(0xFF111827),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.grey[600],
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            _getUserDisplayName(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _showEditNameDialog(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.blue[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getUserEmail(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (_getUserPhoneNumber().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        _getUserPhoneNumber(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Profile Options
              _buildProfileOption(context, Icons.edit, 'Edit Profile'),
              _buildProfileOption(context, Icons.settings, 'Settings'),
              _buildProfileOption(context, Icons.privacy_tip, 'Privacy'),
              _buildProfileOption(context, Icons.help, 'Help & Support'),
              _buildProfileOption(context, Icons.logout, 'Logout', isLast: true),
            ],
          ),
        ),
      ),
    );
  }

  // Method to get user's display name
  String _getUserDisplayName() {
    if (userData != null) {
      String firstName = userData!['firstName'] ?? '';
      String lastName = userData!['lastName'] ?? '';
      
      if (firstName.isNotEmpty && lastName.isNotEmpty) {
        return '$firstName $lastName';
      } else if (firstName.isNotEmpty) {
        return firstName;
      } else if (lastName.isNotEmpty) {
        return lastName;
      }
    }
    return 'LazyDeveloper'; // Fallback to original text
  }

  // Method to get user's email
  String _getUserEmail() {
    if (userData != null && userData!['email'] != null && userData!['email'].toString().isNotEmpty) {
      return userData!['email'];
    }
    return 'LazyDeveloper@gmail.com'; // Fallback to original email
  }

  // Method to get user's phone number
  String _getUserPhoneNumber() {
    if (userData != null && userData!['phoneNumber'] != null && userData!['phoneNumber'].toString().isNotEmpty) {
      return userData!['phoneNumber'];
    }
    return ''; // Return empty string if no phone number
  }

  void _showEditNameDialog(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    
    // Pre-fill with current values if available
    if (userData != null) {
      firstNameController.text = userData!['firstName'] ?? '';
      lastNameController.text = userData!['lastName'] ?? '';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Here you would typically update the userData
                // For now, just show a success message
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Name updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Navigate to create account screen and clear all previous routes
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/create-account', // Replace with your create account route
                  (route) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileOption(BuildContext context, IconData icon, String title, {bool isLast = false}) {
    return GestureDetector(
      onTap: () {
        if (title == 'Logout') {
          _handleLogout(context);
        } else if (title == 'Settings') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            ),
          );
        } else {
          // Handle other profile options
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title clicked'),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.grey[700],
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: title == 'Logout' ? Colors.red[100] : Colors.grey[400],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: title == 'Logout' ? Colors.red[600] : Colors.grey[600],
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: title == 'Logout' ? Colors.red[600] : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}