import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/features/workout/domain/exercise_info.dart';
import 'package:workout/core/storage/local_storage.dart';
import 'package:workout/core/utils/warmup_utils.dart';
import 'package:workout/features/workout/presentation/workout_split_widget.dart';
import 'package:workout/features/workout/presentation/rest_stopwatch_widget.dart';

/// The main widget for the workout home screen, which contains a PageView for different workout splits.
class WorkoutScreen extends StatefulWidget {
  final int initialIndex;
  const WorkoutScreen({super.key, this.initialIndex = 0});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  LocalStorage get localStorage => Provider.of<LocalStorage>(context, listen: false);
  late int _currentIndex = widget.initialIndex;
  final int _initialPageOffset = 4000;
  late final PageController _pageController = PageController(initialPage: _initialPageOffset + _currentIndex);

  static const List<WorkoutSplitData> _splits = [
    WorkoutSplitData(
      title: 'Quads and Abs',
      exercises: [
        ExerciseInfo(name: 'Single-Leg Leg Press', warmupInfo: getDefaultWarmupInfo),
        ExerciseInfo(name: 'Single-Leg Leg Extensions', warmupInfo: getDefaultWarmupInfo),
        ExerciseInfo(name: 'Adductor Machine', warmupInfo: getDefaultWarmupInfo),
        ExerciseInfo(name: 'Hollow Body Hold', requiresWeight: false)
      ],
    ),
    WorkoutSplitData(
      title: 'Chest and Back',
      exercises: [
        ExerciseInfo(name: 'Flat Dumbbell Press', warmupInfo: getDefaultWarmupInfo),
        ExerciseInfo(name: 'Incline Dumbbell Flyes', warmupInfo: getDefaultWarmupInfo),
        ExerciseInfo(name: 'Pull-Ups', warmupInfo: getPullUpsDynamicStretchingInfo, requiresWeight: false),
        ExerciseInfo(name: 'Dumbbell Pullovers', warmupInfo: getDefaultWarmupInfo)
      ],
    ),
    WorkoutSplitData(
      title: 'Legs',
      exercises: [
        ExerciseInfo(name: 'Barbell Deadlift', warmupInfo: getBarbellWarmupInfo),
        ExerciseInfo(name: 'Leg Curls', warmupInfo: getDefaultWarmupInfo),
        ExerciseInfo(name: 'Abductor Machine', warmupInfo: getDefaultWarmupInfo),
        ExerciseInfo(name: 'Single-Leg Leg Press Calf Raises', warmupInfo: getDefaultWarmupInfo)
      ],
    ),
    WorkoutSplitData(
      title: 'Shoulders and Arms',
      exercises: [
        ExerciseInfo(name: 'Seated Dumbbell Shoulder Press', warmupInfo: getDefaultWarmupInfo),
        ExerciseInfo(name: 'Lateral Dumbbell Raises', warmupInfo: getDefaultWarmupInfo),
        ExerciseInfo(name: 'Aperture L', warmupInfo: getApertureLWarmupInfo),
        ExerciseInfo(name: 'Bicep Curls', warmupInfo: getDefaultWarmupInfo),
        ExerciseInfo(name: 'Parallel Bar Dips', warmupInfo: getDipsDynamicStretchingInfo, requiresWeight: false)
      ],
    )
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) async {
    final realIndex = index % _splits.length;
    setState(() {
      _currentIndex = realIndex;
    });
    localStorage.setInt('currentIndex', realIndex);
  }

  void _onDestinationSelected(int index) {
    int currentPage = _pageController.page?.round() ?? _initialPageOffset;
    int currentRealIndex = currentPage % _splits.length;
    int offset = index - currentRealIndex;
    
    _pageController.animateToPage(
      currentPage + offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_splits[_currentIndex].title),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final split = _splits[index % _splits.length];
          return WorkoutSplitWidget(
            title: split.title,
            exercises: split.exercises,
          );
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const RestStopwatchWidget(),
          NavigationBar(
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
        ],
      ),
    );
  }
}

class WorkoutSplitData {
  final String title;
  final List<ExerciseInfo> exercises;
  const WorkoutSplitData({required this.title, required this.exercises});
}
