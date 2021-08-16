

import 'package:flutter/material.dart';
import 'package:hello_movies/models/movie.dart';
import 'package:hello_movies/databaseHelper.dart';
import 'MovieDetailsWidget.dart';
import 'dart:math';

import '../login_page.dart';
import '../sign_in.dart';
class MoviesWidget extends StatefulWidget {
  @override
  _MoviesWidget createState() => _MoviesWidget();
}


class _MoviesWidget extends State<MoviesWidget> {
    List<Movie> movies;
    final dbHelper = DatabaseHelper.instance;

    void _query() async {
      final _movies = await dbHelper.queryAllRows();
      setState(() {
        movies = _movies;
      });
    }

    @override
    initState() {
      super.initState();
      _query();
    }

    @override
    Widget build(BuildContext context) {
      if (movies == null) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text("Loading..."),
          ),
        );
      }  else {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text("Movies"),
            actions: <Widget> [
              SizedBox(
              width: 100.0,
              height: 8.0,
                child: ElevatedButton(
                    child: Text('Logout'),
                    onPressed: (){signOutGoogle();
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginPage();}), ModalRoute.withName('/'));
                    },
                ),
              ),
            ],
          ),
          body: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];

                  return ListTile(
                      title: Row(children: [
                        SizedBox(
                            height: 200,
                            width: 115,
                            child: ClipRRect(
                              child: Image.network(movie.poster),
                              borderRadius: BorderRadius.circular(10),
                            )

                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(movie.title),
                              ],),
                          ),
                        )
                      ],),
                      onTap: () => {  Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                                return MovieDetailsWidget(imdbId : movie.imdbId);
                                            },
                                          ),
                                    )}
                  );
                }
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            )

        );
    }
  }

}

class SecondRoute2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Movie"),
      ),
      body: Align(
        alignment: Alignment(0.9, 0.9),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Submit'),
        ),
      ),
    );
  }

}

class editMovieWidget extends StatelessWidget {

  final String imdbId;
  final String poster;
  final String director;
  final String year;
  final String title;

  editMovieWidget({this.imdbId,this.director,this.poster,this.title,this.year});

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Edit Movie';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyEditForm(imdbId : this.imdbId, director: this.director, poster: this.poster, title: this.title, year: this.year),
      ),
    );
  }

}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Add Movie';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

class MyEditForm extends StatefulWidget {

  final String imdbId;
  final String poster;
  final String director;
  final String year;
  final String title;

  const MyEditForm({Key key, this.imdbId, this.poster, this.director, this.title, this.year}) : super(key: key);

  @override
  MyEditFormState createState() {
    return MyEditFormState(imdbId : this.imdbId, director: this.director, poster: this.poster, title: this.title, year: this.year);
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyEditFormState extends State<MyEditForm> {

  final String imdbId;
  final String poster;
  final String director;
  final String year;
  final String title;
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();


  MyEditFormState({this.imdbId, this.poster, this.director, this.title, this.year});

  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   movieNameController.dispose();
  //   super.dispose();
  // }
  //
  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   directorNameController.dispose();
  //   super.dispose();
  // }
  //
  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   yearController.dispose();
  //   super.dispose();
  // }
  //
  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   imageController.dispose();
  //   super.dispose();
  // }


  @override
  Widget build(BuildContext context) {


    // Build a Form widget using the _formKey created above.
    final dbHelper = DatabaseHelper.instance;
    TextEditingController movieNameController = TextEditingController(text: this.title);
    TextEditingController directorNameController = TextEditingController(text: this.director);
    TextEditingController yearController = TextEditingController(text: this.year);
    TextEditingController imageController = TextEditingController(text: this.poster);

    void _edit(imdb,title,poster,director,year) async {
      Map<String, dynamic> data =
      {
        '_imdbId': imdb,
        'title': title,
        'year': year,
        'poster' : poster,
        'director' : director,
      };
      await dbHelper.insert(data);
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: movieNameController,
            //initialValue: this.title,
            decoration: const InputDecoration(
              //icon: const Icon(Icons.person),
              hintText: 'Enter movie title',
              labelText: "Movie Title",
            ),
          ),
          TextFormField(
            controller: directorNameController,
            //initialValue: this.director,
            decoration: const InputDecoration(
              //icon: const Icon(Icons.phone),
              hintText: 'Enter movie director name',
              labelText: "Director",
            ),
          ),
          TextFormField(
            controller: yearController,
            //initialValue: this.year,
            decoration: const InputDecoration(
              //icon: const Icon(Icons.calendar_today),
              hintText: 'Enter Movie Year',
              labelText: "Year",
            ),
          ),
          TextFormField(
            controller: imageController,
            //initialValue: this.poster,
            decoration: const InputDecoration(
              //icon: const Icon(Icons.calendar_today),
              hintText: 'Enter Image URL',
              labelText: "Poster Link",
            ),
          ),
          new Container(
              padding: const EdgeInsets.only(left: 150.0, top: 40.0),
              child: new ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  _edit(this.imdbId,movieNameController.text, imageController.text, directorNameController.text, yearController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MoviesWidget()),
                  );
                },
              )),
        ],
      ),
    );
  }
}

// Create a corresponding State class. This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  TextEditingController movieNameController = TextEditingController();
  TextEditingController directorNameController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   movieNameController.dispose();
  //   super.dispose();
  // }
  //
  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   directorNameController.dispose();
  //   super.dispose();
  // }
  //
  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   yearController.dispose();
  //   super.dispose();
  // }
  //
  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   imageController.dispose();
  //   super.dispose();
  // }


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    final dbHelper = DatabaseHelper.instance;
    void _insert(title,poster,director,year) async {
      Random random = new Random();
      String randomNumber = random.nextInt(100).toString();
      Map<String, dynamic> data =
      {
        '_imdbId': randomNumber,
        'title': title,
        'year': year,
        'poster' : poster,
        'director' : director,
      };
       await dbHelper.insert(data);
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: movieNameController,
            decoration: const InputDecoration(
              //icon: const Icon(Icons.person),
              hintText: 'Enter movie title',
              labelText: 'Movie',
            ),
          ),
          TextFormField(
            controller: directorNameController,
            decoration: const InputDecoration(
              //icon: const Icon(Icons.phone),
              hintText: 'Enter movie director name',
              labelText: 'Director',
            ),
          ),
          TextFormField(
            controller: yearController,
            decoration: const InputDecoration(
              //icon: const Icon(Icons.calendar_today),
              hintText: 'Enter Movie Year',
              labelText: 'Year',
            ),
          ),
          TextFormField(
            controller: imageController,
            decoration: const InputDecoration(
              //icon: const Icon(Icons.calendar_today),
              hintText: 'Enter Image URL',
              labelText: 'Poster',
            ),
          ),
          new Container(
              padding: const EdgeInsets.only(left: 150.0, top: 40.0),
              child: new ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  _insert(movieNameController.text, imageController.text, directorNameController.text, yearController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MoviesWidget()),
                  );
                },
              )),
        ],
      ),
    );
  }
}