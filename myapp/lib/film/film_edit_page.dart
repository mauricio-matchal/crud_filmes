import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/film/film.dart';
import 'package:myapp/film/film_edit_viewmodel.dart';

class FilmEditPage extends ConsumerStatefulWidget {
  final String? filmId;
  const FilmEditPage({super.key, required this.filmId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FilmEditPageState();
}

class _FilmEditPageState extends ConsumerState<FilmEditPage> {
  get isNewFilm => widget.filmId == null;
  Film? film;
  late final TextEditingController _titleController;
  late final TextEditingController _directorController;
  late final TextEditingController _reviewController;
  late final TextEditingController _starsController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _directorController = TextEditingController();
    _reviewController = TextEditingController();
    _starsController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _directorController.dispose();
    _reviewController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filmAsync = ref.watch(filmEditViewModelProvider(widget.filmId));

    if (film == null && filmAsync.hasValue) {
      film = filmAsync.value!.copyWith();
      _titleController.text = film!.title;
      _directorController.text = film!.director;
      _reviewController.text = film!.review ?? '';
      _starsController.text = film!.stars?.toString() ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${isNewFilm ? "Log" : "Edit"} entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: filmAsync.when(
          data: (originalFilm) => _buildForm(context),
          error: (error, stackTrace) => Text('Error: $error'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              autofocus: true,
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Film title',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Color.fromRGBO(244, 244, 244, 0.6)),
              ),
              onChanged: (value) {
                film = film!.copyWith(title: value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _directorController,
              decoration: const InputDecoration(
                labelText: 'Director',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Color.fromRGBO(244, 244, 244, 0.6)),
              ),
              onChanged: (value) {
                film = film!.copyWith(director: value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a director';
                }
                return null;
              },
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Your thoughts on the film...',
                alignLabelWithHint: true,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                hintMaxLines: 4,
                labelStyle: TextStyle(color: Color.fromRGBO(244, 244, 244, 0.6)),
              ),
              textAlignVertical: TextAlignVertical.top,
              onChanged: (value) {
                film = film!.copyWith(review: value);
              },
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              controller: _starsController,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'Stars',
                alignLabelWithHint: true,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                hintMaxLines: 4,
                labelStyle: TextStyle(color: Color.fromRGBO(244, 244, 244, 0.6)),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d?\.?\d{0,1}')),
              ] ,
              textAlignVertical: TextAlignVertical.top,
              onChanged: (value) {
                final parsedValue = double.tryParse(value) ?? 0.0;
                film = film!.copyWith(stars: parsedValue.clamp(0.0, 5.0));
              },
            ),
            const SizedBox(height: 16),
            _buildButtonBar(ref, context),
          ],
        ),
      ),
    );
  }

  Row _buildButtonBar(WidgetRef ref, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _save,
          style: ButtonStyle(foregroundColor: WidgetStateProperty.all<Color>(Color.fromRGBO(244, 244, 244, 1))),
          child: Text(isNewFilm ? 'Create' : 'Save'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            style: ButtonStyle(foregroundColor: WidgetStateProperty.all<Color>(Color.fromRGBO(244, 244, 244, 1))),
            child: const Text('Cancel')),
      ],
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final notifier =
        ref.read(filmEditViewModelProvider(widget.filmId).notifier);
    await notifier.updateState(film!);
    await notifier.save();
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }
}