import 'dart:convert';
import 'package:endingcredit/DataBase/DataBase.dart';
import 'package:endingcredit/Screens/HomeScreen.dart';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import 'package:endingcredit/Constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen_for_Subscreen extends StatefulWidget {
  SearchScreen_for_Subscreen({this.watch});
  final bool watch;

  @override
  SearchScreen_for_SubscreenState createState() =>
      SearchScreen_for_SubscreenState();
}

class SearchScreen_for_SubscreenState
    extends State<SearchScreen_for_Subscreen> {
  List data;
  int count = 0;
  String query = '';
  String movietitle;
  String movieOriginalTitle;

  int watchstate = 0;

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
          dialogBackgroundColor: Theme.of(context).dialogBackgroundColor,
          primaryColor: Theme.of(context).primaryColor,
          accentColor: Theme.of(context).accentColor,
          backgroundColor: Theme.of(context).backgroundColor,
          textTheme: TextTheme(
            headline1: Theme.of(context).textTheme.headline1,
            bodyText1: Theme.of(context).textTheme.bodyText1,
            bodyText2: Theme.of(context).textTheme.bodyText1,
          )),
      home: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0.0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: Theme.of(context).accentColor,
                )),
            title: Container(
              child: TextField(
                style: TextStyle(color: Theme.of(context).accentColor),
                onChanged: (text) {
                  query = text;
                  getData();
                },
                autofocus: true,
                cursorColor: Theme.of(context).accentColor,
                decoration: InputDecoration(
                  filled: false,
                  hintText: "영화 제목을 입력하세요.",
                  hintStyle: TextStyle(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
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
            style: Theme.of(context).textTheme.bodyText1,
          ));
        } else if (data.length == 0) {
          return Center(
            child: Text(
              '검색 결과가 없습니다.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        } else {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  movietitle = data[index]['title'];
                  movieOriginalTitle = data[index]['original_title'];
                  showAlertDialog(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
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
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0))
                      ),
                        height: MediaQuery.of(context).size.height * 0.11,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                child: Container(
                                  color: Colors.white,
                                  child: Text(
                                    " ${data[index]['original_title']} ",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20.0, fontFamily: 'Lobster', color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "\"${data[index]['title']}\" ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'NanumGothic'),
                            ),
                          ],
                        )),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Future<void> saveWantMemoDB() async {
    DBHelper dbHelper = DBHelper();

    var moviefido = Movie(
      id: memosha512(DateTime.now().toString()),
      movieMemo: '',
      movieTitle: movietitle,
      memoEditTime: DateFormat('yyyy년 MM월 dd일').format(DateTime.now()),
      ratings: 0.0,
      watched: 0, //메모 추가 시 이미 본 영화로 저장됨.
      memoed: 0,
      movieOriginalTitle: movieOriginalTitle,
      movieOneLine: '',
    );
    await dbHelper.insertMovie(moviefido);
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
                saveWantMemoDB();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
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
}
