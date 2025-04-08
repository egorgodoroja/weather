import "package:http/http.dart" as http;
import "dart:convert";

class WeatherData{
  final double temp_c;
  final double temp_f;
  final String weatherDescription;
  WeatherData(this.temp_c, this.temp_f, this.weatherDescription);
  static WeatherData fromJson(Map<String, dynamic> json){
    return WeatherData(json["current"]["temp_c"], json["current"]["temp_f"], json["current"]["condition"]["text"]);
  }
}

late String apiKey;

Future<WeatherData> fetchCurrentWeather(String cityName)async{
  Uri url = Uri.parse("http://api.weatherapi.com/v1/current.json?q=$cityName");
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

