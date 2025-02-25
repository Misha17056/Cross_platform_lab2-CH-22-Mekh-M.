import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String apiKey = "bf65a02aab49eb93db9d458d8ae0fc4c";
  TextEditingController cityController = TextEditingController();
  String city = "Київ";
  double temperature = 0;
  String weatherDescription = "";
  String weatherIcon = "";

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        temperature = data['main']['temp'];
        weatherDescription = data['weather'][0]['description'];
        weatherIcon = data['weather'][0]['icon'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: "Enter city",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  city = cityController.text;
                });
                fetchWeather();
              },
              child: Text("Get Weather"),
            ),
            SizedBox(height: 20),
            Text(
              "$city",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "$temperature°C",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              "$weatherDescription",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            weatherIcon.isNotEmpty
                ? Image.network(
                    "https://openweathermap.org/img/wn/$weatherIcon@2x.png",
                    scale: 1.5,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
