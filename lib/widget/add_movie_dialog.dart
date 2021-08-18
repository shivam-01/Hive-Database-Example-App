import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/movie.dart';

class AddMovieDialog extends StatefulWidget {
  final Movie? movie;
  final Function(String name, String director, String posterPath) onClickedDone;

  const AddMovieDialog({
    Key? key,
    this.movie,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _AddMovieDialogState createState() => _AddMovieDialogState();
}

class _AddMovieDialogState extends State<AddMovieDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final directorController = TextEditingController();
  final posterPathController = TextEditingController();
  late File poster;

  @override
  void initState() {
    super.initState();

    if (widget.movie != null) {
      final movie = widget.movie!;

      nameController.text = movie.name;
      directorController.text = movie.director;
      poster = File(movie.posterPath);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    directorController.dispose();

    super.dispose();
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final tempImage = File(image.path);
      setState(() {
        poster = tempImage;
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.movie != null;
    final title = isEditing ? 'Edit Movie' : 'Add Movie';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildDirector(),
              SizedBox(height: 8),
              buildMoviePosterButton(),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Movie Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a movie name' : null,
      );

  Widget buildDirector() => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Movie Director',
        ),
        validator: (director) => director != null && director.isEmpty
            ? 'Enter a director name'
            : null,
        controller: directorController,
      );

  Widget buildMoviePosterButton() => ElevatedButton(
      onPressed: pickImage,
      child: Row(
        children: [
          Icon(Icons.image),
          const SizedBox(width: 10),
          Text('Add Movie Poster'),
        ],
      ));

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          final director = directorController.text;
          final posterPath = poster.path;

          widget.onClickedDone(name, director, posterPath);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
