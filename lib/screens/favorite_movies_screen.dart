import 'package:flutter/material.dart';
import 'package:moviesearch_tmdb_template/providers/movie_provider.dart';
import 'package:moviesearch_tmdb_template/screens/movie_detail_screen.dart';
import 'package:provider/provider.dart';

class FavoriteMoviesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Movies'),
      ),
      body: movieProvider.favorites.isEmpty
          ? Center(child: Text('No favorite movies'))
          : ListView.builder(
              itemCount: movieProvider.favorites.length,
              itemBuilder: (context, index) {
                final movie = movieProvider.favorites[index];
                return ListTile(
                  leading: movie.posterPath.isNotEmpty
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey,
                          child: Icon(Icons.movie),
                        ),
                  title: Text(movie.title),
                  subtitle: Text(movie.releaseDate),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  ),
                );
              },
            ),
    );
  }
}