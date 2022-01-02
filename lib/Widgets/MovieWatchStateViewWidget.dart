import 'package:endingcredit/DataBase/DataBase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieWatchStateViewWidget extends StatefulWidget {
  final Movie movie;
  final int memoed;

  MovieWatchStateViewWidget({this.movie, this.memoed});

  @override
  _MovieWatchStateViewWidgetState createState() =>
      _MovieWatchStateViewWidgetState();
}

class _MovieWatchStateViewWidgetState extends State<MovieWatchStateViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
          color: Color(0xFF181818),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0),
              bottomLeft: Radius.circular(7.0),
              bottomRight: Radius.circular(7.0))),
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.only(left: 17.0, right: 17.0),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(3.0),
                    color: Colors.white,
                    width: 200.0,
                    child: Text(
                      widget.movie.movieOriginalTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Lobster',
                          fontSize: 22.0,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Container(
                    child: Text(
                      '\"${widget.movie.movieTitle}\"',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'DoHyeon',
                          fontSize: 17.0,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(3.0),
                color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.movie.ratings == 0.0 || widget.movie.ratings == null
                        ? Text(
                            "평가해주세요!",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'NanumGothic',
                                fontWeight: FontWeight.bold),
                          )
                        : Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.black,
                                size: 15.0,
                              ),
                              Text(
                                widget.movie.ratings.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 60.0),
            child: MemoState(widget.memoed),
          ),
        ],
      ),
    );
  }
}

Widget MemoState(int memoExist) {
  if (memoExist == 0 || memoExist == null) {
    return Container(child: Text(''));
  } else {
    return RotationTransition(
      turns: AlwaysStoppedAnimation(15 / 360),
      child: Container(
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.red, width: 3.0),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Text(
          "MEMOED",
          style: TextStyle(
              color: Colors.red,
              fontFamily: 'NanumGothic',
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
