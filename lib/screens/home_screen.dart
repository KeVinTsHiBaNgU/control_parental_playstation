import 'package:flutter/material.dart';
import '../services/playstation_service.dart';
import 'dart:async';
import 'session_duration_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String playStationStatus = 'Éteinte';
  double maxUsageDuration = 1;
  Timer? _timer;
  int _timeElapsed = 0;
  int _sessionDuration = 30;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _timeElapsed = 0;
  }

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
        _showNotification();
      }
    });
  }

  void _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'session_duration_channel',
      'Durée de session',
      channelDescription: 'Notifications pour la durée de session',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Session terminée',
      'La durée de session est atteinte. La PlayStation va s\'éteindre.',
      platformChannelSpecifics,
      payload: 'session_terminée',
    );
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
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('État de la PlayStation'),
        backgroundColor: Colors.blueAccent,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('PlayStation $playStationStatus', style: TextStyle(fontSize: 24)),
                      SizedBox(height: 20),
                      Text('Temps écoulé : $_timeElapsed minutes'),
                      SizedBox(height: 20),
                      Text('Durée de session : $_sessionDuration minutes',
                          style: TextStyle(fontSize: 18, color: Colors.red)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _turnOnPlayStation,
                child: Text('Allumer'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _turnOffPlayStation,
                child: Text('Éteindre'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final selectedDuration = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SessionDurationScreen(
                        onDurationSelected: (int duration) {
                          setState(() {
                            _sessionDuration = duration;
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Text('Définir durée de session'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
