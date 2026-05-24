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
  WorkoutRepository? _currentRepository;
  double? _weight;
  late TextEditingController _weightController;
  final Debouncer _debouncer = Debouncer(milliseconds: 1000);
  StreamSubscription<double?>? _weightSubscription;
  final FocusNode _focusNode = FocusNode();
  bool _isInitialLoading = true;

  /// Initializes the TextEditingController and subscribes to weight updates.
  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newRepository = Provider.of<WorkoutRepository?>(context);
    if (newRepository != _currentRepository) {
      _currentRepository = newRepository;
      _subscribeToData();
    }
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
    _weightSubscription?.cancel();
    _weightSubscription = null;

    if (_currentRepository == null) {
      setState(() {
        _isInitialLoading = true;
      });
      return;
    }

    _weightSubscription = _currentRepository!
        .watchCurrentWeight(widget.exerciseInfo.name)
        .listen((weight) {
      if (!mounted) return;
      setState(() {
        _weight = weight;
        _isInitialLoading = false;
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
    if (_currentRepository == null) return;
    try {
      await _currentRepository!.setCurrentWeight(
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
    final bool isLoading = _currentRepository == null || _isInitialLoading;

    return Center(
        child: Column(children: [
      Text(
        widget.exerciseInfo.name,
        style: TextStyle(
          fontSize: 20,
          color: isLoading ? Colors.white24 : Colors.white,
        ),
      ),
      SizedBox(
          width: 250,
          child: Column(children: [
            if (widget.exerciseInfo.requiresWeight)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                    enabled: !isLoading,
                    focusNode: _focusNode,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: isLoading ? '...' : null,
                    ),
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
              ),
            const SizedBox(height: 2),
            if (widget.exerciseInfo.warmupInfo != null)
              Text(
                isLoading ? 'Loading warmup...' : widget.exerciseInfo.warmupInfo!(_weight),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isLoading ? Colors.white24 : Colors.white70,
                ),
              ),
            const SizedBox(height: 16)
          ]))
    ]));
  }
}
