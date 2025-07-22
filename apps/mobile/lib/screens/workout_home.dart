import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout/models/exercise_info.dart';
import 'package:workout/utils/warmup_utils.dart';
import 'package:workout/widgets/workout_split.dart';

/// The main widget for the workout home screen, which contains a PageView for different workout splits.
class WorkoutHome extends StatefulWidget {
  const WorkoutHome({super.key});

  @override
  State<WorkoutHome> createState() => _WorkoutHomeState();
}

class _WorkoutHomeState extends State<WorkoutHome> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadSavedIndex();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentIndex = prefs.getInt('currentIndex') ?? 0;
      _pageController.jumpToPage(_currentIndex);
    });
  }

  void _onPageChanged(int index) async {
    setState(() {
      _currentIndex = index;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('currentIndex', index);
  }

  void _onDestinationSelected(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  List<Widget> _buildPages() {
    return [
      const WorkoutSplit(
        title: 'Quads & abs',
        exercises: [
          ExerciseInfo(name: 'Squats', warmupInfo: getBarbellWarmupInfo),
          ExerciseInfo(name: 'Leg extensions', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Adductor', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Russian twists', warmupInfo: getDefaultWarmupInfo)
        ],
      ),
      const WorkoutSplit(
        title: 'Chest & back',
        exercises: [
          ExerciseInfo(name: 'Dumbbell press', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Incline dumbbell flies', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Lat pulldowns', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Dumbbell pullovers', warmupInfo: getDefaultWarmupInfo)
        ],
      ),
      const WorkoutSplit(
          title: 'Legs',
          exercises: [
            ExerciseInfo(name: 'Deadlift', warmupInfo: getBarbellWarmupInfo),
            ExerciseInfo(name: 'Leg curls', warmupInfo: getDefaultWarmupInfo),
            ExerciseInfo(name: 'Abductor', warmupInfo: getDefaultWarmupInfo),
            ExerciseInfo(name: 'Calf raises', warmupInfo: getDefaultWarmupInfo)
          ]
      ),
      const WorkoutSplit(
        title: 'Shoulders & arms',
        exercises: [
          ExerciseInfo(name: 'Shoulder press', warmupInfo: getBarbellWarmupInfo),
          ExerciseInfo(name: 'Lateral raises', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Aperture L', warmupInfo: getApertureLWarmupInfo),
          ExerciseInfo(name: 'Bicep curls', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Skull crushers', warmupInfo: getEzBarWarmupInfo)
        ]
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _buildPages()
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Quads & abs',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Chest & back',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Legs',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Shoul... & arms',
          ),
        ],
      ),
    );
  }
}