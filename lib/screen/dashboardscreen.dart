// import 'package:flutter/material.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         children: [
//           const SizedBox(height: 30),
//           Image.asset('assets/images/logo.png', height: 130),
//           const SizedBox(height: 2),
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(10),
//             color: Colors.blue,
//             child: const Center(
//               child: Text(
//                 "Dashboard",
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.all(12.0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Explore all Courses",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 childAspectRatio: 1,
//                 children: [
//                   buildCourseCard("Python", 'assets/images/python.png'),
//                   buildCourseCard("Java", 'assets/images/java.png'),
//                   buildCourseCard("JavaScript", "assets/images/javascript.png"),
//                   buildCourseCard("Flutter", "assets/images/fluuter.png"),
//                   buildCourseCard("Node js", "assets/images/node js.png"),
//                   buildCourseCard("Dart", "assets/images/dart.png"),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildCourseCard(String title, String imagePath) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               child: Image.asset(imagePath, fit: BoxFit.contain),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/logo.png',
                height: 100,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Center(
                child: Text(
                  "Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Explore Courses",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  children: [
                    buildCourseCard("Python", 'assets/images/python.png'),
                    buildCourseCard("Java", 'assets/images/java.png'),
                    buildCourseCard("JavaScript", "assets/images/javascript.png"),
                    buildCourseCard("Flutter", "assets/images/fluuter.png"),
                    buildCourseCard("Node.js", "assets/images/node js.png"),
                    buildCourseCard("Dart", "assets/images/dart.png"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCourseCard(String title, String imagePath) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: () {
          // Handle course tap if needed
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





