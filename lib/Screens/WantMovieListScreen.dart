import 'dart:convert';
import 'package:endingcredit/Screens/EditScreenForSearchScreen.dart';
import 'package:crypto/crypto.dart';
import 'package:endingcredit/DataBase/DataBase.dart';
import 'package:endingcredit/Widgets/MovieWatchStateViewWidget.dart';
import 'package:flutter/material.dart';
import 'SearchScreen_for_Subscreen.dart';

class WantMovieListScreen extends StatefulWidget {
  @override
  _WantMovieListScreenState createState() => _WantMovieListScreenState();
}

class _WantMovieListScreenState extends State<WantMovieListScreen> {
  final myController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String movieTitle = '';
  String localTitle = '';
  String deleteId = '';
  String localId = '';
  String localMemo = '';
  String localOneLineText = '';
  String localEditTime = '';
  double localRating = 0.0;
  String movieOriginalTitle = '';
  int memoState = 0;
  int watchState = 0;

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
          )),
      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(3.0),
                color: Theme.of(context).accentColor,
                child: Text(
                  " 보고 싶은 영화 ",
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 20.0),
                ),
              ),
            ],
          ),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: [
            Icon(
              Icons.remove,
              color: Colors.transparent,
            ),
            Icon(
              Icons.remove,
              color: Colors.transparent,
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 1.0, left: 8.0, right: 8.0, bottom: 8.0),
              child: InkWell(
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
                        "보고 싶은 영화를 검색하세요",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Icon(
                        Icons.search,
                        color: Theme.of(context).accentColor,
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchScreen_for_Subscreen(
                                watch: false,
                              )));
                },
              ),
            ),
            Expanded(child: mldbBuilder(context)),
          ],
        ),
      ),
    );
  }

  Widget mldbBuilder(BuildContext parentContext) {
    return FutureBuilder(
        builder: (context, snap) {
          if (snap.data == null || snap.data.length == 0) {
            return Container(
              alignment: Alignment.center,
              child: Text(
                '보고 싶은 영화를 추가해보세요.\n 영화를 다 봤다면, 해당 타일을 오른쪽으로 스와이프하세요!\n \"다 본 영화\" 탭으로 이동됩니다.\n\n완전히 삭제하기 위해서는 길게 누르세요.',
                style:
                    TextStyle(color: Colors.grey, fontFamily: 'NanumMyeongjo'),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
                itemCount: snap.data.length,
                itemBuilder: (context, index) {
                  Movie movie = snap.data[index];
                  return buildWatchWidget(context, movie, parentContext);
                });
          }
        },
        future: loadUnwatchedMovies());
  }

  Widget buildWatchWidget(BuildContext context, Movie movie, BuildContext parentContext) {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(
            parentContext,
            MaterialPageRoute(
                builder: (context) => EditScreenForSearchScreen(
                      id: movie.id,
                      movieTitle: movie.movieTitle,
                      memoEditTime: movie.memoEditTime,
                      memoRating: movie.ratings,
                      memoText: movie.movieMemo,
                      watched: movie.watched,
                      movieOriginalTitle: movie.movieOriginalTitle,
                      oneLineText: movie.movieOneLine,
                    )),
            (route) => false);
      },
      onLongPress: () {
        deleteId = movie.id;
        showAlertDialog(context);
      },
      child: MovieWatchStateViewWidget(
        movie: movie,
        memoed: movie.memoed,
      ),
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

  Future<List<Movie>> loadUnwatchedMovies() async {
    DBHelper dbHelper = DBHelper();
    return await dbHelper.watchedMovies(0);
  }

  void updateUnwatchedMovies() {
    DBHelper dbHelper = DBHelper();

    var moviefido = Movie(
      id: localId,
      movieTitle: localTitle,
      watched: watchState,
      movieMemo: localMemo,
      memoed: memoState,
      memoEditTime: localEditTime,
      ratings: localRating,
      movieOriginalTitle: movieOriginalTitle,
      movieOneLine: localOneLineText,
    );

    dbHelper.updateMemo(moviefido);
  }

  Future<void> deleteMovie(String id) async {
    DBHelper dbHelper = DBHelper();
    await dbHelper.deleteMemo(id);
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
            '삭제 경고',
            style:
                TextStyle(color: Colors.redAccent, fontFamily: 'NanumMyeongjo'),
          ),
          content: Text("정말 삭제하시겠습니까?\n삭제된 영화는 복구되지 않으며, 기록된 메모도 함께 삭제됩니다.",
              style:
                  TextStyle(color: Colors.white, fontFamily: 'NanumMyeongjo')),
          actions: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  deleteMovie(deleteId);
                  Navigator.pop(context, "삭제");
                });
                deleteId = '';
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Container(
                  child: Text('삭제',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'NanumGothicCoding')),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                deleteId = '';
                Navigator.pop(context, "취소");
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Container(
                  child: Text('취소',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'NanumGothicCoding')),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
