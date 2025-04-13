import "package:http/http.dart" as http;
import "dart:convert";
import "weather.dart";
late String apiKey;
Future<WeatherData> fetchWeather(String cityName)async{
  Uri url = Uri.parse("http://api.weatherapi.com/v1/forecast.json?q=$cityName&days=5");
  final headers = {
    "key":apiKey
  };
  try{
    final res = await http.get(url, headers: headers);
    if(res.statusCode!=200){
      return Future.error("Invalid status code ${res.statusCode}");
    }
    return WeatherData.fromJson(jsonDecode(res.body));
  }catch(e){
    return Future.error("$e");
  }
}
