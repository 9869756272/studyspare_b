import 'package:flutter/material.dart';

class DashBoardPAge extends StatefulWidget {
  const DashBoardPAge({super.key});

  @override
  State<DashBoardPAge> createState() => _DashBoardPAgeState();
}

class _DashBoardPAgeState extends State<DashBoardPAge> {
  final List<String> courses = [
    'Python', 'Java', 'JS', 'JavaScript',
    'Flutter', 'Node', 'NodeJS', 'Dart'
  ];

  final List<Color> courseColors = [
    Colors.blueAccent,
    Colors.orangeAccent,
    Colors.yellowAccent,
    Colors.amber,
    Colors.lightBlue,
    Colors.greenAccent,
    Colors.tealAccent,
    Colors.purpleAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Sphere Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Explore all Courses',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: List.generate(courses.length, (index) {
                  return CourseCard(
                    courseName: courses[index],
                    color: courseColors[index % courseColors.length],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String courseName;
  final Color color;

  const CourseCard({
    super.key,
    required this.courseName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                courseName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.arrow_forward,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}