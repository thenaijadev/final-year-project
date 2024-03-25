import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:minimalist_social_app/config/router/routes.dart';
import 'package:minimalist_social_app/core/validator/validator.dart';
import 'package:minimalist_social_app/core/widgets/loading_widget.dart';
import 'package:minimalist_social_app/core/widgets/snackbar.dart';
import 'package:minimalist_social_app/core/widgets/text_widget.dart';
import 'package:minimalist_social_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:minimalist_social_app/features/auth/presentation/widgets/biometrics_button.dart';
import 'package:minimalist_social_app/features/auth/presentation/widgets/form_button.dart';
import 'package:minimalist_social_app/features/auth/presentation/widgets/input_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailKey = GlobalKey<FormFieldState>();
  final passwordKey = GlobalKey<FormFieldState>();
  bool? emailState = false;
  bool? passwordState = false;
  bool enabled = false;
  bool obscureText = true;
  bool? checkBoxValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Gap(150),
                  Icon(Icons.person,
                      size: 80,
                      color: Theme.of(context).colorScheme.inversePrimary),
                  const Gap(
                    25,
                  ),
                  InputFieldWidget(
                    textFieldkey: emailKey,
                    label: "Your email address",
                    hintText: "e.g:mark@gmail.com",
                    onChanged: (val) {
                      setState(() {
                        emailState = emailKey.currentState?.validate();
                      });
                    },
                    validator: (val) {
                      final emailState =
                          Validator.validateEmail(emailKey.currentState?.value);
                      return emailState;
                    },
                    enabledBorderRadius: 10,
                    hintColor: Theme.of(context).colorScheme.secondary,
                  ),
                  InputFieldWidget(
                    textFieldkey: passwordKey,
                    obscureText: obscureText,
                    label: "Password",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: Icon(obscureText
                          ? Icons.visibility
                          : Icons.visibility_off),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    hintText: "e.g: Password5&",
                    onChanged: (val) {
                      setState(() {
                        passwordState = passwordKey.currentState?.validate();
                      });
                    },
                    validator: (val) {
                      final passwordState = Validator.validatePassword(
                          passwordKey.currentState?.value);
                      return passwordState;
                    },
                    enabledBorderRadius: 10,
                    hintColor: Theme.of(context).colorScheme.secondary,
                  ),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.forgotPassword);
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthStateAuthError) {
                        InfoSnackBar.showErrorSnackBar(
                            context, state.authError.message);
                      }
                      if (state is AuthStateIsLoggedIn) {
                        if (state.user.isEmailVerified == false) {
                          Navigator.pushReplacementNamed(
                              context, Routes.emailVerification);
                          // (state.user.isEmailVerified);
                        }
                        Navigator.popAndPushNamed(context, Routes.home);
                      }

                      if (state is AuthStateBiometricsError) {
                        InfoSnackBar.showErrorSnackBar(
                            context, state.error.message);
                      }
                    },
                    builder: (context, state) {
                      return state is AuthStateIsLoading
                          ? const LoadingWidget()
                          : FormButton(
                              label: "Login",
                              onTap: () {
                                if (emailState! && passwordState!) {
                                  context.read<AuthBloc>().add(AuthEventLogin(
                                      email: emailKey.currentState?.value,
                                      password:
                                          passwordKey.currentState?.value));
                                }
                              },
                            );
                    },
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: TextWidget(
                          fontWeight: FontWeight.w300,
                          text: "Dont have an account?",
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextWidget(
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.register);
                        },
                        fontWeight: FontWeight.bold,
                        text: "Register",
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ],
                  ),
                  BiometricsButton(
                    onTap: () {
                      context
                          .read<AuthBloc>()
                          .add(AuthEventAuthWithBiometrics());
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
