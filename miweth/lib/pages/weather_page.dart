import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:miweth/models/weather_model.dart';
import 'package:miweth/weather_service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService(apiKey: "c3d2ca357c7640729758d8c4410b1eb9");
  Weather? _weather;
  void _fetchWeather() async {
    try{
      String city = await _weatherService.getCurrentLocation();
      final weather =  await _weatherService.getWeather(cityName: city);
      setState(() {
        _weather = weather;
      });
    }
    catch (e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  String getMainCondition(String? mainCondition){
    if(mainCondition == null) return "assets/sunny.json";
    switch(mainCondition){
      case 'clouds':
        return "assets/cloud.json";
      case 'mist':
      return "assets/mist.json";
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return "assets/mist.json";
      case "rain":
      case "drizzle":
      return "assets/rainy.json";
      case "shower rain":
        return "assets/rain.json";
      case "thunderstorm":
        return "assets/thunder.json";
      case "clear":
        return "assets/clear.json";
      default:
        return "assets/sunny.json";

    }
  }
  @override
  Widget build(BuildContext context) {

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: (_weather?.mainCondition==null || _weather?.cityName==null)?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(textAlign:TextAlign.center,"WEATHER ANALYZING!",style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.inversePrimary,fontSize: 30),),
              const SizedBox(height: 20,),
              CircularProgressIndicator(color: Theme.of(context).colorScheme.inversePrimary,)
            ],
          )
        ):Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_weather?.cityName??"Loading city",style:  TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.inversePrimary,fontSize: 30),),
                    Text(_weather?.mainCondition??"",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,fontWeight: FontWeight.normal,fontSize: 15,letterSpacing: 10)),
                  ],
                ),
              ),
              Lottie.asset(getMainCondition(_weather!.mainCondition.toLowerCase())),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text("${_weather?.temperature.round()} °C",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,fontWeight: FontWeight.bold,fontSize: 30)),
              ),


            ],
          ),
        ),
      );
  }
}
