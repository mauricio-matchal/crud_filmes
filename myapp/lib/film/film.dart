import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'film.freezed.dart';
part 'film.g.dart';

@freezed
sealed class Film with _$Film {
  const factory Film({
    String? id,
    required String title,
    required String director,
    double? stars,
    String? review,
  }) = _Film;

  factory Film.empty() => const Film(
        id: null,
        title: '',
        director: '',
        stars: null,
        review: '',
      );

  factory Film.fromJson(Map<String, dynamic> json) => _$FilmFromJson(json);

  factory Film.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Film.fromJson(data).copyWith(id: doc.id);
  }
}
