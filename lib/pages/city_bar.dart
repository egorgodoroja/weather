import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:weather/bloc.dart";
import "../styles.dart";

class CityBar extends StatelessWidget{
  CityBar({super.key});
  @override
  Widget build(BuildContext context){
    return Center(
      child: BlocBuilder<CityBloc, CityState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: ()=>context.read<CityBloc>().add(NewCity()),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: state is NoCity ? MediaQuery.of(context).size.width*0.75 : MediaQuery.of(context).size.width*0.8,
              height: 65,
              padding: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xff0cf22b), width: 4),
                borderRadius: BorderRadius.circular(33)
              ),
              child: Center(
                child: state is CityExists ?
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Color(0xff0cf22b), size: 35),
                        const SizedBox(width: 10),
                        Text(state.city.toUpperCase(), style: bold(size: 30, color: Color(0xff0cf22b)))
                      ]
                    ):
                  TextField(
                    controller: controller,
                    style: bold(
                      size: 30,
                      color: Colors.black
                    ),
                    cursorColor: Color(0xff0cf22b),
                    decoration: InputDecoration(
                      hintText: "Enter city name",
                      hintStyle: bold(size: 28, color: Colors.grey),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onEditingComplete: ()=>onTap(context),
                  )
            )),
          );
        }
      )
    );
  }
  void onTap(BuildContext context){
    if(controller.text.length>=3){
      context.read<CityBloc>().add(InputCityManually(controller.text));
    }
  }
  final controller = TextEditingController();
}