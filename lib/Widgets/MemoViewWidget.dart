import 'package:endingcredit/DataBase/DataBase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MemoViewWidget extends StatelessWidget {
  final Movie movie;
  MemoViewWidget({this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).backgroundColor,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      movie.movieOriginalTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Lobster',
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Container(
                    color: Theme.of(context).primaryColorLight,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        " ${movie.movieTitle} ",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.0,
                  ),
                  Text(
                    movie.memoEditTime,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                        fontFamily: 'Cookie'),
                  ),
                ],
              ),
            ),
            movie.ratings == 0.0
                ? Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Container(
                      child: Text(
                        " 평가헤주세요! ",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15.0),
                      ),
                      color: Theme.of(context).primaryColorLight,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Theme.of(context).accentColor,
                          size: 20.0,
                        ),
                        Text(
                          movie.ratings.toString(),
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontFamily: 'DoHyeon',
                              fontSize: 15.0),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget starmaker(double movierate) {
    if (movierate == 0.5) {
      return Row(
        children: [Icon(Icons.star_half_sharp)],
      );
    } else if (movierate == 1.0) {
      return Row(
        children: [Icon(Icons.star)],
      );
    } else if (movierate == 1.5) {
      return Row(
        children: [Icon(Icons.star), Icon(Icons.star_half_sharp)],
      );
    } else if (movierate == 2.0) {
      return Row(
        children: [Icon(Icons.star), Icon(Icons.star)],
      );
    } else if (movierate == 2.5) {
      return Row(
        children: [
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star_half_sharp)
        ],
      );
    } else if (movierate == 3.0) {
      return Row(
        children: [Icon(Icons.star), Icon(Icons.star), Icon(Icons.star)],
      );
    } else if (movierate == 3.5) {
      return Row(
        children: [
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star_half_sharp)
        ],
      );
    } else if (movierate == 4.0) {
      return Row(
        children: [
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star)
        ],
      );
    } else if (movierate == 4.5) {
      return Row(
        children: [
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star_half_sharp)
        ],
      );
    } else {
      return Row(
        children: [
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star),
          Icon(Icons.star)
        ],
      );
    }
  }
}
