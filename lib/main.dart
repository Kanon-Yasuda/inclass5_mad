// BLOCK 1: Import Flutter's Material widgets and launch the app.
    import 'package:flutter/material.dart';

void main() => runApp(const CounterApp());

    // BLOCK 2: This app shell does not change, so it is a StatelessWidget.
class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterPage(),
    );
  }
}

// BLOCK 3: This screen changes after user interactions, so it is stateful.
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  // BLOCK 4: State fields determine what the user sees at any moment.
  int _counter = 40;
  int _increment = 7;
  final List<int> _history = [];
  final TextEditingController _incrementController = TextEditingController(text: '7');

  @override
  void dispose() {
    // Controllers use resources; dispose them when this screen is removed.
    _incrementController.dispose();
    super.dispose();
  }

  // BLOCK 5: Helper methods enforce rules before they change UI state.
  bool _isValidValue(int value) => value >= 10 && value <= 150;

  // Activity 05 color-feedback rule, driven by the same counter state.
  Color _counterColor() {
    if (_counter == 10) return Colors.red;
    if (_counter > 90) return Colors.green;
    return Colors.black;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _moveTo(int nextValue) {
    // Reject the action before changing state or creating a history record.
    if (!_isValidValue(nextValue)) {
      _showMessage('Counter must stay between 10 and 150.');
      return;
    }

    setState(() {
      _history.add(_counter); // Save only the state that can be restored.
      _counter = nextValue;
    });
  }

  void _readIncrement(String input) {
    final value = int.tryParse(input);
    // I added in more details at the end of the message, added something so it will not go over 150
    if (value == null || value <= 0 || value > 150) {
      _showMessage('Enter a positive whole number. Do not enter a negative, decimal, a number over 150 or non number into the input.');
      return; // Keep the last valid increment unchanged.
    }
    setState(() => _increment = value);
  }

  void _undo() {
    if (_history.isEmpty) {
      _showMessage('There is no earlier value to restore.');
      return;
    }
    setState(() => _counter = _history.removeLast());
  }

  void _reset() {
    if (_counter != 10) _moveTo(10);
  }

  @override
  Widget build(BuildContext context) {
    // BLOCK 6: Build reads state and connects widgets to user actions.
    return Scaffold(
      appBar: AppBar(title: const Text('Activity 05 Counter')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$_counter',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: _counterColor(),
                  ),
            ),
            Slider(
              value: _counter.toDouble(), min: 10, max: 150, divisions: 140,
              // TODO: Decide and explain why slider moves should enter history.
              // Answer: It helps since the slider is also an action. If we moce it by mistake, we can use the undo button to erase our mistake
              onChanged: (value) => _moveTo(value.round()),
            ),
            TextField(
              controller: _incrementController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Increment amount (starts at 7)'),
              onChanged: _readIncrement,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(onPressed: () => _moveTo(_counter - _increment), child: const Text('Decrease')),
                ElevatedButton(onPressed: () => _moveTo(_counter + _increment), child: const Text('Increase')),
                OutlinedButton(onPressed: _reset, child: const Text('Reset to 10')),
                OutlinedButton(onPressed: _undo, child: const Text('Undo')),
              ],
            ),
            const SizedBox(height: 20),
            Text(_history.isEmpty ? 'History: none' : 'History: ${_history.join(', ')}'),
          ],
        ),
      ),
    );
  }
}