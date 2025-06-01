import 'package:flutter/material.dart';

void main() => runApp(const DashboardPage());

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudySphere',
      debugShowCheckedModeBanner: false,
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Logo and App Name
            Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 130,
                ),
               
              ],
            ),

            const SizedBox(height: 2),

            // Dashboard Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Colors.blue,
              child: const Center(
                child: Text(
                  "Dashboard",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Explore all Courses",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Course Grid (inline cards)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                  children: [
                    buildCourseCard("Python", 
                    'assets/images/python.png'),
                    buildCourseCard("Java", 
                    'assets/images/java.png'),
                    buildCourseCard("JavaScript", 
                    "assets/images/javascript.png"),
                    buildCourseCard("Flutter", 
                    "assets/images/fluuter.png"),
                    buildCourseCard("Node js", 
                    "assets/images/node js.png"),
                    buildCourseCard("Dart",
                     "assets/images/dart.png"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Inline method to build course card
  Widget buildCourseCard(String title, String imagePath) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
