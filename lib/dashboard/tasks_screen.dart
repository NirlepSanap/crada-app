// task_manager.dart - Create this as a separate file
import 'package:flutter/material.dart';

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

class TaskManager {
  static final TaskManager _instance = TaskManager._internal();
  factory TaskManager() => _instance;
  TaskManager._internal();

  List<Task> _tasks = [
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

  // Get recent pending tasks for dashboard
  List<Task> getRecentPendingTasks({int limit = 3}) {
    return _tasks
        .where((task) => !task.completed)
        .take(limit)
        .toList();
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

// Updated TasksScreen that uses TaskManager

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TaskManager _taskManager = TaskManager();
  String selectedFilter = 'All';
  final List<String> filterOptions = ['All', 'Pending', 'Completed', 'Overdue'];

  @override
  void initState() {
    super.initState();
    _taskManager.addListener(_onTasksUpdated);
  }

  @override
  void dispose() {
    _taskManager.removeListener(_onTasksUpdated);
    super.dispose();
  }

  void _onTasksUpdated() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D3748),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Filter Tabs
            _buildFilterTabs(),
            
            // Tasks List
            Expanded(
              child: _buildTasksList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(),
        backgroundColor: Colors.blue[600],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const Text(
            'Tasks',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () => _showTaskStats(),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.analytics_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filterOptions.length,
        itemBuilder: (context, index) {
          String filter = filterOptions[index];
          bool isSelected = selectedFilter == filter;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[600] : Colors.grey[700],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  '$filter (${_getFilterCount(filter)})',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTasksList() {
    List<Task> filteredTasks = _taskManager.getFilteredTasks(selectedFilter);
    
    if (filteredTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 64, color: Colors.grey[500]),
            const SizedBox(height: 16),
            Text(
              'No tasks found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add a new task',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        return _buildTaskCard(filteredTasks[index]);
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    Color priorityColor = _getPriorityColor(task.priority);
    bool isOverdue = DateTime.now().isAfter(task.dueDate) && !task.completed;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isOverdue ? Border.all(color: Colors.red, width: 2) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showTaskDetails(task),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _taskManager.toggleTaskCompletion(task.id),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: task.completed ? Colors.green : Colors.transparent,
                          border: Border.all(
                            color: task.completed ? Colors.green : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: task.completed
                            ? const Icon(Icons.check, color: Colors.white, size: 16)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: task.completed ? Colors.grey[500] : Colors.black87,
                          decoration: task.completed 
                              ? TextDecoration.lineThrough 
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) => _handleTaskAction(value, task),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                        const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                      ],
                      child: Icon(Icons.more_vert, color: Colors.grey[600]),
                    ),
                  ],
                ),
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: priorityColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        task.priority,
                        style: TextStyle(
                          fontSize: 12,
                          color: priorityColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          isOverdue ? Icons.warning : Icons.schedule,
                          size: 16,
                          color: isOverdue ? Colors.red : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDueDate(task.dueDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: isOverdue ? Colors.red : Colors.grey[600],
                            fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // CRUD Operations using TaskManager
  void _showAddTaskDialog() {
    _showTaskDialog();
  }

  void _showEditTaskDialog(Task task) {
    _showTaskDialog(task: task);
  }

  void _showTaskDialog({Task? task}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descController = TextEditingController(text: task?.description ?? '');
    String selectedPriority = task?.priority ?? 'Medium';
    DateTime selectedDate = task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectedDate);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(task == null ? 'Add New Task' : 'Edit Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                  ),
                  items: ['High', 'Medium', 'Low'].map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedPriority = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setDialogState(() {
                              selectedDate = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: Text(_formatDate(selectedDate)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (time != null) {
                            setDialogState(() {
                              selectedTime = time;
                              selectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                time.hour,
                                time.minute,
                              );
                            });
                          }
                        },
                        icon: const Icon(Icons.access_time),
                        label: Text(selectedTime.format(context)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  if (task == null) {
                    _addTask(
                      titleController.text.trim(),
                      descController.text.trim(),
                      selectedPriority,
                      selectedDate,
                    );
                  } else {
                    _updateTask(
                      task,
                      titleController.text.trim(),
                      descController.text.trim(),
                      selectedPriority,
                      selectedDate,
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(task == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _addTask(String title, String description, String priority, DateTime dueDate) {
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      completed: false,
      priority: priority,
      dueDate: dueDate,
      createdAt: DateTime.now(),
    );
    _taskManager.addTask(newTask);
    _showSnackbar('Task added successfully');
  }

  void _updateTask(Task originalTask, String title, String description, String priority, DateTime dueDate) {
    final updatedTask = Task(
      id: originalTask.id,
      title: title,
      description: description,
      completed: originalTask.completed,
      priority: priority,
      dueDate: dueDate,
      createdAt: originalTask.createdAt,
    );
    _taskManager.updateTask(updatedTask);
    _showSnackbar('Task updated successfully');
  }

  // Helper Methods
  int _getFilterCount(String filter) {
    return _taskManager.getFilteredTasks(filter).length;
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

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return 'Today ${TimeOfDay.fromDateTime(date).format(context)}';
    } else if (difference == 1) {
      return 'Tomorrow ${TimeOfDay.fromDateTime(date).format(context)}';
    } else if (difference == -1) {
      return 'Yesterday ${TimeOfDay.fromDateTime(date).format(context)}';
    } else if (difference > 1) {
      return '${difference} days';
    } else {
      return '${difference.abs()} days ago';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleTaskAction(String action, Task task) {
    switch (action) {
      case 'edit':
        _showEditTaskDialog(task);
        break;
      case 'delete':
        _showDeleteConfirmation(task);
        break;
      case 'duplicate':
        _taskManager.duplicateTask(task);
        _showSnackbar('Task duplicated successfully');
        break;
    }
  }

  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _taskManager.deleteTask(task.id);
              Navigator.pop(context);
              _showSnackbar('Task deleted successfully');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) ...[
              Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(task.description),
              const SizedBox(height: 12),
            ],
            Text('Priority:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(task.priority),
            const SizedBox(height: 12),
            Text('Due Date:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_formatDueDate(task.dueDate)),
            const SizedBox(height: 12),
            Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(task.completed ? 'Completed' : 'Pending'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditTaskDialog(task);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showTaskStats() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Task Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatRow('Total Tasks', _taskManager.totalTasks),
            _buildStatRow('Completed', _taskManager.completedTasks),
            _buildStatRow('Pending', _taskManager.pendingTasks),
            _buildStatRow('Overdue', _taskManager.overdueTasks),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(count.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}