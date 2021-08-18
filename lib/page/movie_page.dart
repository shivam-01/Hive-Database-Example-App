import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_database_example/boxes.dart';
import 'package:hive_database_example/model/movie.dart';
import 'package:hive_database_example/widget/add_movie_dialog.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({Key? key}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Movie DB App'),
          centerTitle: true,
        ),
        body: ValueListenableBuilder<Box<Movie>>(
          valueListenable: Boxes.getMovies().listenable(),
          builder: (context, box, _) {
            final movies = box.values.toList().cast<Movie>();

            return buildContent(movies);
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AddMovieDialog(
              onClickedDone: addMovie,
            ),
          ),
        ),
      );

  Widget buildContent(List<Movie> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Text(
          'No movies yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                final movie = movies[index];

                return buildMovie(context, movie);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildMovie(
    BuildContext context,
    Movie movie,
  ) {
    return Card(
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        leading: Image.file(File(movie.posterPath)),
        title: Text(
          movie.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          movie.director,
        ),
        children: [
          buildButtons(context, movie),
        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context, Movie movie) => Row(
        children: [
          Expanded(
            child: TextButton.icon(
              label: Text('Edit'),
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddMovieDialog(
                    movie: movie,
                    onClickedDone: (name, director, poster) =>
                        updateMovie(movie, name, director, poster),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              label: Text('Delete'),
              icon: Icon(Icons.delete),
              onPressed: () => deleteMovie(movie),
            ),
          )
        ],
      );

  Future addMovie(String name, String director, String posterPath) async {
    final movie = Movie()
      ..name = name
      ..director = director
      ..posterPath = posterPath;

    final box = Boxes.getMovies();
    box.add(movie);
  }

  void updateMovie(
    Movie movie,
    String name,
    String director,
    String posterPath,
  ) {
    movie.name = name;
    movie.director = director;
    movie.posterPath = posterPath;

    movie.save();
  }

  void deleteMovie(Movie movie) {
    movie.delete();
  }
}
