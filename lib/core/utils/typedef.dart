import 'package:dartz/dartz.dart';
import 'package:minimalist_social_app/core/errors/auth_error.dart';
import 'package:minimalist_social_app/core/errors/user_error.dart';

import 'package:minimalist_social_app/features/auth/data/models/auth_user_model.dart';

// typedef FutureEitherArticleOrException
//     = Future<Either<ArticleError, NewsArticlesEntity>>;

// typedef EitherArticleOrException = Either<ArticleError, NewsArticlesEntity>;

typedef EitherAuthUserOrAuthError = Either<AuthError, AuthUserModel>;
typedef EitherTrueOrAuthError = Either<AuthError, bool>;
typedef EitherTrueOrUserError = Future<Either<UserError, bool>>;

typedef EitherFutureTrueOrAuthError = Future<Either<AuthError, bool>>;

typedef FutureEitherAuthUserOrAuthError
    = Future<Either<AuthError, AuthUserModel>>;

typedef FutureEitherLocalAuthUserOrAuthError
    = Future<Either<AuthError, AuthUserModel>>;
