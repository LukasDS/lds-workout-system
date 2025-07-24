import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout/features/workout/domain/exercise_info.dart';
import 'package:workout/features/workout/data/workout_repository.dart';
import 'package:workout/core/utils/debouncer.dart';

/// A widget representing an exercise with a name and a weight input field.
class ExerciseWidget extends StatefulWidget {
  final ExerciseInfo exerciseInfo;

  const ExerciseWidget({super.key, required this.exerciseInfo});

  @override
  State<ExerciseWidget> createState() => _ExerciseWidgetState();
}

/// The state for the Exercise widget, managing the weight input and interactions with the workout repository.
class _ExerciseWidgetState extends State<ExerciseWidget> {
  WorkoutRepository get workoutRepository => Provider.of<WorkoutRepository>(context, listen: false);
  double? _weight;
  late TextEditingController _weightController;
  final Debouncer _debouncer = Debouncer(milliseconds: 1000);

  /// Initializes the TextEditingController and loads the current weight for the exercise.
  @override
  void initState() {
    super.initState();

    _weightController = TextEditingController();
    _loadData();
  }

  /// Disposes the TextEditingController and cancels the debouncer.
  @override
  void dispose() {
    _weightController.dispose();
    _debouncer.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final weight = await workoutRepository.getCurrentWeight(widget.exerciseInfo.name);
      setState(() {
        _weight = weight;
        _weightController.text = formatWeight(_weight);
      });
    } catch (e, stack) {
      debugPrint('Failed to load data: $e\n$stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load weight.'))
        );
      }
    }
  }

  Future<void> _saveWeight(double? weight) async {
    try {
      await workoutRepository.setCurrentWeight(widget.exerciseInfo.name, weight);
    } catch (e, stack) {
      debugPrint('Failed to save weight: $e\n$stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save weight.'))
        );
      }
    }
  }

  /// Formats the weight for display, removing decimal places if not needed.
  String formatWeight(double? weight) {
    if (weight == null) return '';
    return weight % 1 == 0 ? weight.toInt().toString() : weight.toString();
  }

  /// Returns the warmup information based on the current weight.
  String warmupInfo() {
    if (_weight == null) return '';
    return widget.exerciseInfo.warmupInfo(_weight!);
  }

  /// Builds the widget tree for the Exercise widget.
  /// Displays the exercise name, a text field for weight input, and warmup information.
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            width: 250,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(children: [
              Text(widget.exerciseInfo.name, style: const TextStyle(fontSize: 20)),
              TextField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  textAlign: TextAlign.center,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  controller: _weightController,
                  onChanged: (weight) {
                    setState(() {
                      _weight = double.tryParse(weight);
                    });

                    _debouncer.run(() => _saveWeight(_weight));
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r"^[0-9]*\.?[0-9]*$")),
                  ]),
              const SizedBox(height: 2),
              Text(warmupInfo()),
            ])));
  }
}