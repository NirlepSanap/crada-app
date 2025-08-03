import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  final List<Map<String, dynamic>> callHistory = const [
    {
      'name': 'James Smith',
      'phone': '+1234567890',
      'type': 'Incoming',
      'time': '10 min ago',
      'duration': '5:23'
    },
    {
      'name': 'Jaden Smith',
      'phone': '+1122334455',
      'type': 'Incoming',
      'time': '1 hour ago',
      'duration': '8:12'
    },
    {
      'name': 'John Walker',
      'phone': '+1555666777',
      'type': 'Missed',
      'time': '2 hours ago',
      'duration': '0:00'
    },
    {
      'name': 'Alan Rich',
      'phone': '+1999888777',
      'type': 'Outgoing',
      'time': '3 hours ago',
      'duration': '12:34'
    },
    {
      'name': 'Jay Taylor',
      'phone': '+1444555666',
      'type': 'Incoming',
      'time': '1 day ago',
      'duration': '3:21'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5C5C5C),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Call Logs',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showCallOptionsMenu(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  _buildFilterTab('Recents', true),
                  _buildFilterTab('Favourites', false),
                  _buildFilterTab('Missed', false),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Search Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(Icons.tune, color: Colors.grey[600], size: 20),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Call History List
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  itemCount: callHistory.length,
                  itemBuilder: (context, index) {
                    final call = callHistory[index];
                    return _buildCallCard(
                      context,
                      call['name'],
                      call['phone'],
                      call['type'],
                      call['time'],
                      call['duration'],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialpad(context),
        backgroundColor: Colors.green,
        child: const Icon(Icons.phone, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterTab(String text, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.black87 : Colors.white70,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCallCard(BuildContext context, String name, String phone, 
                       String type, String time, String duration) {
    Color typeColor;
    IconData typeIcon;
    
    switch (type) {
      case 'Incoming':
        typeColor = Colors.green;
        typeIcon = Icons.call_received;
        break;
      case 'Outgoing':
        typeColor = Colors.blue;
        typeIcon = Icons.call_made;
        break;
      case 'Missed':
        typeColor = Colors.red;
        typeIcon = Icons.call_received;
        break;
      default:
        typeColor = Colors.grey;
        typeIcon = Icons.phone;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar with Call Type Indicator
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.grey[600],
                  size: 25,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: typeColor,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    typeIcon,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          
          // Call Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  phone,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 12,
                        color: typeColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' • $time',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                    if (duration != '0:00') ...[
                      Text(
                        ' • $duration',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Info Button
              GestureDetector(
                onTap: () => _showCallDetails(context, name, phone, type, time, duration),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              // Call Button
              GestureDetector(
                onTap: () => _makePhoneCall(context, phone, name),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method to make actual phone calls
  Future<void> _makePhoneCall(BuildContext context, String phoneNumber, String name) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        _showErrorDialog(context, 'Unable to make phone call');
      }
    } catch (e) {
      _showErrorDialog(context, 'Error making phone call: $e');
    }
  }

  // Show call details dialog
  void _showCallDetails(BuildContext context, String name, String phone, 
                       String type, String time, String duration) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Phone', phone),
              _buildDetailRow('Type', type),
              _buildDetailRow('Time', time),
              if (duration != '0:00') _buildDetailRow('Duration', duration),
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
                _makePhoneCall(context, phone, name);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Call', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  // Show dialpad for manual dialing
  void _showDialpad(BuildContext context) {
    String dialedNumber = '';
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Dialed Number Display
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      dialedNumber.isEmpty ? 'Dial a number' : dialedNumber,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: dialedNumber.isEmpty ? Colors.grey : Colors.black87,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Dialpad
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: GridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        children: [
                          ...List.generate(9, (index) => 
                            _buildDialpadButton(context, '${index + 1}', setState, (number) {
                              dialedNumber += number;
                            })
                          ),
                          _buildDialpadButton(context, '*', setState, (number) {
                            dialedNumber += number;
                          }),
                          _buildDialpadButton(context, '0', setState, (number) {
                            dialedNumber += number;
                          }),
                          _buildDialpadButton(context, '#', setState, (number) {
                            dialedNumber += number;
                          }),
                        ],
                      ),
                    ),
                  ),
                  
                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Backspace
                        GestureDetector(
                          onTap: () {
                            if (dialedNumber.isNotEmpty) {
                              setState(() {
                                dialedNumber = dialedNumber.substring(0, dialedNumber.length - 1);
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Icon(Icons.backspace, size: 25),
                          ),
                        ),
                        
                        // Call Button
                        GestureDetector(
                          onTap: dialedNumber.isNotEmpty ? () {
                            Navigator.pop(context);
                            _makePhoneCall(context, dialedNumber, 'Unknown');
                          } : null,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: dialedNumber.isNotEmpty ? Colors.green : Colors.grey[300],
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: const Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        
                        // Close
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Icon(Icons.close, size: 25),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDialpadButton(BuildContext context, String number, 
                           StateSetter setState, Function(String) onPressed) {
    return GestureDetector(
      onTap: () {
        setState(() {
          onPressed(number);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  void _showCallOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.clear_all),
                title: const Text('Clear Call History'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Call Settings'),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}