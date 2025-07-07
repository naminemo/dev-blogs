import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // 用來解析 JSON

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Weather App',
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String temperature = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=25.04&longitude=121.56&current_weather=true');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // 從資料中抓取目前溫度
        final currentWeather = data['current_weather'];
        setState(() {
          temperature = '${currentWeather['temperature']} °C';
        });
      } else {
        setState(() {
          temperature = 'Failed to load weather data';
        });
      }
    } catch (e) {
      setState(() {
        temperature = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Center(
        child: Text(
          'Current Temperature:\n$temperature',
          style: const TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
