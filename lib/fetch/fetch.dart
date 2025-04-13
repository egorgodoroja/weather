import "weather.dart";
import "fetchresponse.dart" as fetch;

void initApiKey(String key){
  fetch.apiKey = key;
}

class Weather{
  String? cityName;
  WeatherData? weatherData;
  DateTime time = DateTime.now();
  Weather({
    this.cityName,
    this.weatherData,
  });
  bool get hasData => weatherData!=null;
}
Weather weather = Weather();
Future<WeatherData> fetchWeather(String cityName)async{
  if(cityName!=weather.cityName){
    weather.weatherData = await fetch.fetchWeather(cityName);
    weather.cityName = cityName;
    return weather.weatherData!;
  }
  if(weather.hasData){
    return weather.weatherData!;
  }
  weather.weatherData = await fetch.fetchWeather(cityName);
  return weather.weatherData!;
}


