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
      appBar: AppBar(
        title: const Text('Film List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FilmEditPage(
                filmId: null,
              ),
            ),
          );
          if (saved == true) {
            _onUpdate(ref);
          }
        },
        child: const Icon(Icons.add),
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
          children: [
            Text('Error: $error'),
            Text('Stack trace: $stackTrace'),
          ],
        ),
      );

  Widget? _buildFilmList(WidgetRef ref, List<Film> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text('No films found'),
      );
    } else {
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          Film film = list[index];
          return ListTile(
            title: Text(film.title),
            subtitle: Text(film.isCompleted ? 'Completed' : 'Not completed'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // create dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Film'),
                    content: const Text('Are you sure?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ref
                              .read(filmListViewModelProvider.notifier)
                              .delete(film);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
            onTap: () async {
              final saved = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FilmEditPage(filmId: film.id),
                ),
              );
              if (saved == true) {
                _onUpdate(ref);
              }
            },
          );
        },
      );
    }
  }
}
