import 'package:flutter/material.dart';
import 'package:minimalist_social_app/config/router/app_router.dart';
import 'package:minimalist_social_app/config/router/routes.dart';
import 'package:minimalist_social_app/config/theme/dark_theme.dart';
import 'package:minimalist_social_app/config/theme/light_theme.dart';
import 'package:minimalist_social_app/core/exports/bloc_provider_exports.dart';

class MyMultiBlocProvider extends StatefulWidget {
  const MyMultiBlocProvider({super.key, required this.appRouter});
  final AppRouter appRouter;
  @override
  State<MyMultiBlocProvider> createState() => _MyMultiBlocProviderState();
}

class _MyMultiBlocProviderState extends State<MyMultiBlocProvider> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DarkModeBloc(),
        ),
        BlocProvider(
          create: (context) => TextRecognitionBloc(
              repo: MlKitRepository(mlKitProvider: MlKitProvider())),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            authUsecase: AuthUsecase(
              localAuthRepository: LocalAuthRepositoryImplementation(
                  authService: LocalAuthServiceImplementation(
                      auth: LocalAuthentication())),
              authRepository: FirebaseAuthRepositoryImplementation(
                networkInfo: NetworkInfoImpl(
                  connectionChecker: DataConnectionChecker(),
                ),
                authService: FirebaseAuthServiceImlementation(),
                localAuthUserSource: AuthUserLocalDataSourceImpl(
                  sharedPreferences: SharedPreferences.getInstance(),
                ),
              ),
            ),
          ),
        ),
        BlocProvider<DailyNewsBloc>(
          create: (context) => DailyNewsBloc(
            GetArticleUseCase(
              articleRepository: ArticleRepositoryImplementation(
                newsApiService: NewsApiServiceImplementation(),
                localDataSource: ArticlesLocalDataSourceImpl(
                  sharedPreferences: SharedPreferences.getInstance(),
                ),
                networkInfo: NetworkInfoImpl(
                  connectionChecker: DataConnectionChecker(),
                ),
              ),
            ),
          )..add(GetArticlesEvent()),
        ),
        BlocProvider(
            create: (context) =>
                AiBloc(repo: AiRepository(provider: AiProvider())))
      ],
      child: BlocBuilder<DarkModeBloc, DarkModeState>(
        builder: (context, state) {
          if (state is DarkModeCurrentState) {
            return MaterialApp(
              theme: state.isDark ? darkTheme() : lightTheme(),
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              initialRoute: Routes.landing,
              onGenerateRoute: widget.appRouter.onGenerateRoute,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
