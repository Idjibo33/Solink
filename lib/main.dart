import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:so_link/app.dart';
import 'package:so_link/core/di/app_dependencies.dart';
import 'package:so_link/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final dependencies = await AppDependencies.create();
  runApp(SolinkApp(dependencies: dependencies));
}
