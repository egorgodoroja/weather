
import 'package:weather/fetch/fetch.dart';

class Date{
  final int year;
  final int month;
  final int day;
  Date(this.year, this.month, this.day);
  static Date parse(String date){
    List<int> list = date.split("-").map<int>(int.parse).toList();
    return Date(list[0], list[1], list[3]);
  }
  @override
  String toString(){
    return "$year-$month-$day";
  }
}

class WeatherCondition{
  final String text;
  final String icon;
  WeatherCondition(this.text, this.icon);
  static WeatherCondition fromJson(Map<String, dynamic> json){
    return WeatherCondition(json["text"], "http:${json["icon"]}");
  }
}
class CurrentWeather{
  final WeatherCondition weatherCondition;
  final double temp_c;
  final double temp_f;
  final double feelsLike;
  final bool isDay;
  CurrentWeather(this.weatherCondition, this.temp_c, this.temp_f, this.feelsLike, this.isDay);
  static CurrentWeather fromJson(Map<String, dynamic> json){
    return CurrentWeather(
        WeatherCondition.fromJson(json["current"]),
        json["temp_c"],
        json["temp_f"],
        json["feelslike_c"],
        json["isDay"]==1
    );
  }
}
class HourlyWeather{
  final int hour;
  final WeatherCondition weatherCondition;
  final double temp_c;
  final double temp_f;
  final double feelsLike;
  HourlyWeather(this.hour, this.weatherCondition, this.temp_c, this.temp_f, this.feelsLike);
  static HourlyWeather fromJson(Map<String, dynamic> json){
    return HourlyWeather(
        hourFromJson(json["time"]),
        WeatherCondition.fromJson(json["condition"]),
        json["temp_c"],
        json["temp_f"],
        json["feelslike_c"]
    );
  }
  static int hourFromJson(String time){
    return int.parse(time.split(" ")[1].split(":")[0]);
  }
}
class DailyWeather{
  final Date date;
  final List<HourlyWeather> hourlyWeather;
  final WeatherCondition weatherCondition;
  final double maxtemp;
  final double mintemp;
  DailyWeather(this.date, this.weatherCondition, this.hourlyWeather, this.maxtemp, this.mintemp);
  static DailyWeather fromJson(Map<String, dynamic> json){
    return DailyWeather(
        Date.parse(json["date"]),
        json["day"]["condition"],
        (json["hour"] as List<Map<String, dynamic>>).map<HourlyWeather>(HourlyWeather.fromJson).toList(),
        json["day"]["maxtemp_c"],
        json["day"]["mintemp_c"]
    );
  }
}
class WeatherData{
  final CurrentWeather currentWeather;
  final List<DailyWeather> dailyWeather;
  WeatherData(this.currentWeather, this.dailyWeather);
  static WeatherData fromJson(Map<String, dynamic> json){
    return WeatherData(
        CurrentWeather.fromJson(json["current"]),
        (json["forecast"]["forecastday"] as List<Map<String, dynamic>>).map<DailyWeather>(DailyWeather.fromJson).toList()
    );
  }
}