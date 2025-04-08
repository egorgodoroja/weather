import "package:flutter_bloc/flutter_bloc.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter/material.dart";
import "fetch.dart";

late SharedPreferences prefs;

abstract class CityEvent{}

class LoadCityFromPrefs extends CityEvent{}

class InputCityManually extends CityEvent{
  final String city;
  InputCityManually(this.city);
}

abstract class CityState{}

class LoadingCity extends CityState{}

class NoCity extends CityState{}

class CityExists extends CityState{
  final String city;
  final Alignment alignment;
  CityExists(this.city, [this.alignment = Alignment.topCenter]);
  bool get fetch => alignment==Alignment.topCenter;
}

class CityBloc extends Bloc<CityEvent, CityState>{
  CityBloc():super(LoadingCity()){
    on<LoadCityFromPrefs>(_onLoadCityFromPrefs);
    on<InputCityManually>(_onInputCityManually);
  }
  Future<void> _onLoadCityFromPrefs(LoadCityFromPrefs event, Emitter<CityState> emit)async{
    prefs = await SharedPreferences.getInstance();
    String? city = prefs.getString('city');
    if(city!=null){
      emit(CityExists(city));
      return;
    }
    emit(NoCity());
  }
  Future<void> _onInputCityManually(InputCityManually event, Emitter<CityState> emit)async{
    emit(CityExists(event.city, Alignment.center));
    await Future.delayed(Duration(milliseconds: 200));
    emit(CityExists(event.city));
  }
}

abstract class WeatherEvent{}

class LoadWeather extends WeatherEvent{
  final String city;
  LoadWeather(this.city);
}

abstract class WeatherState{}

class NoWeather extends WeatherState{}

class FetchWeatherError extends WeatherState{}

class WeatherLoaded extends WeatherState{
  final WeatherData weatherData;
  WeatherLoaded(this.weatherData);
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState>{
  WeatherBloc():super(NoWeather()){
    on<LoadWeather>(_onLoadWeather);
  }
  Future<void> _onLoadWeather(LoadWeather event, Emitter<WeatherState> emit)async{
    try{
      WeatherData weatherData = await fetchCurrentWeather(event.city);
      emit(WeatherLoaded(weatherData));
      await prefs.setString("city", event.city);
    }catch(e){
      emit(FetchWeatherError());
    }
  }
}