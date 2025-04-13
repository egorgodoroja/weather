import "package:flutter/material.dart";
TextStyle bold({Color color = Colors.white, FontWeight weight = FontWeight.w800, double? size}){
  return TextStyle(
      color: color,
      fontWeight: weight,
      fontSize: size,
      fontFamily: "Geologica"
  );
}
Widget appear({required Widget child}){
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