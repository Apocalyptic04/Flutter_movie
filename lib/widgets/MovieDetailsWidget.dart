import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_movies/models/movie.dart';

import '../databaseHelper.dart';

class MovieDetailsWidget extends StatefulWidget {

  final String imdbId;
  MovieDetailsWidget({this.imdbId});

  @override
  _MovieDetailsWidget createState() => _MovieDetailsWidget(imdbId : this.imdbId);

}

class _MovieDetailsWidget extends State<MovieDetailsWidget> {

  final String imdbId;
  _MovieDetailsWidget({this.imdbId});

  Movie movie;
  final dbHelper = DatabaseHelper.instance;

  void _query() async {
    final _movie = await dbHelper.queryMovie(this.imdbId);
    setState(() {
      movie = _movie;
    });
  }

  @override
  initState() {
    super.initState();
    _query();
  }

  @override
  Widget build(BuildContext context) {
    if (movie == null) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text("Loading..."),
          ),
        );
    } else {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(movie.title),
        ),
        body: Align(
          alignment: Alignment(0, -0.4),
          //alignment: Alignment.topCenter,
          //alignment: Alignment(0, -1.7),
          child: Stack(
            children: [new SizedBox(
                width: 200,
                child: ClipRRect(
                  child: Image.network(movie.poster),
                  borderRadius: BorderRadius.circular(10),
                )
            ),
            // new RichText(
            //   text: new TextSpan(
            //     children: <TextSpan>[
            //       new TextSpan(
            //         text: "Title: " + movie.title,
            //         style: new TextStyle(color: Colors.black),
            //       ),
            //     ],
            //   ),
            // ),
            // new RichText(
            //   text: new TextSpan(
            //     children: <TextSpan>[
            //       new TextSpan(
            //         text: "Director: " + movie.director,
            //         style: new TextStyle(color: Colors.black),
            //       ),
            //     ],
            //   ),
            // ),
            // new RichText(
            //   text: new TextSpan(
            //     children: <TextSpan>[
            //       new TextSpan(
            //         text: "Year: " + movie.year,
            //         style: new TextStyle(color: Colors.black),
            //       ),
            //     ],
            //   ),
            // ),
            new RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nTitle: " + movie.title,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              new RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nDirector: " + movie.director,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),

                    ),
                  ],
                ),
              ),
              new RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nYear: " + movie.year,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ),



        );
    }
  }

}

