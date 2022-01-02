import 'dart:convert';
import 'dart:ui';
import 'package:endingcredit/DataBase/DataBase.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import 'package:endingcredit/Constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'EditScreenForSearchScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List data;
  int count = 0;
  String query = '';
  String movietitle;
  String movieOriginalTitle;
  int watchstate = 0;

  String localid = '';
  String localtext = '';
  String localOneLineText = '';
  String localtitle = '';
  String localplace = '';
  String localEditTime = '';
  String localMemoImage = '';
  double localRating = 0.0;

  Future<String> getData() async {
    var res = await http.get(Uri.parse(searchurl + query),
        headers: {'accept': 'application/json'});
    setState(() {
      var content = json.decode(res.body);
      data = content['results'];
      count = content['total_results'];
    });
    return 'success!';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            )
        ),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              titleSpacing: 0.0,
              title: Container(
                child: TextField(
                  onChanged: (text) {
                    query = text;
                    getData();
                  },
                  autofocus: true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    filled: false,
                    hintText: "영화 제목을 입력하세요.",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {
                      getData();
                    })
              ],
            ),
            body: Column(
              children: <Widget>[
                Expanded(child: movieBuilder(context)),
              ],
            )),
      );
  }

  Widget movieBuilder(BuildContext parentContext) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (data == null) {
          return Center(
            child: Text(
              '영화를 검색해 주세요!\n영화 데이터는 TMDB에서 제공받습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'DoHyeon', fontSize: 15.0),
            ),
          );
        } else if (data.length == 0) {
          return Center(
            child: Text(
              '검색 결과가 없습니다...\n띄어 쓰기 오류 혹은 오타가 없는지 확인해보세요!',
              style: TextStyle(fontFamily: 'DoHyeon', fontSize: 15.0),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.all(3.0),
                height: 100.0,
                child: GestureDetector(
                  onTap: () {
                    movietitle = data[index]['title'];
                    movieOriginalTitle = data[index]['original_title'];
                    showAlertDialog(context);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: AssetImage('images/appicon.png'),
                            fit: BoxFit.cover
                          )),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width:double.infinity,
                                child: Text(
                                  data[index]['original_title'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontFamily: 'Lobster'),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    data[index]['title'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black,
                                        fontFamily: 'Arvo'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              );
            },
          );
        }
      },
    );
  }

  String memosha512(String text) {
    var bytes = utf8.encode(text);
    var digest = sha512.convert(bytes);
    return digest.toString();
  }

  void showAlertDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF222222),
          title: Text(
            '추가 확인',
            style: TextStyle(color: Colors.white),
          ),
          content: Text("정말 추가하시겠습니까?",
              style:
                  TextStyle(color: Colors.white)),
          actions: <Widget>[
            InkWell(
              onTap: () {
                saveFromSearchScreen();
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditScreenForSearchScreen(
                              id: localid,
                              movieTitle: movietitle,
                          movieOriginalTitle: movieOriginalTitle,
                              watched: watchstate,
                              memoEditTime: localEditTime,
                              memoText: localtext,
                              memoRating: localRating,
                              memoed: 1,
                          oneLineText: localOneLineText,
                            )),
                    (route) => false);
              },
              child: Container(
                padding: EdgeInsets.only(
                    bottom: 20.0, right: 20.0, left: 10.0, top: 20.0),
                child: Text('추가',
                    style: TextStyle(
                        color: Colors.white)),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context, "취소");
              },
              child: Container(
                padding: EdgeInsets.only(
                    bottom: 20.0, right: 20.0, left: 10.0, top: 20.0),
                child: Text('취소',
                    style: TextStyle(
                        color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveFromSearchScreen() async {
    DBHelper dbHelper = DBHelper();

    var moviefido = Movie(
        id: memosha512(DateTime.now().toString()),
        movieTitle: movietitle,
        movieOriginalTitle: movieOriginalTitle,
        watched: watchstate,
        memoEditTime: DateFormat('yyyy년 MM월 dd일').format(DateTime.now()),
        movieMemo: '',
        ratings: 0.0,
        memoed: 1,
        movieOneLine: '');

    localid = moviefido.id;
    localtitle = moviefido.movieTitle;
    localtext = moviefido.movieMemo;
    localOneLineText = moviefido.movieOneLine;
    localEditTime = moviefido.memoEditTime;
    localRating = moviefido.ratings;

    await dbHelper.insertMovie(moviefido);
  }

}
