import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workout/features/workout/data/workout_repository.dart';
import 'package:workout/core/storage/local_storage.dart';
import 'package:workout/core/storage/shared_prefs_storage.dart';
import 'features/workout/presentation/workout_screen.dart';

const _workoutRed = Color(0xFFB5001E);
const _workoutRedSoft = Color(0x66D05C70);

class WorkoutApp extends StatelessWidget {
  final SharedPreferences prefs;
  final int initialIndex;
  final WorkoutRepository workoutRepository;

  const WorkoutApp({
    super.key,
    required this.prefs,
    required this.initialIndex,
    required this.workoutRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<LocalStorage>(create: (_) => SharedPrefsStorage(prefs)),
          Provider<WorkoutRepository>.value(value: workoutRepository),
        ],
        child: MaterialApp(
          title: 'Workout',
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: const ColorScheme.dark(
                primary: _workoutRed,
                onPrimary: Colors.white,
                secondary: _workoutRed,
                onSecondary: Colors.white,
                surface: Colors.black,
                onSurface: Colors.white,
              ),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: _workoutRed,
                selectionColor: _workoutRedSoft,
                selectionHandleColor: _workoutRed,
              ),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: _workoutRed, width: 2),
                ),
              ),
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: Colors.black,
                indicatorColor: _workoutRed,
                iconTheme: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const IconThemeData(color: Colors.white);
                  }
                  return const IconThemeData(color: Colors.white70);
                }),
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const TextStyle(color: Colors.white);
                  }
                  return const TextStyle(color: Colors.white70);
                }),
              ),
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                  systemNavigationBarColor: Colors.black,
                  systemNavigationBarIconBrightness: Brightness.light,
                ),
              )),
          debugShowCheckedModeBanner: false,
          home: WorkoutScreen(initialIndex: initialIndex),
        ));
  }
}
