import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimalist_social_app/config/bloc_config/bloc_config.dart';
import 'package:minimalist_social_app/config/router/app_router.dart';
import 'package:minimalist_social_app/config/router/routes.dart';
import 'package:minimalist_social_app/config/theme/dark_theme.dart';
import 'package:minimalist_social_app/config/theme/light_theme.dart';
import 'package:minimalist_social_app/features/dark_mode/presentation/bloc/dark_mode_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MultiBlocProvider(
        providers: blocProviders,
        child: BlocBuilder<DarkModeBloc, DarkModeState>(
          builder: (context, state) {
            if (state is DarkModeCurrentState) {
              return MaterialApp(
                theme: state.isDark ? darkTheme() : lightTheme(),
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                initialRoute: Routes.landing,
                onGenerateRoute: appRouter.onGenerateRoute,
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
