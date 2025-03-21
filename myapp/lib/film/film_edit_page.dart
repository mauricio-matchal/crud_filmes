import 'package:flutter/material.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filmAsync = ref.watch(filmEditViewModelProvider(widget.filmId));

    if (film == null && filmAsync.hasValue) {
      film = filmAsync.value!.copyWith();
      _titleController.text = film!.title;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${isNewFilm ? "New" : "Edit"} Film'),
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
            CheckboxListTile(
              title: const Text('Is completed'),
              value: film!.isCompleted,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  film = film!.copyWith(isCompleted: value!);
                });
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
          child: Text(isNewFilm ? 'Create' : 'Save'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
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
