import 'package:hive/hive.dart';
import 'package:hive_database_example/model/movie.dart';

class Boxes {
  static Box<Movie> getMovies() =>
      Hive.box<Movie>('movieBox');
}
