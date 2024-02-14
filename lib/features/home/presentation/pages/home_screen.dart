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
    setState(() {
      isListening = !isListening;
    });
    controller.forward();
    controller_1.forward();
    if (isListening == false) {
      controller.reverse();
      controller_1.reverse();
    }

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
    controller_2.repeat(reverse: true);
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  void stopListening() async {
    controller_2.stop();
    await speechToText.stop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        children: [
          Column(
            children: [
              Text(speechToText.isListening
                  ? "Listening ..."
                  : speechEnabled
                      ? "Tap microphone to start Listening"
                      : "Speech is not available")
            ],
          ),
          Center(
              child: SlideTransition(
            position: slideAnimation,
            child: ScaleTransition(
              scale: scaleAnimation_2,
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
                            color: isListening
                                ? Theme.of(context).colorScheme.inversePrimary
                                : Theme.of(context).colorScheme.background),
                      ),
                      child: Icon(
                        Icons.mic,
                        size: 100,
                        color: isListening
                            ? Theme.of(context).colorScheme.inversePrimary
                            : Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
