// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:minimalist_social_app/core/errors/local_auth_error.dart';
import 'package:minimalist_social_app/core/utils/typedef.dart';

abstract class LocalAuthService {
  EitherBoolOrLocalAuthError canAuthenticateWithBiometrics();
  EitherListOfBiometricsOrLocalAuthError getBiometricsTypes();
  EitherBoolOrLocalAuthError authenticate();
}

class LocalAuthServiceImplementation implements LocalAuthService {
  final LocalAuthentication auth;
  LocalAuthServiceImplementation({
    required this.auth,
  });
  @override
  EitherBoolOrLocalAuthError canAuthenticateWithBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      return right(canAuthenticateWithBiometrics);
    } catch (e) {
      return left(LocalAuthError(message: e.toString()));
    }
  }

  @override
  EitherListOfBiometricsOrLocalAuthError getBiometricsTypes() async {
    try {
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (availableBiometrics.isNotEmpty) {}

      if (availableBiometrics.contains(BiometricType.strong) ||
          availableBiometrics.contains(BiometricType.face)) {
        // Specific types of biometrics are available.
        // Use checks like this with caution!
      }
      (availableBiometrics);

      return right(availableBiometrics);
    } catch (e) {
      return left(LocalAuthError(message: e.toString()));
    }
  }

  @override
  EitherBoolOrLocalAuthError authenticate() async {
    try {
      final canAuthenticate = await canAuthenticateWithBiometrics();
      final authenticate = canAuthenticate.fold(
          (l) => LocalAuthError(message: l.message), (r) => r);
      if (authenticate == true) {
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Please use biometrics to login',
            authMessages: const <AuthMessages>[
              // AndroidAuthMessages(
              //   signInTitle: 'Oops! Biometric authentication required!',
              //   cancelButton: 'No thanks',
              // ),
              // IOSAuthMessages(
              //   cancelButton: 'No thanks',
              // ),
            ]);
        return right(didAuthenticate);
      }

      return left(
          LocalAuthError(message: "Could not authenticate with biometrics"));
    } on PlatformException catch (e) {
      return left(
          LocalAuthError(message: e.message ?? "There has been an error"));
    }
  }
}
