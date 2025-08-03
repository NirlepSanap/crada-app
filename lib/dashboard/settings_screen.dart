import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account Section
                _buildSectionTitle('Account'),
                const SizedBox(height: 12),
                _buildSettingsItem(
                  context,
                  Icons.person_outline,
                  'Edit profile',
                  onTap: () => _handleEditProfile(context),
                ),
                _buildSettingsItem(
                  context,
                  Icons.security,
                  'Security',
                  onTap: () => _handleSecurity(context),
                ),
                _buildSettingsItem(
                  context,
                  Icons.notifications_outlined,
                  'Notifications',
                  onTap: () => _handleNotifications(context),
                ),
                _buildSettingsItem(
                  context,
                  Icons.lock_outline,
                  'Privacy',
                  onTap: () => _handlePrivacy(context),
                ),
                
                const SizedBox(height: 32),
                
                // Support & About Section
                _buildSectionTitle('Support & About'),
                const SizedBox(height: 12),
                _buildSettingsItem(
                  context,
                  Icons.credit_card,
                  'My Subscription',
                  onTap: () => _handleSubscription(context),
                ),
                _buildSettingsItem(
                  context,
                  Icons.help_outline,
                  'Help & Support',
                  onTap: () => _handleHelpSupport(context),
                ),
                _buildSettingsItem(
                  context,
                  Icons.info_outline,
                  'Terms and Policies',
                  onTap: () => _handleTermsAndPolicies(context),
                ),
                
                const SizedBox(height: 32),
                
                // Theme Section
                _buildSectionTitle('Theme'),
                const SizedBox(height: 12),
                _buildThemeToggle(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    IconData icon,
    String title, {
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.grey[700],
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[600],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildThemeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: Colors.grey[700],
            size: 20,
          ),
        ),
        title: const Text(
          'Dark/light',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Switch(
          value: isDarkMode,
          onChanged: (value) {
            setState(() {
              isDarkMode = value;
            });
            _handleThemeToggle(value);
          },
          activeColor: Colors.blue,
        ),
      ),
    );
  }

  // Handle Edit Profile
  void _handleEditProfile(BuildContext context) {
    _showSnackBar(context, 'Edit Profile clicked');
    // Navigate to edit profile screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
  }

  // Handle Security
  void _handleSecurity(BuildContext context) {
    _showSnackBar(context, 'Security settings clicked');
    // Navigate to security settings
  }

  // Handle Notifications
  void _handleNotifications(BuildContext context) {
    _showSnackBar(context, 'Notification settings clicked');
    // Navigate to notification settings
  }

  // Handle Privacy
  void _handlePrivacy(BuildContext context) {
    _showSnackBar(context, 'Privacy settings clicked');
    // Navigate to privacy settings
  }

  // Handle Subscription
  void _handleSubscription(BuildContext context) {
    _showSnackBar(context, 'My Subscription clicked');
    // Navigate to subscription screen
  }

  // Handle Help & Support
  void _handleHelpSupport(BuildContext context) {
    _showSnackBar(context, 'Help & Support clicked');
    // Navigate to help & support screen
  }

  // Handle Terms and Policies
  void _handleTermsAndPolicies(BuildContext context) {
    _showSnackBar(context, 'Terms and Policies clicked');
    // Navigate to terms and policies screen
  }

  // Handle Theme Toggle
  void _handleThemeToggle(bool isDark) {
    _showSnackBar(context, isDark ? 'Dark mode enabled' : 'Light mode enabled');
    // Implement theme switching logic here
    // You might want to use a state management solution like Provider, Bloc, or Riverpod
  }

  // Helper method to show snackbar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.grey[700],
      ),
    );
  }
}