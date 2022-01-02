import 'package:endingcredit/DataBase/DataBase.dart';
import 'package:endingcredit/Screens/EditScreenForSearchScreen.dart';
import 'package:endingcredit/Screens/SearchScreen.dart';
import 'package:endingcredit/Screens/WantMovieListScreen.dart';
import 'package:endingcredit/Widgets/MemoViewWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String deleteId = '';

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
          primaryColorLight: Theme.of(context).primaryColorLight,
          textTheme: TextTheme(
            headline1: Theme.of(context).textTheme.headline1,
            bodyText1: Theme.of(context).textTheme.bodyText1,
            bodyText2: Theme.of(context).textTheme.bodyText1,
          )),
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Container(
              padding: EdgeInsets.all(3.0),
              color: Theme.of(context).accentColor,
              child:
                  Text("엔딩 크레딧", style: Theme.of(context).textTheme.headline1)),
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WantMovieListScreen()));
              },
              icon: Icon(
                Icons.lightbulb_outline,
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15.0)),
                  width: double.infinity,
                  height: 40.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "메모를 남기고 싶은 영화를 검색하세요",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Icon(
                        Icons.search,
                        color: Theme.of(context).accentColor,
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(child: movieBuilder(context))
            ],
          ),
        ),
      ),
    );
  }

  Widget movieBuilder(BuildContext parentContext) {
    return FutureBuilder(
        builder: (context, snap) {
          if (snap.data == null || snap.data.length == 0) {
            return Container(
              alignment: Alignment.center,
              child: Text(
                '메모를 지금바로 추가해보세요\n추가된 메모를 꾹 누르면 삭제할 수 있습니다.',
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snap.data.length,
                itemBuilder: (context, index) {
                  Movie movie = snap.data[index];
                  return buildMovieTile(movie, context, parentContext, index);
                });
          }
        },
        future: loadMemotable());
  }

  Widget buildMovieTile(Movie movie, BuildContext context,
      BuildContext parentContext, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            parentContext,
            MaterialPageRoute(
              builder: (context) => EditScreenForSearchScreen(
                id: movie.id,
                movieTitle: movie.movieTitle,
                memoText: movie.movieMemo,
                memoEditTime: movie.memoEditTime,
                memoRating: movie.ratings,
                movieOriginalTitle: movie.movieOriginalTitle,
                oneLineText: movie.movieOneLine,
              ),
            ));
      },
      onLongPress: () {
        deleteId = movie.id;
        showAlertDialog(parentContext);
      },
      child: MemoViewWidget(movie: movie),
    );
  }

  Future<List<Movie>> loadMemotable() async {
    DBHelper dbHelper = DBHelper();
    return await dbHelper.movies(1);
  }

  Future<void> deleteMemo(String id) async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.deleteMemo(id);
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
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
              "정말 삭제하시겠습니까?\n삭제된 메모는 복구되지 않습니다.",
              style:
                  TextStyle(color: Colors.white)),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context, "삭제");
                setState(() {
                  deleteMemo(deleteId);
                });
                deleteId = '';
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 20.0, right: 25.0, left: 10.0),
                child: Text('삭제',
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'NanumGothicCoding')),
              ),
            ),
            InkWell(
              onTap: () {
                deleteId = '';
                Navigator.pop(context, "취소");
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 20.0, right: 25.0, left: 10.0),
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
}
