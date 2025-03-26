import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/film/film_edit_page.dart';
import 'package:myapp/film/film_list_viewmodel.dart';
import 'package:myapp/film/film.dart';

class FilmListPage extends ConsumerWidget {
  const FilmListPage({super.key});

  void _onUpdate(WidgetRef ref) {
    ref.invalidate(filmListViewModelProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filmList = ref.watch(filmListViewModelProvider);
    return Scaffold(
      // backgroundColor: Color.fromRGBO(30, 30, 30, 1),
      appBar: AppBar(
        toolbarHeight: 140.0, //
        title: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Text('@mauriciomatchal'),
        ), //
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
        titleTextStyle: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w900),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(153, 48, 88, 231),
              blurRadius: 80,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final saved = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const FilmEditPage(filmId: null),
              ),
            );
            if (saved == true) {
              _onUpdate(ref);
            }
          },

          icon: Icon(Icons.add), // Add an icon
          label: Text(
            "Adicionar",
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
          ), // Add text
          backgroundColor: Color.fromARGB(
            255,
            18,
            19,
            22,
          ), // Set background color
          foregroundColor: Color.fromARGB(
            255,
            255,
            255,
            255,
          ), // Set text/icon color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              30,
            ), // Pill-shaped border radius
          ),
        ),
      ),
      body: Center(
        child: filmList.when(
          data: (list) => _buildFilmList(ref, list),
          error: _buildError,
          loading: () => const CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget? _buildError(error, stackTrace) => Center(
    child: Column(
      children: [Text('Error: $error'), Text('Stack trace: $stackTrace')],
    ),
  );

  Widget? _buildFilmList(WidgetRef ref, List<Film> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No films found'));
    } else {
      return GridView.count(
        crossAxisCount: 4,
        childAspectRatio: 0.45,
        children: List.generate(list.length, (index) {
          Film film = list[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                    // child: Image.network(
                    //   // film.posterUrl,
                    //   // fit: BoxFit.cover,
                    // ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        film.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        film.director,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(film.stars?.toStringAsFixed(1) ?? 'S'),
                          SizedBox(width: 2),
                          Text(film.review != '' ? 'R' : 'N'),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      );
          // return ListTile(
          //   title: Text(film.title),
          //   subtitle: Text(film.isCompleted ? 'Completed' : 'Not completed'),
          //   trailing: IconButton(
          //     icon: const Icon(Icons.delete),
          //     onPressed: () {
          //       // create dialog
          //       showDialog(
          //         context: context,
          //         builder:
          //             (context) => AlertDialog(
          //               title: const Text('Delete Film'),
          //               content: const Text('Are you sure?'),
          //               actions: [
          //                 TextButton(
          //                   onPressed: () {
          //                     Navigator.of(context).pop();
          //                   },
          //                   child: const Text('Cancel'),
          //                 ),
          //                 TextButton(
          //                   onPressed: () {
          //                     Navigator.of(context).pop();
          //                     ref
          //                         .read(filmListViewModelProvider.notifier)
          //                         .delete(film);
          //                   },
          //                   child: const Text('Delete'),
          //                 ),
          //               ],
          //             ),
          //       );
          //     },
          //   ),
          //   onTap: () async {
          //     final saved = await Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => FilmEditPage(filmId: film.id),
          //       ),
          //     );
          //     if (saved == true) {
          //       _onUpdate(ref);
          //     }
          //   },
          // );
    }
  }
}

class MovieCard extends StatelessWidget {
  final Film film;
  
  const MovieCard({Key? key, required this.film}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              // child: Image.network(
              //   // film.posterUrl,
              //   // fit: BoxFit.cover,
              // ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  film.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  film.director,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}