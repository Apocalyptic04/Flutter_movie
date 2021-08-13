import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_movies/models/movie.dart';
import 'package:hello_movies/widgets/moviesWidget.dart';
import 'package:http/http.dart' as http;

import 'databaseHelper.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override 
  _App createState() => _App(); 
}

class _App extends State<App> {

  List<Movie> _movies = new List<Movie>();
  final dbHelper = DatabaseHelper.instance;
  @override
  void initState() {
    super.initState();
    _query();
  }

  void _query() async {
    final movies = await dbHelper.queryAllRows();
    setState(() {
      _movies = movies;
    });
  }

  /*Future<List<Movie>> _fetchAllMovies() async {
    final response = await http.get("http://www.omdbapi.com/?s=Batman&page=2&apikey=564727fa");
    if(response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["Search"];
      return list.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception("Failed to load movies!");
    }

  }*/

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Movies App",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Movies")
        ),
        body: MoviesWidget(movies: _movies)
      )
    );
    
  }
}
