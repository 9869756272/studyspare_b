import 'package:flutter/material.dart';



class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _courses = [
    {'title': 'Python', 'icon': 'assets/python.png'},
    {'title': 'Java', 'icon': 'assets/java.png'},
    {'title': 'JavaScript', 'icon': 'assets/js.png'},
    {'title': 'Flutter', 'icon': 'assets/flutter.png'},
    {'title': 'NodeJS', 'icon': 'assets/nodejs.png'},
    {'title': 'Dart', 'icon': 'assets/dart.png'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildCourseCard(String title, String iconPath) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 50),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Image.asset('assets/images/logo.png', height: 90), // Add your logo
            Text("Dashboard", style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 90,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Explore all Courses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: _courses
                    .map((course) => buildCourseCard(course['title'], course['icon']))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
     ),
);
 }
}