import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:weather/bloc.dart";
import "../styles.dart";

class FirstPage extends StatelessWidget{
  const FirstPage({super.key});
  @override
  Widget build(BuildContext context){
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if(state is NoWeather) return const SizedBox();
        if(state is WeatherLoaded) {
          return appear(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(state.weatherData.currentWeather.weatherCondition.text, style: bold(size: 28), textAlign: TextAlign.center,),
                Image.network(state.weatherData.currentWeather.weatherCondition.icon, width: 60, height: 60),
                SizedBox(height: 20),
                Text("${state.weatherData.currentWeather.temp_c} °С", style: bold(size: 30), textAlign: TextAlign.center,),
                SizedBox(height: 5),
                Text("${state.weatherData.currentWeather.temp_f} °F", style: bold(size: 30), textAlign: TextAlign.center,),
                SizedBox(height: 10),
                Text("Feels like ${state.weatherData.currentWeather.feelsLike}°С", style: bold(size: 20))
              ],
            ),
          );
        }
        if(state is FetchWeatherError){
          return Center(
            child: Text(
              "Произошла ошибка при загрузке информации о погоде!",
              style: bold(size: 25, color: Colors.red),
              textAlign: TextAlign.center,
            )
          );
        }
        return const SizedBox();
      }
    );
  }
}
