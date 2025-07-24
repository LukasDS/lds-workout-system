import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/features/workout/domain/exercise_info.dart';
import 'package:workout/core/storage/local_storage.dart';
import 'package:workout/core/utils/warmup_utils.dart';
import 'package:workout/features/workout/presentation/workout_split_widget.dart';

/// The main widget for the workout home screen, which contains a PageView for different workout splits.
class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  LocalStorage get localStorage => Provider.of<LocalStorage>(context, listen: false);
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
    final currentIndex = await localStorage.getInt('currentIndex');
    if (currentIndex == null) return;
    setState(() {
      _currentIndex = currentIndex;
      _pageController.jumpToPage(_currentIndex);
    });
  }

  void _onPageChanged(int index) async {
    setState(() {
      _currentIndex = index;
    });
    localStorage.setInt('currentIndex', index);
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
      const WorkoutSplitWidget(
        title: 'Quads & abs',
        exercises: [
          ExerciseInfo(name: 'Squats', warmupInfo: getBarbellWarmupInfo),
          ExerciseInfo(name: 'Leg extensions', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Adductor', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Russian twists', warmupInfo: getDefaultWarmupInfo)
        ],
      ),
      const WorkoutSplitWidget(
        title: 'Chest & back',
        exercises: [
          ExerciseInfo(name: 'Dumbbell press', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Incline dumbbell flies', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Lat pulldowns', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Dumbbell pullovers', warmupInfo: getDefaultWarmupInfo)
        ],
      ),
      const WorkoutSplitWidget(
          title: 'Legs',
          exercises: [
            ExerciseInfo(name: 'Deadlift', warmupInfo: getBarbellWarmupInfo),
            ExerciseInfo(name: 'Leg curls', warmupInfo: getDefaultWarmupInfo),
            ExerciseInfo(name: 'Abductor', warmupInfo: getDefaultWarmupInfo),
            ExerciseInfo(name: 'Calf raises', warmupInfo: getDefaultWarmupInfo)
          ]
      ),
      const WorkoutSplitWidget(
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