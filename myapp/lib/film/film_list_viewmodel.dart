import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:myapp/film/film.dart';
import 'package:myapp/film/film_repository.dart';

part 'film_list_viewmodel.g.dart';

@riverpod
class FilmListViewModel extends _$FilmListViewModel {
  @override
  Future<List<Film>> build() async {
    return ref.watch(filmRepositoryProvider).find();
  }

  Future<void> delete(Film film) async {
    state = const AsyncValue.loading();
    await ref.read(filmRepositoryProvider).delete(film.id!);
    ref.invalidateSelf();
  }
}
