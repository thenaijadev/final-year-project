import 'package:minimalist_social_app/core/exports/bloc_provider_exports.dart';

final List<BlocProvider> blocProviders = [
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
            authService:
                LocalAuthServiceImplementation(auth: LocalAuthentication())),
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
      create: (context) => AiBloc(repo: AiRepository(provider: AiProvider())))
];
