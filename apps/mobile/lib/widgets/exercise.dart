import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout/models/exercise_info.dart';
import 'package:workout/utils/debouncer.dart';

/// A widget representing an exercise with a name and a weight input field.
class Exercise extends StatefulWidget {
  final ExerciseInfo exerciseInfo;

  const Exercise({super.key, required this.exerciseInfo});

  @override
  State<Exercise> createState() => _ExerciseState();
}

/// The state for the Exercise widget, managing the weight input and Firestore interactions.
class _ExerciseState extends State<Exercise> {
  double? _weight;
  late TextEditingController _weightController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'lukas_exercises';
  final Debouncer _debouncer = Debouncer(milliseconds: 1000);

  /// Initializes the TextEditingController and loads the current weight from Firestore.
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
      DocumentSnapshot doc = await _firestore.collection(_collectionName).doc(widget.exerciseInfo.name).get();
    setState(() {
      _weight = doc.exists ? doc.get('currentWeight') as double? : null;
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
      if (weight != null) {
        final exerciseRef = _firestore.collection(_collectionName).doc(widget.exerciseInfo.name);
        final historyRef = exerciseRef.collection('history');

        await _firestore.runTransaction((transaction) async {
          // Update the current weight
          transaction.set(exerciseRef, {'currentWeight': weight}, SetOptions(merge: true));

          // Add the new weight to the history
          transaction.set(historyRef.doc(), {
            'weight': weight,
            'date': Timestamp.now()
          });
        });
      } else {
        // Set the current weight to null
        await _firestore.collection(_collectionName).doc(widget.exerciseInfo.name).set({'currentWeight': null}, SetOptions(merge: true));
      }
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