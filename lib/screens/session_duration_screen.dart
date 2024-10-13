import 'package:flutter/material.dart';

class SessionDurationScreen extends StatefulWidget {
  final Function(int) onDurationSelected;

  SessionDurationScreen({required this.onDurationSelected});

  @override
  _SessionDurationScreenState createState() => _SessionDurationScreenState();
}

class _SessionDurationScreenState extends State<SessionDurationScreen> {
  int _selectedDuration = 30; // Durée par défaut en minutes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Définir la durée de session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Durée de session (en minutes) : $_selectedDuration min',
              style: TextStyle(fontSize: 18),
            ),
            Slider(
              value: _selectedDuration.toDouble(),
              min: 10,
              max: 120,
              divisions: 11,
              label: '$_selectedDuration minutes',
              onChanged: (double value) {
                setState(() {
                  _selectedDuration = value.toInt();
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                widget.onDurationSelected(_selectedDuration);
                Navigator.pop(context);
              },
              child: Text('Sauvegarder'),
            ),
          ],
        ),
      ),
    );
  }
}
