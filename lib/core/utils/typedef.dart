import 'package:dartz/dartz.dart';
import 'package:local_auth/local_auth.dart';
import 'package:minimalist_social_app/core/errors/ai_error.dart';
import 'package:minimalist_social_app/core/errors/article_error.dart';
import 'package:minimalist_social_app/core/errors/auth_error.dart';
import 'package:minimalist_social_app/core/errors/local_auth_error.dart';
import 'package:minimalist_social_app/core/errors/user_error.dart';
import 'package:minimalist_social_app/features/AI/data/models/ai_response_model.dart';
import 'package:minimalist_social_app/features/auth/data/models/auth_user_model.dart';
import 'package:minimalist_social_app/features/users/data/models/user_model.dart';

//----------------------------------Auth-----------------------------
typedef EitherAuthUserOrAuthError = Either<AuthError, AuthUserModel>;
typedef EitherTrueOrAuthError = Either<AuthError, bool>;

typedef EitherFutureTrueOrAuthError = Future<Either<AuthError, bool>>;

typedef FutureEitherAuthUserOrAuthError
    = Future<Either<AuthError, AuthUserModel>>;

typedef FutureEitherLocalAuthUserOrAuthError
    = Future<Either<AuthError, AuthUserModel>>;

//-------------------------USER-------------------------------------------------
typedef EitherFutureTrueOrUserError = Future<Either<UserError, bool>>;
typedef FutureEitherLocalUserOrUserError = Future<Either<UserError, UserModel>>;
typedef FutureEitherUserOrUserError = Future<Either<UserError, UserModel>>;
typedef EitherTrueOrUserError = Future<Either<UserError, bool>>;
typedef EitherUserOrUserError = Either<UserError, UserModel>;

//-----------------------Local Auth -------------------------------------------

typedef EitherBoolOrLocalAuthError = Future<Either<LocalAuthError, bool>>;

typedef EitherListOfBiometricsOrLocalAuthError
    = Future<Either<LocalAuthError, List<BiometricType>>>;

//-----------------------News---------------------------------------------------

// typedef FutureEitherArticleOrException = Future<Either<ArticleError, Article>>;

// typedef EitherArticleOrException = Either<ArticleError, Article>;

typedef EithertrueOrLocalDataSourceError = Future<Either<ArticleError, bool>>;

typedef EitherArticleModelOrLocalDataSourceError
    = Future<Either<ArticleError, Map<String, dynamic>>>;

//--------------------------------AI______________________

typedef FutureEitherStringOrAIError = Future<Either<AIError, AiResponse>>;
