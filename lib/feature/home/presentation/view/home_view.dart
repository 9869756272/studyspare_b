import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:studyspare_b/app/auth/auth_provider.dart';
import 'package:studyspare_b/app/service_locator/service_locator.dart';
import 'package:studyspare_b/feature/course/presentation/view/courses_list_view.dart';
import 'package:studyspare_b/feature/course/presentation/viewmodel/courses_list/courses_list_view_model.dart';
import 'package:studyspare_b/feature/home/presentation/view_model/home_state.dart';
import 'package:studyspare_b/feature/home/presentation/view_model/home_view_model.dart';
import 'package:studyspare_b/feature/notes/presentation/view/notes_list_view.dart';
import 'package:studyspare_b/feature/notes/presentation/view_model/note_view_model.dart';
import 'package:studyspare_b/feature/profile/presentation/view/profile_view.dart';
import 'package:studyspare_b/feature/profile/presentation/viewmodel/profile_cubit.dart';
import 'package:studyspare_b/feature/schedule/presentation/view/schedule_screen.dart';
import 'package:studyspare_b/feature/schedule/presentation/view_model/schedule_view_model.dart';
import 'package:studyspare_b/feature/task/presentation/view/task_screen.dart';
import 'package:studyspare_b/feature/task/presentation/view_model/task_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static final List<Widget> _views = [
    BlocProvider(
      create: (_) => serviceLocator<CoursesListViewModel>(),
      child: const CoursesListView(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<NoteViewModel>(),
      child: const NotesListView(),
    ),
    BlocProvider(
      create: (_) => serviceLocator<ScheduleViewModel>(),
      child: const ScheduleScreen(),
    ),
    BlocProvider.value(
      value: serviceLocator<TaskViewModel>(),
      child: const TaskScreen(),
    ),
    BlocProvider.value(
      value: serviceLocator<ProfileCubit>(),
      child: const ProfileView(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blue.shade800;
    final Color accentColor = Colors.cyan.shade300;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildCoolAppBar(context),
      body: BlocBuilder<HomeViewModel, HomeState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: SizedBox(
              key: ValueKey<int>(state.selectedIndex),
              child: _views.elementAt(state.selectedIndex),
            ),
          );
        },
      ),
      bottomNavigationBar: Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
            ],
          ),
          child: SafeArea(
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 8,
                ),
                child: BlocBuilder<HomeViewModel, HomeState>(
                  builder: (context, state) {
                    return GNav(
                      rippleColor: primaryColor.withOpacity(0.2),
                      hoverColor: primaryColor.withOpacity(0.1),
                      gap: 0,
                      activeColor: Colors.white,
                      iconSize: 24,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      duration: const Duration(milliseconds: 400),
                      tabBackgroundColor: primaryColor,
                      color: Colors.black54,
                      tabs: const [
                        GButton(icon: Icons.school_outlined, text: 'Courses'),
                        GButton(icon: Icons.notes_outlined, text: 'Notes'),
                        GButton(
                          icon: Icons.calendar_today_outlined,
                          text: 'Schedule',
                        ),
                        GButton(
                          icon: Icons.checklist_rtl_outlined,
                          text: 'Tasks',
                        ),
                        GButton(icon: Icons.person_outline, text: 'Profile'),
                      ],
                      selectedIndex: state.selectedIndex,
                      onTabChange: (index) {
                        context.read<HomeViewModel>().onTabTapped(index);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCoolAppBar(BuildContext context) {
    return AppBar(
      elevation: 0, // Flat design
      toolbarHeight: 80,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: BlocBuilder<AuthProvider, AuthState>(
        builder: (context, authState) {
          final userName = authState.user?.name ?? 'User';
          final userInitials = _getInitials(userName);

          return Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white.withOpacity(0.9),
                child: Text(
                  userInitials,
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome back,',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),

      // actions: [
      //   // Debug button for testing shake detection
      //   IconButton(
      //     icon: const Icon(Icons.vibration, color: Colors.white),
      //     onPressed: () {
      //       // Navigate to test screen
      //       Navigator.of(context).push(
      //         MaterialPageRoute(builder: (context) => const ShakeTestScreen()),
      //       );
      //     },
      //     tooltip: 'Shake Test Screen',
      //   ),
      //   // Debug button for testing double tap detection
      //   IconButton(
      //     icon: const Icon(Icons.touch_app, color: Colors.white),
      //     onPressed: () {
      //       Navigator.of(context).push(
      //         MaterialPageRoute(
      //           builder: (context) => const DoubleTapTestScreen(),
      //         ),
      //       );
      //     },
      //     tooltip: 'Double Tap Test Screen',
      //   ),
      //   BlocBuilder<AuthProvider, AuthState>(
      //     builder: (context, authState) {
      //       return IconButton(
      //         icon: const Icon(Icons.logout, color: Colors.white),
      //         onPressed: () => context.read<HomeViewModel>().logout(context),
      //         tooltip: 'Logout',
      //       );
      //     },
      //   ),
      // ],
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final nameParts = name.trim().replaceAll(RegExp(r'\s+'), ' ').split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase();
    } else {
      return nameParts.first[0].toUpperCase();
    }
  }
}
