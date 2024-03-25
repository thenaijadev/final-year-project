import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minimalist_social_app/core/errors/auth_error.dart';
import 'package:minimalist_social_app/core/utils/typedef.dart';
import 'package:minimalist_social_app/features/auth/data/models/auth_user_model.dart';

abstract class FirebaseAuthService {
  EitherAuthUserOrAuthError getCurrentUser();

  FutureEitherAuthUserOrAuthError createUser(
      {required String email,
      required String password,
      required String userName});

  FutureEitherAuthUserOrAuthError logIn({
    required String email,
    required String password,
  });

  EitherFutureTrueOrAuthError logOut();
  EitherFutureTrueOrAuthError sendEmailVerification();
  EitherFutureTrueOrAuthError sendPasswordReset({required String toEmail});
}

class FirebaseAuthServiceImlementation implements FirebaseAuthService {
  EitherAuthUserOrAuthError get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    (user.toString());
    if (user != null) {
      return right(AuthUserModel.fromFirebase(
        user,
      ));
    } else {
      return left(AuthError(message: "There is no current user"));
    }
  }

  @override
  FutureEitherAuthUserOrAuthError createUser(
      {required String email,
      required String password,
      required String userName}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;

      return user.fold(
          (l) => left(
                AuthError(message: 'User is not logged in.'),
              ),
          (r) => user);
    } on FirebaseAuthException catch (e) {
      return left(AuthError(message: e.code));
    } catch (e) {
      return left(AuthError(message: e.toString()));
    }
  }

  @override
  FutureEitherAuthUserOrAuthError logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;

      return user.fold(
          (l) => left(
                AuthError(message: 'User is not logged in.'),
              ),
          (r) => user);
    } on FirebaseAuthException catch (e) {
      return left(AuthError(message: e.code));
    } catch (e) {
      return left(AuthError(message: e.toString()));
    }
  }

  @override
  EitherFutureTrueOrAuthError logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        await FirebaseAuth.instance.signOut();
        return right(true);
      } else {
        return left(AuthError(message: "User not logged in"));
      }
    } on FirebaseAuthException catch (e) {
      return left(AuthError(message: e.code));
    } catch (e) {
      return left(AuthError(message: e.toString()));
    }
  }

  @override
  EitherFutureTrueOrAuthError sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        await user.sendEmailVerification();
        return right(true);
      } else {
        return left(AuthError(message: "User not logged in"));
      }
    } on FirebaseAuthException catch (e) {
      return left(AuthError(message: e.code));
    } catch (e) {
      return left(AuthError(message: e.toString()));
    }
  }

  @override
  EitherFutureTrueOrAuthError sendPasswordReset(
      {required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
      return right(true);
    } on FirebaseAuthException catch (e) {
      return left(AuthError(message: e.code));
    } catch (e) {
      return left(AuthError(message: e.toString()));
    }
  }

  @override
  EitherAuthUserOrAuthError getCurrentUser() {
    return currentUser;
  }
}
