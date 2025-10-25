import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_architecture/riverpod_architecture.dart';

import 'package:example/screens/home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
      onGlobalFailure: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.title),
            backgroundColor: Colors.red,
          ),
        );
      },
      onGlobalInfo: (info) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(info.message),
            backgroundColor: info.globalInfoStatus == GlobalInfoStatus.success
                ? Colors.green
                : Colors.blue,
          ),
        );
      },
      child: MaterialApp(
        title: 'Riverpod Architecture Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
