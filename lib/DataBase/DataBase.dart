import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//TODO: SQFlite에서는 Bool타입이 존재하지 X. 따라서 INT 타입 0과 1로 선언함.

class DBHelper {
  var _db;

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = openDatabase(
      join(await getDatabasesPath(), 'movies.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE movies(id TEXT PRIMARY KEY, movieTitle TEXT, movieMemo TEXT, memoEditTime TEXT, ratings DOUBLE, watched INT, memoed INT, movieOriginalTitle TEXT, movieOneLine TEXT )",
        );
      },
      version: 1,
    );
    return _db;
  }

  Future<void> insertMovie(Movie movie) async {
    final Database db = await database;
    await db.insert(
      'movies',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("insert movie $movie");
  }

  Future<List<Movie>> movies(int numb) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('movies', where: 'watched = ?', whereArgs: [numb]);

    return List.generate(maps.length, (i) {
      return Movie(
        id: maps[i]['id'],
        movieTitle: maps[i]['movieTitle'],
        movieMemo: maps[i]['movieMemo'],
        memoEditTime: maps[i]['memoEditTime'],
        ratings: maps[i]['ratings'],
        watched: maps[i]['watched'],
        memoed: maps[i]['memoed'],
        movieOriginalTitle: maps[i]['movieOriginalTitle'],
        movieOneLine: maps[i]['movieOneLine'],
      );
    });
  }

  Future<List<Movie>> watchedMovies(int numb) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('movies', where: 'watched = ?', whereArgs: [numb]);

    return List.generate(maps.length, (i) {
      return Movie(
          id: maps[i]['id'],
          movieTitle: maps[i]['movieTitle'],
          movieMemo: maps[i]['movieMemo'],
          memoEditTime: maps[i]['memoEditTime'],
          ratings: maps[i]['ratings'],
          watched: maps[i]['watched'],
          memoed: maps[i]['memoed'],
          movieOriginalTitle: maps[i]['movieOriginalTitle'],
      movieOneLine: maps[i]['movieOneLine']);
    });
  }

  Future<void> updateMemo(Movie movie) async {
    final db = await database;

    await db.update(
      'movies',
      movie.toMap(),
      where: "id = ?",
      whereArgs: [movie.id],
    );
    print("update movie $movie");
  }

  Future<void> deleteMemo(String id) async {
    final db = await database;

    await db.delete(
      'movies',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> countMemo() async {
    final db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM movies'));
  }

  Future<List<Movie>> findMemo(String id) async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query('movies', where: 'id = ?', whereArgs: [id]);

    return List.generate(maps.length, (i) {
      return Movie(
          id: maps[i]['id'],
          movieTitle: maps[i]['movieTitle'],
          movieMemo: maps[i]['movieMemo'],
          memoEditTime: maps[i]['memoEditTime'],
          ratings: maps[i]['ratings'],
          watched: maps[i]['watched'],
          memoed: maps[i]['memoed'],
          movieOriginalTitle: maps[i]['movieOriginalTitle'],
          movieOneLine: maps[i]['movieOneLine']);
    });
  }
}

class Movie {
  final String id;
  final String movieTitle;
  final String movieMemo;
  final String memoEditTime;
  final double ratings;
  final int watched;
  final int memoed;
  final String movieOriginalTitle;
  final String movieOneLine;

  Movie(
      {this.id,
      this.movieTitle,
      this.movieMemo,
      this.memoEditTime,
      this.ratings,
      this.memoed,
      this.watched,
      this.movieOriginalTitle,
      this.movieOneLine});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movieTitle': movieTitle,
      'movieMemo': movieMemo,
      'memoEditTime': memoEditTime,
      'ratings': ratings,
      'memoed': memoed,
      'watched': watched,
      'movieOriginalTitle': movieOriginalTitle,
      'movieOneLine' : movieOneLine
    };
  }

  // 각 memo 정보를 보기 쉽도록 print 문을 사용하여 toString을 구현하세요
  @override
  String toString() {
    return 'Movie{id: $id, movieTitle: $movieTitle, movieMemo: $movieMemo, memoEditTime: $memoEditTime, ratings: $ratings, memoed: $memoed, watched: $watched, movieOriginalTitle = $movieOriginalTitle, movieOneLine = $movieOneLine}';
  }
}
