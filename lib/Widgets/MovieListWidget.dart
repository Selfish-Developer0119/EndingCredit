import 'package:flutter/material.dart';

class MovieLIstWidget extends StatelessWidget {
  final String textinput;
  final String textdetail;
  final Widget setPage;

  MovieLIstWidget({this.textinput, this.textdetail, this.setPage});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: (){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => setPage));
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: Colors.black,//Color(0xFF222222),
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.all(3.0),
          height: 80.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textinput,
                style: TextStyle(
                    fontFamily: 'NotoSerifKR', fontSize: 20.0, color: Colors.white),
              ),
              Text(
                textdetail,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'NanumMyeongjo',
                    fontSize: 11.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
