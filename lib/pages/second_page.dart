import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../bloc.dart";
import "../styles.dart";
import "../fetch/weather.dart";

class SecondPage extends StatelessWidget{
  const SecondPage({super.key});
  @override
  Widget build(BuildContext context){
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state){
        if(state is WeatherLoaded){
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: state.weatherData.dailyWeather.map<WeatherTile>((weather)=>WeatherTile(weather)).toList()
          );
        }
        return const SizedBox();
      }
    );
  }
}

class WeatherTile extends StatelessWidget{
  final DailyWeather weather;
  final EdgeInsets padding;
  const WeatherTile(this.weather, {this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 5),super.key});
  @override
  Widget build(BuildContext context){
    return GestureDetector(
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${weather.date}", style: bold(size: 20)),
            SizedBox(width: MediaQuery.of(context).size.width*0.27),
            Column(
              children: [
                Text("${weather.mintemp}°С", style: bold()),
                Text("MIN", style: bold(color: Colors.red, size: 10))
              ]
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Text("${weather.maxtemp}°С", style: bold()),
                Text("MAX", style: bold(color: Colors.green, size: 10))
              ]
            ),
            const SizedBox(width: 5),
            Image.network(weather.weatherCondition.icon, height: 30, width: 30)
          ]
        )
      )
    );
  }
}