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
  Weather? weather;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    wf.currentWeatherByCityName("Colombo").then((w) {
      setState(() {
        weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locationHeader(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.08,
          ),
          _dateTimeInfo(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.08,
          ),
          _weatherIcon(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.08,
          ),
          _currentTemp(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.08,
          ),
          _extraInfo(),
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Text(weather?.areaName ?? "",
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ));
  }

  Widget _dateTimeInfo() {
    DateTime now = weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("hh:mm a").format(now),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE,").format(now),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            Text(
              "  ${DateFormat("d MMMM y").format(now)}",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
          ],
        )
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "http://openweathermap.org/img/wn/${weather?.weatherIcon ?? '01d'}@4x.png",
              ),
            ),
          ),
        ),
        Text(
          weather?.weatherDescription ?? "",
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${weather?.temperature?.celsius?.round()}°C",
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _extraInfo() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.wb_sunny),
              Text(
                "${weather?.sunrise?.hour}:${weather?.sunrise?.minute}",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Icon(Icons.brightness_3),
              Text(
                "${weather?.sunset?.hour}:${weather?.sunset?.minute}",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.water_damage),
              Text(
                "${weather?.humidity}%",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Icon(Icons.cloud),
              Text(
                "${weather?.cloudiness}%",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
