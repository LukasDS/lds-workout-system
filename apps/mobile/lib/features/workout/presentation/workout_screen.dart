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
        title: 'Quads and Abs',
        exercises: [
          ExerciseInfo(name: 'Single-Leg Leg Press', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Single-Leg Leg Extensions', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Adductor Machine', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Russian Twists', warmupInfo: getDefaultWarmupInfo)
        ],
      ),
      const WorkoutSplitWidget(
        title: 'Chest and Back',
        exercises: [
          ExerciseInfo(name: 'Flat Dumbbell Press', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Incline Dumbbell Flyes', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Pull-Ups', warmupInfo: getPullUpsDynamicStretchingInfo),
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
        title: 'Shoulders and Arms',
        exercises: [
          ExerciseInfo(name: 'Seated Dumbbell Shoulder Press', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Lateral Dumbbell Raises', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Aperture L', warmupInfo: getApertureLWarmupInfo),
          ExerciseInfo(name: 'Bicep Curls', warmupInfo: getDefaultWarmupInfo),
          ExerciseInfo(name: 'Parallel Bar Dips', warmupInfo: getDipsDynamicStretchingInfo)
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
            icon: Icon(Icons.directions_run_outlined),
            selectedIcon: Icon(Icons.directions_run),
            label: 'Quads',
          ),
          NavigationDestination(
            icon: Icon(Icons.compare_arrows_outlined),
            selectedIcon: Icon(Icons.compare_arrows),
            label: 'Chest/Back',
          ),
          NavigationDestination(
            icon: Icon(Icons.hiking_outlined),
            selectedIcon: Icon(Icons.hiking),
            label: 'Legs',
          ),
          NavigationDestination(
            icon: Icon(Icons.accessibility_new_outlined),
            selectedIcon: Icon(Icons.accessibility_new),
            label: 'Shoulders',
          ),
        ],
      ),
    );
  }
}
