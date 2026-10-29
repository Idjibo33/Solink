import 'package:flutter/material.dart';
import 'package:so_link/app.dart';
import 'package:so_link/core/di/app_dependencies.dart';
import 'package:so_link/core/di/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebaseApp();
  final dependencies = await AppDependencies.create();
  runApp(SolinkApp(dependencies: dependencies));
}
