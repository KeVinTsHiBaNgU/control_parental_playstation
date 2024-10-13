import 'package:http/http.dart' as http;

class PlayStationService {
  static Future<bool> turnOn() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/turn_on'));
    return response.statusCode == 200;
  }

  static Future<bool> turnOff() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/turn_off'));
    return response.statusCode == 200;
  }
}
