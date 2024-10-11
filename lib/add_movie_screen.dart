import 'package:flutter/material.dart';
import 'database.dart';

class AddMovieScreen extends StatefulWidget {
  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _releaseYearController = TextEditingController();

  void _addMovie() {
    final String name = _nameController.text;
    final String category = _categoryController.text;
    final String description = _descriptionController.text;
    final int rating = int.tryParse(_ratingController.text) ?? -1;
    final int releaseYear = int.tryParse(_releaseYearController.text) ?? -1;

    final int currentYear = DateTime.now().year;

    if (releaseYear > currentYear) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Release year cannot be greater than $currentYear')),
      );
      return;
    }

    if (rating < 0 || rating > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rating must be between 0 and 10')),
      );
      return;
    }

    // Add movie to Firebase
    DatabaseHelper().insertMovie({
      'name': name,
      'category': category,
      'description': description,
      'rating': rating,
      'release_year': releaseYear,
      'date': DateTime.now().toIso8601String(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Movie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _ratingController,
              decoration: InputDecoration(labelText: 'Rating (0-10)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _releaseYearController,
              decoration: InputDecoration(labelText: 'Release Year'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addMovie,
              child: Text('Add Movie'),
            ),
          ],
        ),
      ),
    );
  }
}
