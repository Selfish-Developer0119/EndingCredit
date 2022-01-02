import 'package:flutter/material.dart';

class Theaterwidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0,
      child: Column(
        children: [
          SeatRowfiveWidget(),
          SeatRowfiveWidget(),
          SeatRowfiveWidget(),
          SeatRowfiveWidget(),
          SeatRowfiveWidget(),
          SeatRowfiveWidget(),
          SeatRowfiveWidget(),
        ],
      ),
    );
  }
}

class SeatRowfiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SeatWidget(),
        SeatWidget(),
        SeatWidget(),
        SeatWidget(),
        SeatWidget(),
      ],
    );
  }
}

class SeatWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(right: 1.0, left: 1.0),
          height: 42.0,
          width: 55.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0)),
              color: Color(0xFFA8202C)),
          child: Center(
            child: Text(
              "",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Color(0xFF470210),
          ),
          height: 4.0,
          width: 55.0,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Color(0xFF690303),
          ),
          height: 10.0,
          width: 55.0,
        ),
        SizedBox(height: 1,)
      ],
    );
  }
}
