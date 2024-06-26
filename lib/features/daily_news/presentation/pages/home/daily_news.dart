import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimalist_social_app/core/widgets/dark_mode_switch.dart';
import 'package:minimalist_social_app/core/widgets/snackbar.dart';
import 'package:minimalist_social_app/core/widgets/text_widget.dart';
import 'package:minimalist_social_app/features/daily_news/presentation/bloc/daily_news_bloc.dart';
import 'package:minimalist_social_app/features/daily_news/presentation/widgets/article_widget.dart';
import 'package:minimalist_social_app/features/dark_mode/presentation/bloc/dark_mode_bloc.dart';

class DailyNews extends StatefulWidget {
  const DailyNews({super.key});

  @override
  State<DailyNews> createState() => _DailyNewsState();
}

class _DailyNewsState extends State<DailyNews> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: TextWidget(
            text: "Daily News",
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.inversePrimary),
        centerTitle: false,
        actions: [
          Transform.scale(
            scale: .8,
            child: BlocBuilder<DarkModeBloc, DarkModeState>(
                builder: (context, state) {
              return state is DarkModeCurrentState
                  ? const DarkModeSwitch()
                  : const SizedBox();
            }),
          )
        ],
      ),
      body: BlocListener<DailyNewsBloc, DailyNewsState>(
        listener: (context, state) {
          if (state is RemoteArticleError) {
            InfoSnackBar.showErrorSnackBar(context, state.serverError.message);
          }
        },
        child: BlocBuilder<DailyNewsBloc, DailyNewsState>(
          builder: (context, state) {
            if (state is RemoteArticleLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (state is RemoteArticleError) {
              return const Center(
                child: Icon(Icons.refresh),
              );
            }
            if (state is RemoteArticleDone) {
              return ListView.builder(
                  itemCount: (state.articles["items"].length),
                  itemBuilder: (context, index) {
                    return FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: ArticleWidget(
                          article: state.articles["items"][index]),
                    );
                  });
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
