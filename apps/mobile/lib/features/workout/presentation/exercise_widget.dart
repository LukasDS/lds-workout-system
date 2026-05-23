import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout/features/workout/domain/exercise_info.dart';
import 'package:workout/features/workout/data/workout_repository.dart';
import 'package:workout/core/utils/debouncer.dart';

final _weightInputRegex = RegExp(r"^[0-9]*\.?[0-9]*$");

/// A widget representing an exercise with a name and a weight input field.
class ExerciseWidget extends StatefulWidget {
  final ExerciseInfo exerciseInfo;

  const ExerciseWidget({super.key, required this.exerciseInfo});

  @override
  State<ExerciseWidget> createState() => _ExerciseWidgetState();
}

/// The state for the Exercise widget, managing the weight input and interactions with the workout repository.
class _ExerciseWidgetState extends State<ExerciseWidget> {
  WorkoutRepository get workoutRepository =>
      Provider.of<WorkoutRepository>(context, listen: false);
  double? _weight;
  late TextEditingController _weightController;
  final Debouncer _debouncer = Debouncer(milliseconds: 1000);
  StreamSubscription<double?>? _weightSubscription;
  final FocusNode _focusNode = FocusNode();

  /// Initializes the TextEditingController and subscribes to weight updates.
  @override
  void initState() {
    super.initState();

    _weightController = TextEditingController();
    _subscribeToData();
  }

  /// Disposes the TextEditingController, cancels the debouncer and the stream subscription.
  @override
  void dispose() {
    _weightController.dispose();
    _debouncer.cancel();
    _weightSubscription?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _subscribeToData() {
    _weightSubscription = workoutRepository
        .watchCurrentWeight(widget.exerciseInfo.name)
        .listen((weight) {
      if (!mounted) return;
      setState(() {
        _weight = weight;
        // Only update text field if not focused to avoid cursor jumping
        if (!_focusNode.hasFocus) {
          _weightController.text = formatWeight(_weight);
        }
      });
    }, onError: (e, stack) {
      debugPrint('Failed to load data: $e\n$stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load weight.')));
      }
    });
  }

  Future<void> _saveWeight(double? weight) async {
    try {
      await workoutRepository.setCurrentWeight(
          widget.exerciseInfo.name, weight);
    } catch (e, stack) {
      debugPrint('Failed to save weight: $e\n$stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save weight.')));
      }
    }
  }

  /// Formats the weight for display, removing decimal places if not needed.
  String formatWeight(double? weight) {
    if (weight == null) return '';
    return weight % 1 == 0 ? weight.toInt().toString() : weight.toString();
  }

  /// Builds the widget tree for the Exercise widget.
  /// Displays the exercise name, a text field for weight input, and warmup information.
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      Text(widget.exerciseInfo.name, style: const TextStyle(fontSize: 20)),
      SizedBox(
          width: 250,
          child: Column(children: [
            if (widget.exerciseInfo.requiresWeight)
              TextField(
                  focusNode: _focusNode,
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
                    FilteringTextInputFormatter.allow(_weightInputRegex),
                  ]),
            const SizedBox(height: 2),
            if (widget.exerciseInfo.warmupInfo != null)
              Text(
                widget.exerciseInfo.warmupInfo!(_weight),
                textAlign: TextAlign.center,
                ),
            const SizedBox(height: 16)
          ]))
    ]));
  }
}
