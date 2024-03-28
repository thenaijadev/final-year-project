import 'package:flutter/material.dart';
import 'package:minimalist_social_app/config/bloc_config/bloc_config.dart';
import 'package:minimalist_social_app/config/router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MyMultiBlocProvider(appRouter: appRouter));
  }
}
