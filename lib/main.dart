import 'upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const AvatarAIApp());
}

class AvatarAIApp extends StatelessWidget {
  const AvatarAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AvatarAI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser == null ? const AuthScreen() : const UploadScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AvatarAI')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(radius: 50, backgroundColor: Colors.grey),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Upload Image'),
            ),
            const SizedBox(height: 20),
            const Text('Choose a style:'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Anime')),
                ElevatedButton(onPressed: () {}, child: const Text('Cyberpunk')),
                ElevatedButton(onPressed: () {}, child: const Text('Cartoon')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
