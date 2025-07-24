import 'package:flutter/material.dart';

class LeadsDetailScreen extends StatelessWidget {
  final String statType;
  final String value;

  const LeadsDetailScreen({
    super.key, 
    required this.statType, 
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$statType ($value)', style: const TextStyle(color: Colors.white)),
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
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: int.parse(value),
          itemBuilder: (context, index) {
            return _buildDetailCard('${statType.substring(0, statType.length - 1)} ${index + 1}');
          },
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title) {
    IconData icon;
    Color iconColor;
    
    switch (statType) {
      case 'Leads':
        icon = Icons.person_add;
        iconColor = Colors.blue;
        break;
      case 'Follow-Ups':
        icon = Icons.schedule;
        iconColor = Colors.orange;
        break;
      case 'Messages':
        icon = Icons.message;
        iconColor = Colors.green;
        break;
      case 'Tasks':
        icon = Icons.task_alt;
        iconColor = Colors.purple;
        break;
      default:
        icon = Icons.circle;
        iconColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 25,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Details about $title',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
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
    );
  }
}