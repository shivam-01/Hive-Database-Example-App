import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_database_example/model/movie.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_database_example/page/movie_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>('movieBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Movie DB App';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData.dark(),
        home: MoviePage(),
      );
}
