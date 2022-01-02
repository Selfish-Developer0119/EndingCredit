import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:endingcredit/DataBase/DataBase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'HomeScreen.dart';

class EditScreenForSearchScreen extends StatefulWidget {
  EditScreenForSearchScreen({
    this.id,
    this.movieTitle,
    this.memoText,
    this.oneLineText,
    this.memoEditTime,
    this.memoRating,
    this.memoed,
    this.watched,
    this.movieOriginalTitle,
  });

  final String id;
  final String movieTitle;
  final String memoText;
  final String oneLineText;
  final String memoEditTime;
  final double memoRating;
  final int memoed;
  final int watched;
  final String movieOriginalTitle;

  @override
  _EditScreenForSearchScreenState createState() =>
      _EditScreenForSearchScreenState();
}

class _EditScreenForSearchScreenState extends State<EditScreenForSearchScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController<double> _ratings;
  StreamController<String> _editTime;

  String deleteId = '';
  bool alertState;
  String title = '';
  String text = '';
  String oneLinememo = '';
  double movieRating = 0.0;
  String editTime = DateFormat('yyyy년 MM월 dd일').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    movieRating = widget.memoRating;
    editTime = widget.memoEditTime;
    _editTime = new StreamController<String>();
    _ratings = new StreamController<double>();
    _ratings.add(widget.memoRating);
    _editTime.add(widget.memoEditTime);
  }

  void _changeRatings() {
    _ratings.add(movieRating);
  }

  void _changeTime() {
    _editTime.add(editTime);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            brightness: Theme.of(context).brightness,
            scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            primaryColor: Theme.of(context).primaryColor,
            accentColor: Theme.of(context).accentColor,
            backgroundColor: Theme.of(context).backgroundColor,
            textTheme: TextTheme(
              headline1: Theme.of(context).textTheme.headline1,
              bodyText1: Theme.of(context).textTheme.bodyText1,
              bodyText2: Theme.of(context).textTheme.bodyText1,
            )),
        home: Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  updateDB();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false);
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.save_alt,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    if (this.title == '' || this.title == null) {
                      showSnackbarWithKey("메모를 남겨주세요!.");
                    } else {
                      updateDB();
                      showSnackbarWithKey("저장되었습니다.");
                    }
                  },
                )
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            body: Container(
              child: loadBuilder(),
            )),
      ),
    );
  }

  loadBuilder() {
    return FutureBuilder<List<Movie>>(
      future: loadMemo(widget.id),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.data == null || snapshot.data == []) {
          return Container(child: Text("데이터를 불러올 수 없습니다."));
        } else {
          title = widget.movieTitle;
          var tecTitle = TextEditingController();
          tecTitle.text = widget.movieTitle;

          text = widget.memoText;
          var tecText = TextEditingController();
          tecText.text = widget.memoText;

          oneLinememo = widget.oneLineText;
          var tecOneLineText = TextEditingController();
          tecOneLineText.text = widget.oneLineText;

          return ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                      stream: _editTime.stream,
                      builder: (BuildContext context, snapshot) {
                        _changeTime();
                        return InkWell(
                          child: Center(
                            child: Center(
                              child: Text(
                                editTime,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                          onTap: () async {
                            DateTime date = await PlatformDatePicker.showDate(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year - 20),
                                lastDate: DateTime(DateTime.now().year + 1),
                                showCupertino: true);
                            editTime = DateFormat('yyyy년 MM월 dd일').format(date);
                          },
                        );
                      },
                    ),
                  ), //날짜
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 35.0, bottom: 35.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            widget.movieOriginalTitle,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontFamily: 'Lobster', fontSize: 30.0),
                          ),
                        ),
                        Container(
                          color: Theme.of(context).accentColor,
                          child: Text(
                            " ${widget.movieTitle} ",
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 23.0),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 35.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            "영화의 별점을 입력해주세요.",
                            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 17.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: RatingBar.builder(
                            itemSize: 43.0,
                            unratedColor: Colors.grey,
                            initialRating: widget.memoRating,
                            itemCount: 5,
                            allowHalfRating: true,
                            itemBuilder: (context, int index) {
                              return Icon(
                                Icons.star,
                                color: Theme.of(context).accentColor,
                              );
                            },
                            onRatingUpdate: (rating) {
                              movieRating = rating;
                            },
                          ),
                        ),
                        StreamBuilder(
                          stream: _ratings.stream,
                          builder: (BuildContext context, snapshot) {
                            _changeRatings();
                            return Text(
                              setRateState(movieRating),
                              style:Theme.of(context).textTheme.bodyText1,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "영화의 한줄 평을 남겨주세요!",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      RotatedBox(
                        quarterTurns: 90,
                        child: Text(
                          "\”",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 60.0, fontFamily: 'SongMyung'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          cursorColor: Theme.of(context).accentColor,
                          autofocus: false,
                          style:Theme.of(context).textTheme.bodyText1.copyWith(height: 1.4, fontSize: 20.0, fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                              counterStyle: TextStyle(
                                  color: Colors.grey, fontSize: 13.0),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent),
                                  borderRadius:
                                  BorderRadius.circular(10.0)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent),
                                  borderRadius:
                                  BorderRadius.circular(10.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent),
                                  borderRadius:
                                  BorderRadius.circular(10.0)),
                              filled: false,
                              hintText: "한 줄평을 남겨주세요! 45자 제한이 있습니다.",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 17.0,)),
                          controller: tecOneLineText,
                          maxLength: 45,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          onChanged: (String text) {
                            this.oneLinememo = text;
                          },
                        ),
                      ),
                      Text(
                        "\”", style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 60.0,fontFamily: 'SongMyung'),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                  Column(
                    children: [
                      Text(
                        "엔딩크레딧이 올라가는 지금, 메모하세요!",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 18.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, bottom: 30.0),
                        child: TextField(
                          textAlign: TextAlign.center,
                          cursorColor: Theme.of(context).accentColor,
                          autofocus: false,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.8, fontSize: 14.0,),
                          decoration: InputDecoration(
                              counterStyle: TextStyle(
                                  color: Colors.grey, fontSize: 13.0),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10.0)),
                              filled: false,
                              hintText: "엔딩 크레딧이 올라가는 순간, 메모를 남겨보세요!",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0)),
                          controller: tecText,
                          maxLines: null,
                          onChanged: (String text) {
                            this.text = text;
                          },
                        ),
                      ),
                    ],
                  ),

                ],
              )
            ],
          );
        }
      },
    );
  }
  showSnackbarWithKey(String snackbartext) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          snackbartext,
          style: TextStyle(fontFamily: 'NanumMyeongjo', color: Colors.white),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF485B67)));
  }

  String memosha512(String text) {
    var bytes = utf8.encode(text);
    var digest = sha512.convert(bytes);
    return digest.toString();
  }

  void updateDB() {
    DBHelper dbHelper = DBHelper();

    var moviefido = Movie(
      id: widget.id,
      movieTitle: this.title,
      movieMemo: this.text,
      memoEditTime: editTime,
      ratings: movieRating,
      memoed: this.text == '' || this.text == null ? 0 : 1,
      watched: movieRating == 0.0 && this.text == '' && this.oneLinememo == '' ? 0 : 1,
      movieOriginalTitle: widget.movieOriginalTitle,
      movieOneLine: this.oneLinememo,
    );

    dbHelper.updateMemo(moviefido);
  }

  Future<void> deleteMemo(String id) async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.deleteMemo(id);
  }

  Future<List<Movie>> loadMemo(String id) async {
    DBHelper dbHelper = DBHelper();
    return await dbHelper.findMemo(id);
  }

  void showAlertDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF222222),
          title: Text(
            '삭제 경고',
            style: TextStyle(color: Colors.red, fontFamily: 'NanumMyeongjo'),
          ),
          content: Text(
              "정말 삭제하시겠습니까?\n\n삭제된 메모는 복구되지 않으며, \"보고 싶은 영화\", \"내가 본 영화\" 탭에서도 삭제됩니다.",
              style:
                  TextStyle(color: Colors.white, fontFamily: 'NanumMyeongjo')),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false);
                setState(() {
                  deleteMemo(deleteId);
                  //alertState = true;
                });
                deleteId = '';
              },
              child: Container(
                child: Text('삭제',
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'NanumGothicCoding')),
              ),
            ),
            InkWell(
              onTap: () {
                alertState = false;
                deleteId = '';
                Navigator.pop(context, "취소");
              },
              child: Container(
                child: Text('취소',
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'NanumGothicCoding')),
              ),
            ),
          ],
        );
      },
    );
  }

  String setRateState(double ratingpoint) {
    if (ratingpoint == 0.0) {
      return "평가를 입력해주세요.";
    } else if (ratingpoint == 0.5) {
      return "완전 별로에요.";
    } else if (ratingpoint == 1.0) {
      return "별로에요";
    } else if (ratingpoint == 1.5) {
      return "마음에 들지 않았어요";
    } else if (ratingpoint == 2.0) {
      return "부족해요";
    } else if (ratingpoint == 2.5) {
      return "만족스럽진 않아요";
    } else if (ratingpoint == 3.0) {
      return "나쁘지 않아요";
    } else if (ratingpoint == 3.5) {
      return "마음에 들었어요";
    } else if (ratingpoint == 4.0) {
      return "좋았어요!";
    } else if (ratingpoint == 4.5) {
      return "명작이에요!";
    } else if (ratingpoint == 5.0) {
      return "완벽해요!";
    } else {
      return "평가를 입력해주세요.";
    }
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.childWidget, this.movietitle});

  final Widget childWidget;
  final String movietitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: childWidget,
    );
  }

}
