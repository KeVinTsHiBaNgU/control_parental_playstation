// import 'package:flutter/material.dart';

// class SettingsScreen extends StatefulWidget {
//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   double _usageDuration = 1; // Durée initiale en heures

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Paramètres de contrôle parental'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Durée maximale d\'utilisation (en heures) : ${_usageDuration.toInt()}h',
//               style: TextStyle(fontSize: 18),
//             ),
//             Slider(
//               value: _usageDuration,
//               min: 1,
//               max: 4,
//               divisions: 3,
//               label: '${_usageDuration.toInt()} heures',
//               onChanged: (double value) {
//                 setState(() {
//                   _usageDuration = value;
//                 });
//               },
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context, _usageDuration);
//               },
//               child: Text('Sauvegarder'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
