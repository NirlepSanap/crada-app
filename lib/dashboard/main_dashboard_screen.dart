import 'package:flutter/material.dart';
import 'people_screen.dart';
import 'call_screen.dart';
import 'profile_screen.dart';
import 'tasks_screen.dart';
import 'followups_screen.dart';

// Task Model
class Task {
  String id;
  String title;
  String description;
  bool completed;
  String priority;
  DateTime dueDate;
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.priority,
    required this.dueDate,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'priority': priority,
      'dueDate': dueDate,
      'createdAt': createdAt,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      completed: map['completed'],
      priority: map['priority'],
      dueDate: map['dueDate'],
      createdAt: map['createdAt'],
    );
  }
}

// Task Manager
class TaskManager {
  static final TaskManager _instance = TaskManager._internal();
  factory TaskManager() => _instance;
  TaskManager._internal();

  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Follow up with client presentation',
      description: 'Send follow-up email after yesterday\'s presentation',
      completed: false,
      priority: 'High',
      dueDate: DateTime.now().add(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Task(
      id: '2',
      title: 'Review quarterly report',
      description: 'Complete review of Q3 financial report',
      completed: false,
      priority: 'Medium',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Task(
      id: '3',
      title: 'Team meeting preparation',
      description: 'Prepare agenda and materials for Monday team meeting',
      completed: true,
      priority: 'Medium',
      dueDate: DateTime.now().subtract(const Duration(hours: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Task(
      id: '4',
      title: 'Update project documentation',
      description: 'Update technical documentation for recent changes',
      completed: false,
      priority: 'Low',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  List<Task> get tasks => _tasks;
  
  void addTask(Task task) {
    _tasks.add(task);
    _notifyListeners();
  }
  
  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      _notifyListeners();
    }
  }
  
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _notifyListeners();
  }

  void toggleTaskCompletion(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].completed = !_tasks[index].completed;
      _notifyListeners();
    }
  }

  void duplicateTask(Task originalTask) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '${originalTask.title} (Copy)',
      description: originalTask.description,
      completed: false,
      priority: originalTask.priority,
      dueDate: originalTask.dueDate.add(const Duration(days: 1)),
      createdAt: DateTime.now(),
    );
    _tasks.add(newTask);
    _notifyListeners();
  }
  
  // Statistics getters
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((task) => task.completed).length;
  int get pendingTasks => _tasks.where((task) => !task.completed).length;
  int get overdueTasks => _tasks.where((task) => 
    DateTime.now().isAfter(task.dueDate) && !task.completed
  ).length;
  int get todayTasks => _tasks.where((task) => 
    task.dueDate.year == DateTime.now().year &&
    task.dueDate.month == DateTime.now().month &&
    task.dueDate.day == DateTime.now().day
  ).length;
  
  // Get filtered tasks
  List<Task> getFilteredTasks(String filter) {
    switch (filter) {
      case 'Pending':
        return _tasks.where((task) => !task.completed).toList();
      case 'Completed':
        return _tasks.where((task) => task.completed).toList();
      case 'Overdue':
        return _tasks.where((task) => 
          DateTime.now().isAfter(task.dueDate) && !task.completed
        ).toList();
      default:
        return _tasks;
    }
  }

  // Get recent pending tasks for dashboard (sorted by due date)
  List<Task> getRecentPendingTasks({int limit = 3}) {
    return _tasks
        .where((task) => !task.completed)
        .toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate))
        ..take(limit);
  }

  // Simple listener pattern for updates
  final List<VoidCallback> _listeners = [];
  
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }
  
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
  
  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}

// Follow-up Model and Manager (existing code)
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

class FollowUpManager {
  static final FollowUpManager _instance = FollowUpManager._internal();
  factory FollowUpManager() => _instance;
  FollowUpManager._internal();

