import 'package:flutter/material.dart';
import '../services/playstation_service.dart';
import 'dart:async';
import 'session_duration_screen.dart'; // Importer le nouvel écran

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String playStationStatus = 'Éteinte';
  double maxUsageDuration = 1; // Durée maximale d'utilisation par défaut
  Timer? _timer;
  int _timeElapsed = 0; // Temps écoulé en minutes
  int _sessionDuration = 30; // Durée de session par défaut

  Future<void> _turnOnPlayStation() async {
    bool success = await PlayStationService.turnOn();
    if (success) {
      setState(() {
        playStationStatus = 'Allumée';
        _startTimer();
      });
    }
  }

  Future<void> _turnOffPlayStation() async {
    bool success = await PlayStationService.turnOff();
    if (success) {
      setState(() {
        playStationStatus = 'Éteinte';
        _timer?.cancel();
        _timeElapsed = 0;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _timeElapsed++;
      });

      if (_timeElapsed >= _sessionDuration) {
        _turnOffPlayStation();
        _showAlertDialog();
      }
    });
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Durée de session dépassée'),
          content: Text('La PlayStation sera éteinte automatiquement.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Arrêter le timer si on quitte la page
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('État de la PlayStation'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              final selectedDuration = await Navigator.pushNamed(context, '/settings');
              if (selectedDuration != null) {
                setState(() {
                  maxUsageDuration = selectedDuration as double;
                });
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('PlayStation $playStationStatus', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('Temps écoulé : $_timeElapsed minutes'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _turnOnPlayStation,
              child: Text('Allumer'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _turnOffPlayStation,
              child: Text('Éteindre'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Ouvrir l'écran pour définir la durée de session
                final selectedDuration = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SessionDurationScreen(
                      onDurationSelected: (int duration) {
                        setState(() {
                          _sessionDuration = duration; // Mettre à jour la durée de session
                        });
                      },
                    ),
                  ),
                );
              },
              child: Text('Définir durée de session'),
            ),
          ],
        ),
      ),
    );
  }
}
