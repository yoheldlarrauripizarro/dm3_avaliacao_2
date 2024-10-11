import 'package:flutter/material.dart';
import 'database.dart';
import 'add_movie_screen.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<Map<String, dynamic>> _movies = [];

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  // Fetch movies from Firebase
  Future<void> _fetchMovies() async {
    final movies = await DatabaseHelper().getMovies();
    setState(() {
      _movies = movies;
    });
  }

  // Function to generate star icons based on the rating
  Widget _buildRatingStars(int? rating) {
    int effectiveRating = rating ?? 0; // Use 0 stars if rating is null

    List<Widget> stars = [];
    for (int i = 0; i < 10; i++) {
      if (i < effectiveRating) {
        stars.add(Icon(Icons.star, color: Colors.yellow));
      } else {
        stars.add(Icon(Icons.star_border, color: Colors.yellow));
      }
    }
    return Row(
      children: stars,
      mainAxisSize: MainAxisSize.min, // So that stars don't stretch horizontally
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movie List')),
      body: _movies.isEmpty
          ? Center(child: Text('No movies added yet'))
          : ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                _movies[index]['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRatingStars(_movies[index]['rating']),
                  Text('Description: ${_movies[index]['description']}'),
                  Text('Date: ${_movies[index]['date']}', style: TextStyle(color: Colors.grey)),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: _movies[index], movieId: _movies[index]['id']),
                  ),
                ).then((_) => _fetchMovies());
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMovieScreen()),
          ).then((_) => _fetchMovies());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
