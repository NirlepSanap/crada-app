import 'package:flutter/material.dart';
import 'people_screen.dart';
import 'call_screen.dart';
import 'profile_screen.dart';
import 'tasks_screen.dart';
import 'followups_screen.dart'; 

// Shared data model for follow-up items (should be in a separate file in a real app)
class FollowUpItem {
  String id;
  String name;
  String description;
  DateTime date;
  TimeOfDay time;
  String status;

  FollowUpItem({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    required this.status,
  });
}

// Global follow-ups list (in a real app, use state management like Provider, Riverpod, or Bloc)
class FollowUpManager {
  static final FollowUpManager _instance = FollowUpManager._internal();
  factory FollowUpManager() => _instance;
  FollowUpManager._internal();

  List<FollowUpItem> _followUps = [
    FollowUpItem(
      id: '1',
      name: 'James Smith',
      description: 'Follow up on proposal discussion',
      date: DateTime.now().add(const Duration(days: 1)),
      time: const TimeOfDay(hour: 10, minute: 0),
      status: 'Open',
    ),
    FollowUpItem(
      id: '2',
      name: 'Olivia Taylor',
      description: 'Schedule product demo',
      date: DateTime.now().add(const Duration(days: 2)),
      time: const TimeOfDay(hour: 14, minute: 30),
      status: 'Open',
    ),
    FollowUpItem(
      id: '3',
      name: 'Jaden Smith',
      description: 'Send pricing information',
      date: DateTime.now().add(const Duration(days: 3)),
      time: const TimeOfDay(hour: 11, minute: 0),
      status: 'Completed',
    ),
  ];

  List<FollowUpItem> get followUps => _followUps;
  
  void addFollowUp(FollowUpItem item) {
    _followUps.add(item);
  }
  
  void updateFollowUp(FollowUpItem item) {
    final index = _followUps.indexWhere((f) => f.id == item.id);
    if (index != -1) {
      _followUps[index] = item;
    }
  }
  
  void deleteFollowUp(String id) {
    _followUps.removeWhere((item) => item.id == id);
  }
  
