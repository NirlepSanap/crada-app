import 'package:flutter/material.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});
  
  BuildContext? get context => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calls', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF374151),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF374151),
              Color(0xFF111827),
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: 8,
          itemBuilder: (context, index) {
            return _buildCallCard('Contact ${index + 1}', '${index % 2 == 0 ? 'Incoming' : 'Outgoing'}', '${index + 1}0 min ago');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Make a call')),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.phone, color: Colors.white),
      ),
    );
  }

  Widget _buildCallCard(String name, String type, String time) {
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
              color: type == 'Incoming' ? Colors.green[100] : Colors.blue[100],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              type == 'Incoming' ? Icons.call_received : Icons.call_made,
              color: type == 'Incoming' ? Colors.green : Colors.blue,
              size: 25,
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
                const SizedBox(height: 4),
                Text(
                  '$type • $time',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context!).showSnackBar(
                SnackBar(content: Text('Calling $name...')),
              );
            },
            icon: const Icon(Icons.phone, color: Colors.green),
          ),
        ],
      ),
    );
  }
}