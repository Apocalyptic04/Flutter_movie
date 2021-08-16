import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_movies/models/movie.dart';

import '../databaseHelper.dart';
import 'moviesWidget.dart';

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

  void handleClick(String value) {
    switch (value) {
      case 'Edit':
        break;
      case 'Settings':
        break;
    }
  }

  void _query() async {
    final _movie = await dbHelper.queryMovie(this.imdbId);
    setState(() {
      movie = _movie;
    });
  }

  void _delete(id) async {
    await dbHelper.delete(id);
  }

  void _edit(id) async {
    //await dbHelper.edit(id);
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
          actions: <Widget>[
            IconButton(icon: Icon(Icons.create), onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => editMovieWidget(imdbId : movie.imdbId, director: movie.director, poster: movie.poster, title: movie.title, year: movie.year)),
              );
            }),
            IconButton(icon: Icon(Icons.delete), onPressed: () {
               //print("Aakash Bhagat");
              _delete(movie.imdbId);
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => MoviesWidget()),
               );
               //return MoviesWidget();
            }),
          ],
        ),
        body: Align(
          alignment: Alignment(0, -0.4),
          //alignment: Alignment.topCenter,
          //alignment: Alignment(0, -1.7),
          child: Stack(
            children: [new SizedBox(
                height: 250,
                width: 150,
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

