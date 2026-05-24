import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout/features/workout/domain/exercise.dart';
import 'package:workout/features/workout/data/workout_repository.dart';
import 'package:workout/features/workout/presentation/exercise_view_model.dart';

final _weightInputRegex = RegExp(r"^[0-9]*\.?[0-9]*$");

/// A widget representing an exercise with a name and a weight input field.
class ExerciseWidget extends StatefulWidget {
  final Exercise exerciseInfo;

  const ExerciseWidget({super.key, required this.exerciseInfo});

  @override
  State<ExerciseWidget> createState() => _ExerciseWidgetState();
}

/// The state for the Exercise widget, managing the UI components like TextField and FocusNode.
/// Business logic is delegated to the ExerciseViewModel.
class _ExerciseWidgetState extends State<ExerciseWidget> {
  late TextEditingController _weightController;
  final FocusNode _focusNode = FocusNode();
  ExerciseViewModel? _viewModel;
  WorkoutRepository? _repository;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newRepository = Provider.of<WorkoutRepository?>(context);
    if (newRepository != _repository) {
      _repository = newRepository;
      _viewModel?.dispose();
      _viewModel = _repository != null
          ? ExerciseViewModel(
              repository: _repository!,
              exerciseName: widget.exerciseInfo.name,
            )
          : null;
      
      // Listen to the new view model to update the text controller
      _viewModel?.addListener(_onViewModelChanged);
    }
  }

  void _onViewModelChanged() {
    if (!mounted) return;

    if (_viewModel?.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_viewModel!.errorMessage!)),
      );
    }

    // Only update text field if not focused to avoid cursor jumping
    if (!_focusNode.hasFocus) {
      _weightController.text = _formatWeight(_viewModel?.weight);
    }
    setState(() {}); // Trigger rebuild to update UI with latest weight/loading state
  }

  @override
  void dispose() {
    _viewModel?.removeListener(_onViewModelChanged);
    _viewModel?.dispose();
    _weightController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Formats the weight for display, removing decimal places if not needed.
  String _formatWeight(double? weight) {
    if (weight == null) return '';
    return weight % 1 == 0 ? weight.toInt().toString() : weight.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _viewModel?.isLoading ?? true;
    final weight = _viewModel?.weight;

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
                    onChanged: (value) {
                      final newWeight = double.tryParse(value);
                      _viewModel?.updateWeight(newWeight);
                      setState(() {}); // Rebuild to update warmup info text immediately
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(_weightInputRegex),
                    ]),
              ),
            const SizedBox(height: 2),
            if (widget.exerciseInfo.warmupInfo != null)
              Text(
                isLoading ? 'Loading warmup...' : widget.exerciseInfo.warmupInfo!(weight),
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

