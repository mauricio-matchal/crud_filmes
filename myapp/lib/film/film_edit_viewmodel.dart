import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:myapp/film/film.dart';
import 'package:myapp/film/film_repository.dart';

part 'film_edit_viewmodel.g.dart';

@riverpod
class FilmEditViewModel extends _$FilmEditViewModel {
  @override
  Future<Film> build(String? filmId) async {
    if (filmId == null) {
      return Future.value(Film.empty());
    } else {
      final film = await ref.read(filmRepositoryProvider).findById(filmId);
      if (film == null) {
        throw Exception('Film not found');
      }
      return film;
    }
  }

  Future<void> updateState(Film film) async {
    state = AsyncValue.data(film);
  }

  Future<void> save() async {
    state = const AsyncValue.loading();

    Film film = await future;
    final filmRepository = ref.read(filmRepositoryProvider);
    if (film.id == null) {
      film = await filmRepository.insert(film);
    } else {
      await filmRepository.update(film.id!, film);
    }
    state = await AsyncValue.guard(() => Future.value(film));
  }
}
