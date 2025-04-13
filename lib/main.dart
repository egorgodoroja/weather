import 'package:flutter/material.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";

import "pages/first_page.dart";
import "pages/second_page.dart";
import "pages/city_bar.dart";

import "bloc.dart";
import "fetch/fetch.dart" as fetch;

void main()async{
  //await dotenv.load();
  String apiKey = "2284af32414e4b968e9144214250504";
  fetch.initApiKey(apiKey);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context)=>MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_)=>CityBloc()..add(LoadCityFromPrefs())
      ),
      BlocProvider(
        create: (_)=>WeatherBloc()
      )
    ],
    child: const App()
  );
}

class App extends StatelessWidget{
  const App({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF0055FF),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0055FF)
        )
      ),
      home: const Home()
    );
  }
}
class Home extends StatefulWidget{
  const Home({super.key});
  @override
  HomeState createState()=>HomeState();
}
class HomeState extends State<Home>{
  final pageController = PageController();
  int currentPageIndex = 0;
  final List<Widget> pages = [
    const FirstPage(),
    const SecondPage()
  ];
  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: ()async{
        if(context.read<CityBloc>().state is NoCity){
          if(!fetch.weather.hasData){
            return true;
          }
          context.read<CityBloc>().add(InputCityManually(fetch.weather.cityName!));
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          alignment: Alignment.center,
          children: [
            PageView(
              controller: pageController,
              children: pages,
            ),
            BlocBuilder<CityBloc, CityState>(
              builder: (context, state){
                if(state is LoadingCity){
                  return const SizedBox();
                }
                if(state is CityExists){
                  context.read<WeatherBloc>().add(LoadWeather(state.city));
                }
                return
                  AnimatedAlign(
                  alignment: state is NoCity ? Alignment.center : Alignment.topCenter,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                  child: SizedBox(height: 60, child: CityBar())
                );
              }
            )
          ]
        )
      ),
    );
  }
  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }
}

