import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/consts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? currentWeather;
  Weather? tomorrowWeather;
  final TextEditingController _controller = TextEditingController();
  String location = 'Colombo';
  bool isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  void _fetchWeather() async {
    final weather = await wf.currentWeatherByCityName(location);
    final forecast = await wf.fiveDayForecastByCityName(location);
    setState(() {
      currentWeather = weather;
      if (forecast.isNotEmpty) {
        tomorrowWeather = forecast.firstWhere(
            (w) =>
                w.date!.day == DateTime.now().add(const Duration(days: 1)).day,
            orElse: () => forecast[0]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkTheme ? _darkTheme() : _lightTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Weather App'),
          actions: [
            IconButton(
              icon: Icon(isDarkTheme ? Icons.dark_mode : Icons.light_mode),
              onPressed: () {
                setState(() {
                  isDarkTheme = !isDarkTheme;
                });
              },
            ),
          ],
        ),
        body: Container(
          color: Color.fromARGB(255, 237, 192, 255),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _locationInput(),
                  const SizedBox(height: 20),
                  currentWeather == null
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            _weatherSection(currentWeather, "Today"),
                            const SizedBox(height: 20),
                            if (tomorrowWeather != null)
                              _weatherSection(tomorrowWeather, "Tomorrow"),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      primaryColor: Colors.blue,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.blue[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      primaryColor: Colors.deepPurple[900],
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
        bodyMedium: TextStyle(color: Colors.white70, fontFamily: 'Roboto'),
        titleLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      cardColor: Colors.grey[850],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.deepPurple[800],
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
          fontFamily: 'Roboto',
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.deepPurpleAccent),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurpleAccent,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurpleAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Colors.deepPurpleAccent, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.deepPurpleAccent),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.deepPurpleAccent,
      ),
      dividerColor: Colors.deepPurple[400],
    );
  }

  Widget _locationInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter location',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              location = _controller.text;
              _fetchWeather();
            });
          },
          child: const Text('Get Weather'),
        ),
      ],
    );
  }

  Widget _weatherSection(Weather? weather, String title) {
    return Card(
      color: title == "Today" ? Colors.blue[50] : Colors.green[50],
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: title == "Today" ? Colors.blue : Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            _dateTimeInfo(weather),
            const SizedBox(height: 20),
            _weatherIcon(weather),
            const SizedBox(height: 20),
            _currentTemp(weather),
            const SizedBox(height: 20),
            _extraInfo(weather),
          ],
        ),
      ),
    );
  }

  Widget _dateTimeInfo(Weather? weather) {
    DateTime now = weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("hh:mm a").format(now),
          style: const TextStyle(fontSize: 35),
        ),
        const SizedBox(height: 10),
        Text(
          DateFormat("EEEE, d MMMM y").format(now),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ],
    );
  }

  Widget _weatherIcon(Weather? weather) {
    return Column(
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${weather?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          weather?.weatherDescription ?? "",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _currentTemp(Weather? weather) {
    return Text(
      "${weather?.temperature?.celsius?.round()}°C",
      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    );
  }

  Widget _extraInfo(Weather? weather) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Icon(Icons.water_damage),
                Text("${weather?.humidity}%"),
              ],
            ),
            Column(
              children: [
                const Icon(Icons.wb_sunny),
                Text("${weather?.sunrise?.hour}:${weather?.sunrise?.minute}"),
              ],
            ),
            Column(
              children: [
                const Icon(Icons.brightness_3),
                Text("${weather?.sunset?.hour}:${weather?.sunset?.minute}"),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "Cloudiness: ${weather?.cloudiness}%",
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
