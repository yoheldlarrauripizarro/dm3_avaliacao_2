import 'package:flutter/material.dart';
import 'database.dart';

class MovieDetailScreen extends StatelessWidget {
  final Map<String, dynamic> movie;
  final String movieId;  // Firebase key for the movie

  MovieDetailScreen({required this.movie, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie['name'])),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Category: ${movie['category']}', style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text('Description: ${movie['description']}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Rating: ${movie['rating']}', style: TextStyle(fontSize: 20)),
              SizedBox(height: 10),
              Text('Release Year: ${movie['release_year']}', style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  DatabaseHelper().deleteMovie(movieId);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Movie deleted')),
                  );
                },
                child: Text('Delete Movie'),
                style: ElevatedButton.styleFrom(primary: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
