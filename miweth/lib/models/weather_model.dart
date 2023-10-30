class Weather{
  final String cityName;
  final double temperature;
  final String mainCondition;
  final double windSpeed;
  Weather({required this.cityName, required this.temperature, required this.mainCondition, required this.windSpeed});
  factory Weather.fromJson(Map<String,dynamic> json){
    return Weather(cityName: json["name"], temperature: json["main"]["temp"].toDouble()-273.15, windSpeed: json["wind"]["speed"],mainCondition: json["weather"][0]["main"]);
  }
}