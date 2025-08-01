import 'package:flutter/material.dart';
import 'welcome_screen.dart'; 

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({super.key});

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> titles = ['Leads', 'Follow-ups', 'Task'];
  final List<String> imageAssets = [
    'assets/Leads.png',
    'assets/Follow-Ups.png',
    'assets/task.png',
  ];

  void _onNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // ✅ Navigate to Welcome screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  void _onSkip() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                CustomPaint(
                  painter: TopShapePainter(),
                  child: Container(),
                ),
                PageView.builder(
                  controller: _pageController,
                  itemCount: 3,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 100.0),
                        child: Image.asset(
                          imageAssets[index],
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                titles[_currentPage],
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _onSkip,
                  child: const Text(
                    'Skip',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                Row(
                  children: List.generate(3, (index) => buildDot(index)),
                ),
                TextButton(
                  onPressed: _onNext,
                  child: Text(
                    _currentPage == 2 ? 'Done' : 'Next',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: _currentPage == index ? 10 : 8,
      width: _currentPage == index ? 10 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.grey[700] : Colors.grey[400],
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class TopShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF5C5C5C)
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 1.1,
      0, size.height * 0.7,
    );
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
