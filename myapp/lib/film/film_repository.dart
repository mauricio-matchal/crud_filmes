import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/firestore_provider.dart';
import 'package:myapp/film/film.dart';

part 'film_repository.g.dart';

class FilmRepository {
  final FirebaseFirestore _firestore;

  FilmRepository(this._firestore);

  Future<Film?> findById(String id) async {
    final snapshot = await _firestore.collection('films').doc(id).get();
    if (!snapshot.exists) {
      return null;
    }
    return Film.fromDocument(snapshot);
  }

  Future<List<Film>> find() async {
    final snapshot = await _firestore.collection('films').get();
    return snapshot.docs.map((doc) => Film.fromDocument(doc)).toList();
  }

  Future<Film> insert(Film film) async {
    final filmData = film.toJson()..remove('id');
    final docRef = await _firestore.collection('films').add(filmData);
    return film.copyWith(id: docRef.id);
  }

  Future<void> update(String id, Film film) async {
    final filmData = film.toJson()..remove('id');
    await _firestore.collection('films').doc(film.id).update(filmData);
  }

  Future<void> delete(String id) async {
    await _firestore.collection('films').doc(id).delete();
  }
}

@riverpod
FilmRepository filmRepository(Ref ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return FilmRepository(firestore);
}
