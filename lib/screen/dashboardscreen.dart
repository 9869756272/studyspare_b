import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Image.asset('assets/images/logo.png', height: 130),
          const SizedBox(height: 2),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
                children: [
                  buildCourseCard("Python", 'assets/images/python.png'),
                  buildCourseCard("Java", 'assets/images/java.png'),
                  buildCourseCard("JavaScript", "assets/images/javascript.png"),
                  buildCourseCard("Flutter", "assets/images/fluuter.png"),
                  buildCourseCard("Node js", "assets/images/node js.png"),
                  buildCourseCard("Dart", "assets/images/dart.png"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
              child: Image.asset(imagePath, fit: BoxFit.contain),
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







