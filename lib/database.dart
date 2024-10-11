import 'package:firebase_database/firebase_database.dart';

class DatabaseHelper {
  final DatabaseReference _moviesRef = FirebaseDatabase.instance.ref().child('movies');

  // Insert movie into Firebase
  Future<void> insertMovie(Map<String, dynamic> movie) async {
    await _moviesRef.push().set(movie);
  }

  // Fetch movies from Firebase
  Future<List<Map<String, dynamic>>> getMovies() async {
    final snapshot = await _moviesRef.get();
    if (snapshot.exists) {
      Map<dynamic, dynamic> moviesMap = snapshot.value as Map<dynamic, dynamic>;
      List<Map<String, dynamic>> moviesList = moviesMap.entries.map((entry) {
        final movie = Map<String, dynamic>.from(entry.value as Map);
        movie['id'] = entry.key;  // Add Firebase key as 'id'
        return movie;
      }).toList();
      return moviesList;
    } else {
      return [];
    }
  }

  // Delete movie from Firebase
  Future<void> deleteMovie(String movieId) async {
    await _moviesRef.child(movieId).remove();
  }
}
