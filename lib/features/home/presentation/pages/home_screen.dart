import 'package:flutter/material.dart';
import 'package:minimalist_social_app/core/widgets/dark_mode_switch.dart';
import 'package:minimalist_social_app/core/widgets/text_widget.dart';
import 'package:minimalist_social_app/features/home/presentation/widgets/my_drawer.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  bool isListening = false;
  String wordsSpoken = "";
  late Animation<double> scaleAnimation;
  late Animation<double> scaleAnimation_2;

  late Animation<Offset> slideAnimation;

  late AnimationController controller;
  late AnimationController controller_1;
  late AnimationController controller_2;

  void initSpeech() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    controller_1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    controller_2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    scaleAnimation = Tween<double>(begin: 1, end: .25).animate(controller);
    scaleAnimation_2 = Tween<double>(begin: 1, end: 1.1).animate(controller_2);

    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(.45, 1))
            .animate(CurvedAnimation(parent: controller_1, curve: Curves.ease));
    initSpeech();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void listen() {
    if (speechToText.isListening) {
      stopListening();
    } else {
      startListening();
    }
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      wordsSpoken = result.recognizedWords;
    });
  }

  void startListening() async {
    await speechToText.listen(
      listenOptions:
          SpeechListenOptions(autoPunctuation: true, cancelOnError: true),
      onResult: onSpeechResult,
    );

    if (speechToText.isListening) {
      controller_2.repeat(reverse: true);
      controller_1.forward();
      controller.forward();
      isListening = speechToText.isListening;
    }

    setState(() {});
  }

  void stopListening() async {
    await speechToText.stop();
    controller.reverse();
    controller_1.reverse();
    controller_2.stop();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        listen();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          actions: const [
            DarkModeSwitch(),
          ],
          backgroundColor: Theme.of(context).colorScheme.background,
          title: TextWidget(
            text: "Assistant",
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        drawer: const MyDrawer(),
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    speechToText.isListening
                        ? "Listening ..."
                        : speechEnabled
                            ? "Tap microphone to start Listening"
                            : "Speech is not available",
                    style: const TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "You: $wordsSpoken",
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            Center(
                child: SlideTransition(
              position: slideAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: GestureDetector(
                  onTap: () {
                    listen();
                  },
                  child: CircleAvatar(
                    radius: 160,
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            width: 20,
                            color: speechToText.isListening
                                ? Theme.of(context).colorScheme.inversePrimary
                                : Theme.of(context).colorScheme.background),
                      ),
                      child: Icon(
                        Icons.mic,
                        size: 100,
                        color: speechToText.isListening
                            ? Theme.of(context).colorScheme.inversePrimary
                            : Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
