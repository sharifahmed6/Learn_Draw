import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../injection_container.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';
import 'learn_page.dart';
import 'practice_page.dart';
import 'dashboard_page.dart';
import '../../../../features/progress/presentation/pages/progress_page.dart';
import '../../../../features/subscription/presentation/pages/subscription_page.dart';
import '../../../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../../../features/profile/presentation/bloc/profile_event.dart';
import '../../../../features/profile/presentation/bloc/profile_state.dart';
import '../../../../features/profile/presentation/pages/profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HomeBloc>()),
        BlocProvider(create: (_) => sl<ProfileBloc>()..add(LoadProfile())),
      ],
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          backgroundColor: const Color(0xFFFFF9C4), // Soft background color
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: state.tabIndex == 4 ? const SizedBox.shrink() : BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      context.read<HomeBloc>().add(const HomeTabChanged(4)); // Navigate to Profile tab
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurple.shade100,
                      backgroundImage: profileState.imageUrl.isNotEmpty ? NetworkImage(profileState.imageUrl) : null,
                      child: profileState.imageUrl.isEmpty
                          ? const Icon(Icons.person, color: Colors.deepPurple, size: 20)
                          : null,
                    ),
                  ),
                );
              },
            ),
            title: const Text(
              'Learn & Draw',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w900,
                fontSize: 28,
                letterSpacing: 1.2,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Text('👑', style: TextStyle(fontSize: 24)),
                tooltip: 'Get Premium',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SubscriptionPage(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFF9C4), // Soft Yellow
                  Color(0xFFFFCDD2), // Soft Pink
                  Color(0xFFE1BEE7), // Soft Purple
                  Color(0xFFB3E5FC), // Soft Blue
                ],
              ),
            ),
            child: IndexedStack(
              index: state.tabIndex,
              children: [
                const DashboardPage(),
                const LearnPage(),
                const PracticePage(),
                const ProgressPage(),
                 ProfilePage(),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.1), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withValues(alpha: 0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                  currentIndex: state.tabIndex,
                  onTap: (index) {
                    context.read<HomeBloc>().add(HomeTabChanged(index));
                  },
                  backgroundColor: Colors.white,
                  elevation: 0,
                  selectedItemColor: Colors.deepPurple,
                  unselectedItemColor: Colors.grey,
                  selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  type: BottomNavigationBarType.fixed,
                  showUnselectedLabels: true,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home_rounded),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.school_outlined),
                      activeIcon: Icon(Icons.school),
                      label: 'Learn',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.edit_outlined),
                      activeIcon: Icon(Icons.edit),
                      label: 'Practice',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.bar_chart_outlined),
                      activeIcon: Icon(Icons.bar_chart_rounded),
                      label: 'Progress',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      activeIcon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
