import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:weather/bloc.dart";

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
                Text(state.weatherData.weatherDescription, style: bold(size: 28), textAlign: TextAlign.center,),
                SizedBox(height: 20),
                Text("${state.weatherData.temp_c} °С", style: bold(size: 30), textAlign: TextAlign.center,),
                SizedBox(height: 5),
                Text("${state.weatherData.temp_f} °F", style: bold(size: 30), textAlign: TextAlign.center,)
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
  static Widget appear({required Widget child}){
    return FutureBuilder<bool>(
      future: Future.delayed(Duration(milliseconds: 300), ()=>true),
      builder: (context, snapshot){
        return AnimatedOpacity(
          opacity: (snapshot.data ?? false) ? 1:0,
          duration: Duration(milliseconds: 500),
          child: child
        );
      }
    );
  }
}
TextStyle bold({Color color = Colors.white, FontWeight weight = FontWeight.w800, double? size}){
  return TextStyle(
    color: color,
    fontWeight: weight,
    fontSize: size,
    fontFamily: "Geologica"
  );
}