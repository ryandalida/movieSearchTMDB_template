import 'package:flutter/material.dart';
import 'package:moviesearch_tmdb_template/providers/movie_provider.dart';
import 'package:moviesearch_tmdb_template/screens/movie_detail_screen.dart';
import 'package:moviesearch_tmdb_template/screens/favorite_movies_screen.dart';
import 'package:provider/provider.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    final provider = Provider.of<MovieProvider>(context, listen: false);
    provider.searchMovies(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('TheMovieDB.org Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteMoviesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    movieProvider.fetchMovies();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: movieProvider.fetchMovies,
              child: movieProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : movieProvider.errorMessage.isNotEmpty
                      ? Center(child: Text(movieProvider.errorMessage))
                      : movieProvider.movies.isEmpty
                          ? Center(child: Text('No movies found'))
                          : ListView.builder(
                              itemCount: movieProvider.movies.length,
                              itemBuilder: (context, index) {
                                final movie = movieProvider.movies[index];
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
                                      builder: (context) =>
                                          MovieDetailScreen(movie: movie),
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }
}