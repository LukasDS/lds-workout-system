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
          ExerciseInfo(name: 'Single-Leg Leg Press', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Single-Leg Leg Extensions', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Adductor Machine', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Russian Twists', warmupInfo: getDefaultWarmupInfo)
        ],
      ),
      const WorkoutSplitWidget(
        title: 'Chest & back',
        exercises: [
          ExerciseInfo(name: 'Flat Dumbbell Press', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Incline Dumbbell Flyes', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Pull-Ups', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Dumbbell Pullovers', warmupInfo: getDefaultWarmupInfo)
        ],
      ),
      const WorkoutSplitWidget(
          title: 'Legs',
          exercises: [
            ExerciseInfo(name: 'Barbell Deadlift', warmupInfo: getBarbellWarmupInfo),
            ExerciseInfo(name: 'Leg Curls', warmupInfo: getDefaultWarmupInfo),
            ExerciseInfo(name: 'Abductor Machine', warmupInfo: getDefaultWarmupInfo),
            ExerciseInfo(name: 'Single-Leg Leg Press Calf Raises', warmupInfo: getDefaultWarmupInfo)
          ]
      ),
      const WorkoutSplitWidget(
        title: 'Shoulders & arms',
        exercises: [
          ExerciseInfo(name: 'Seated Dumbbell Shoulder Press', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Lateral Dumbbell Raises', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Aperture L', warmupInfo: getApertureLWarmupInfo),
          ExerciseInfo(name: 'Bicep Curls', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Parallel Bar Dips', warmupInfo: getDefaultWarmupInfo)
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