  final List<FollowUpItem> _followUps = [
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

// Main Dashboard Screen
class MainDashboardScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  
  const MainDashboardScreen({
    super.key,
    this.userData,
  });

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  int _selectedIndex = 0;
  final FollowUpManager _followUpManager = FollowUpManager();
  final TaskManager _taskManager = TaskManager();

  @override
  void initState() {
    super.initState();
    // Listen for updates when returning from other screens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
    
    // Add listeners for real-time updates
    _taskManager.addListener(_refreshData);
  }

  @override
  void dispose() {
    _taskManager.removeListener(_refreshData);
    super.dispose();
  }

  void _refreshData() {
    if (mounted) {
      setState(() {
        // This will trigger a rebuild with updated data
      });
    }
  }

  // Method to get user's display name
  String _getUserDisplayName() {
    if (widget.userData != null) {
      String firstName = widget.userData!['firstName'] ?? '';
      String lastName = widget.userData!['lastName'] ?? '';
      
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
          MaterialPageRoute(builder: (context) => ProfileScreen(userData: widget.userData))
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
        // Navigate to Tasks and refresh data when returning
        await Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => const TasksScreen())
        );
        _refreshData(); // Refresh dashboard when returning from tasks
        break;
    }
  }

  void _onProfileTapped() async {
    await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => ProfileScreen(userData: widget.userData))
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
    } else if (statType == 'Tasks') {
      // Navigate to tasks screen when tapping the tasks stat card
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => const TasksScreen())
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

  void _onTaskTapped(Task task) {
    // Navigate to tasks screen
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const TasksScreen())
    ).then((_) => _refreshData());
    _showSnackBar('Opening ${task.title} task details');
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
    
    // Get current task stats
    final totalTasks = _taskManager.totalTasks;
    final pendingTasks = _taskManager.pendingTasks;
    final todayTasks = _taskManager.todayTasks;
    final overdueTasks = _taskManager.overdueTasks;
    
    // Get recent follow-ups for display (top 3)
    final recentFollowUps = _followUpManager.followUps
        .where((item) => item.status != 'Completed' && item.status != 'Cancelled')
        .take(3)
        .toList();

    // Get recent pending tasks for display (top 3)
    final recentTasks = _taskManager.getRecentPendingTasks(limit: 3);

    // Determine what to show in the main section
    bool showTasks = recentTasks.isNotEmpty && (recentFollowUps.isEmpty || todayTasks > 0 || overdueTasks > 0);

    return Scaffold(
      backgroundColor: const Color(0xFF5C5C5C),
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

            // Welcome Section with Dynamic User Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Welcome, ${_getUserDisplayName()}!',
                      style: const TextStyle(
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
                      _getWelcomeMessage(todayFollowUps, todayTasks, overdueTasks),
                      style: TextStyle(
                        fontSize: 14,
                        color: (todayFollowUps > 0 || todayTasks > 0 || overdueTasks > 0) 
                          ? Colors.orange[300] 
                          : Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Stats Cards - Updated with real task data
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
                      Expanded(child: _buildStatCard('$totalTasks', 'Tasks')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Dynamic Section - Shows Recent Tasks or Follow-ups based on priority
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
                          showTasks ? 'Recent Tasks' : 
                          recentFollowUps.isNotEmpty ? 'Recent Follow-Ups' : 'Leads',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        if (showTasks || recentFollowUps.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              if (showTasks) {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => const TasksScreen())
                                ).then((_) => _refreshData());
                              } else {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => const FollowUpsScreen())
                                ).then((_) => _refreshData());
                              }
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
                        children: showTasks
                            ? recentTasks.map((task) => _buildTaskItem(task)).toList()
                            : recentFollowUps.isNotEmpty
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

            // Bottom Navigation - Updated with task notification badge
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
                  Stack(
                    children: [
                      _buildNavItem(4, Icons.task, false),
                      if (pendingTasks > 0 || overdueTasks > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: overdueTasks > 0 ? Colors.red : Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              overdueTasks > 0 ? '$overdueTasks' : '$pendingTasks',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWelcomeMessage(int todayFollowUps, int todayTasks, int overdueTasks) {
    if (overdueTasks > 0) {
      return 'You have $overdueTasks overdue task${overdueTasks > 1 ? 's' : ''}!';
    } else if (todayTasks > 0 && todayFollowUps > 0) {
      return 'You have $todayTasks task${todayTasks > 1 ? 's' : ''} and $todayFollowUps follow-up${todayFollowUps > 1 ? 's' : ''} today';
    } else if (todayTasks > 0) {
      return 'You have $todayTasks task${todayTasks > 1 ? 's' : ''} due today';
    } else if (todayFollowUps > 0) {
      return 'You have $todayFollowUps follow-up${todayFollowUps > 1 ? 's' : ''} today';
    } else {
      return 'Rh 10:10 mn 17th Ah';
    }
  }

  Widget _buildStatCard(String value, String label) {
    bool isHighlighted = (label == 'Follow-Ups' && int.tryParse(value) != null && int.parse(value) > 0) ||
                        (label == 'Tasks' && int.tryParse(value) != null && int.parse(value) > 0);
    
    return GestureDetector(
      onTap: () => _onStatCardTapped(label, value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // Add subtle shadow for active cards
          boxShadow: isHighlighted
              ? [
                  BoxShadow(
                    color: (label == 'Tasks' ? Colors.green : Colors.blue).withOpacity(0.1),
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
                color: label == 'Follow-Ups' ? Colors.blue[700] :
                       label == 'Tasks' ? Colors.green[700] : Colors.black87,
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

  Widget _buildTaskItem(Task task) {
    Color priorityColor = _getPriorityColor(task.priority);
    bool isOverdue = DateTime.now().isAfter(task.dueDate) && !task.completed;
    bool isToday = task.dueDate.year == DateTime.now().year &&
                   task.dueDate.month == DateTime.now().month &&
                   task.dueDate.day == DateTime.now().day;

    return GestureDetector(
      onTap: () => _onTaskTapped(task),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isOverdue ? Border.all(color: Colors.red, width: 2) :
                  isToday ? Border.all(color: Colors.orange, width: 2) : null,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _taskManager.toggleTaskCompletion(task.id);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: task.completed 
                    ? Colors.green.withOpacity(0.2)
                    : priorityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  task.completed ? Icons.check : Icons.schedule,
                  color: task.completed ? Colors.green : priorityColor,
                  size: 20,
                ),
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
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: task.completed ? Colors.grey[500] : Colors.black87,
                            decoration: task.completed 
                              ? TextDecoration.lineThrough 
                              : TextDecoration.none,
                          ),
                        ),
                      ),
                      if (isOverdue)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Overdue',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else if (isToday)
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
                  if (task.description.isNotEmpty)
                    Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: priorityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task.priority,
                          style: TextStyle(
                            fontSize: 10,
                            color: priorityColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatTaskDate(task.dueDate),
                        style: TextStyle(
                          fontSize: 10,
                          color: isOverdue ? Colors.red[700] : 
                                 isToday ? Colors.orange[700] : Colors.grey[600],
                          fontWeight: (isOverdue || isToday) ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ],
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

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatTaskDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return 'Today ${TimeOfDay.fromDateTime(date).format(context)}';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 1) {
      return '$difference days';
    } else {
      return '${difference.abs()} days ago';
    }
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