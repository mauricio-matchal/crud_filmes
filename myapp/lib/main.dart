import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/film/film_list_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ProviderScope(child: MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromRGBO(48, 88, 231, 1),
        colorScheme: ColorScheme.dark(
          primary: Color.fromRGBO(255, 201, 47, 1),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(30, 30, 30, 1),
          elevation: 0,
        ),
        scaffoldBackgroundColor: Color.fromRGBO(30, 30, 30, 1),
      ), 
      home: AuthenticationWrapper(),
      )
    ),
  );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Main page')));
  }
}

class AuthenticationWrapper extends ConsumerWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);

    return authStateAsync.when(
      data: (user) {
        return user == null ? const SignInPage() : const FilmListPage();
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const Scaffold(body: Center(child: Text('Error'))),
    );
  }
}

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => ref.read(authProvider.notifier).signInWithGoogle(),
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