  int get pendingCount => _followUps.where((item) => item.status != 'Completed' && item.status != 'Cancelled').length;
  int get todayCount => _followUps.where((item) => 
    item.date.year == DateTime.now().year &&
    item.date.month == DateTime.now().month &&
    item.date.day == DateTime.now().day
  ).length;
}

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _selectedIndex = 0;
  final FollowUpManager _followUpManager = FollowUpManager();

  @override
  void initState() {
    super.initState();
    // Listen for updates when returning from other screens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  void _refreshData() {
    if (mounted) {
      setState(() {
        // This will trigger a rebuild with updated data
      });
    }
  }

  // Navigation methods
  void _onNavItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        await Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const PeopleScreen())
        );
        break;
      case 1:
        await Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const CallScreen())
        );
        break;
      case 2:
        await Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const ProfileScreen())
        );
        break;
      case 3:
        // Navigate to Follow-ups and refresh data when returning
        await Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const FollowUpsScreen())
        );
        _refreshData(); // Refresh dashboard when returning from follow-ups
        break;
      case 4:
        await Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const TasksScreen())
        );
        break;
    }
  }

  void _onProfileTapped() async {
    await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const ProfileScreen())
    );
  }

  void _onMenuTapped() {
    _showSnackBar('Menu Opened');
  }

  void _onLeadTapped(String leadName) {
    _showSnackBar('Opening $leadName details');
  }

  void _onStatCardTapped(String statType, String value) {
    if (statType == 'Follow-Ups') {
      // Navigate to follow-ups screen when tapping the follow-ups stat card
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => const FollowUpsScreen())
      ).then((_) => _refreshData());
    } else {
      _showSnackBar('$statType: $value items');
    }
  }

  void _onFollowUpTapped(FollowUpItem item) {
    // Navigate to follow-ups screen and scroll to specific item
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const FollowUpsScreen())
    ).then((_) => _refreshData());
    _showSnackBar('Opening ${item.name} follow-up details');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.grey[700],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get current follow-up stats
    final totalFollowUps = _followUpManager.followUps.length;
    final pendingFollowUps = _followUpManager.pendingCount;
    final todayFollowUps = _followUpManager.todayCount;
    
    // Get recent follow-ups for display (top 3)
    final recentFollowUps = _followUpManager.followUps
        .where((item) => item.status != 'Completed' && item.status != 'Cancelled')
        .take(3)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      body: SafeArea(
        child: Column(
          children: [
            // Header with status bar indicators
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _onMenuTapped,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  
                  GestureDetector(
                    onTap: _onProfileTapped,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Welcome Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Welcome, Alex !',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      todayFollowUps > 0 
                        ? 'You have $todayFollowUps follow-ups today'
                        : 'Rh 10:10 mn 17th Ah',
                      style: TextStyle(
                        fontSize: 14,
                        color: todayFollowUps > 0 ? Colors.orange[300] : Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Stats Cards - Updated with real follow-up data
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildStatCard('41', 'Leads')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildStatCard('$totalFollowUps', 'Follow-Ups')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildStatCard('17', 'Messages')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildStatCard('8', 'Tasks')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Dynamic Section - Shows Recent Follow-ups if available, otherwise Leads
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          recentFollowUps.isNotEmpty ? 'Recent Follow-Ups' : 'Leads',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        if (recentFollowUps.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const FollowUpsScreen())
                              ).then((_) => _refreshData());
                            },
                            child: Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[300],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: recentFollowUps.isNotEmpty
                            ? recentFollowUps.map((item) => _buildFollowUpItem(item)).toList()
                            : [
                                _buildLeadItem('James Smith', 'james.smith'),
                                _buildLeadItem('Olivia Taylor', 'olivia.taylor'),
                                _buildLeadItem('Jaden Smith', 'jaden.smith'),
                              ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              decoration: const BoxDecoration(
                color: Color(0xFF1F2937),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.people, true),
                  _buildNavItem(1, Icons.phone, false),
                  _buildNavItem(2, Icons.person, true),
                  Stack(
                    children: [
                      _buildNavItem(3, Icons.follow_the_signs, false),
                      if (pendingFollowUps > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$pendingFollowUps',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  _buildNavItem(4, Icons.work, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return GestureDetector(
      onTap: () => _onStatCardTapped(label, value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // Add subtle shadow for follow-ups card
          boxShadow: label == 'Follow-Ups' && int.tryParse(value) != null && int.parse(value) > 0
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: label == 'Follow-Ups' ? Colors.blue[700] : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowUpItem(FollowUpItem item) {
    Color statusColor = item.status == 'Completed' 
        ? Colors.green 
        : item.status == 'In Progress' 
            ? Colors.orange 
            : item.status == 'Cancelled'
                ? Colors.red
                : Colors.blue;

    bool isToday = item.date.year == DateTime.now().year &&
                   item.date.month == DateTime.now().month &&
                   item.date.day == DateTime.now().day;

    return GestureDetector(
      onTap: () => _onFollowUpTapped(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isToday ? Border.all(color: Colors.orange, width: 2) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.schedule,
                color: statusColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (isToday)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.date.day}/${item.date.month} at ${item.time.format(context)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: isToday ? Colors.orange[700] : Colors.grey[600],
                      fontWeight: isToday ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
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

  Widget _buildLeadItem(String name, String subtitle) {
    return GestureDetector(
      onTap: () => _onLeadTapped(name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.person,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
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

  Widget _buildNavItem(int index, IconData icon, bool hasContainer) {
    bool isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: hasContainer
          ? Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[600] : Colors.grey[600],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            )
          : Icon(
              icon,
              color: isSelected ? Colors.blue[400] : Colors.grey[400],
              size: 24,
            ),
    );
  }
}