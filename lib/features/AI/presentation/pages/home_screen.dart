import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minimalist_social_app/core/utils/logger.dart';
import 'package:minimalist_social_app/core/widgets/dark_mode_switch.dart';
import 'package:minimalist_social_app/core/widgets/loading_widget.dart';
import 'package:minimalist_social_app/core/widgets/snackbar.dart';
import 'package:minimalist_social_app/core/widgets/text_widget.dart';
import 'package:minimalist_social_app/features/AI/presentation/bloc/ai_bloc.dart';
import 'package:minimalist_social_app/features/AI/presentation/bloc/bloc.dart';
import 'package:minimalist_social_app/features/AI/presentation/widgets/my_drawer.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:torch_light/torch_light.dart';

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
  String wordsExtracted = "";
  // ignore: unused_field
  String _selectedImagePath = "";
  final bool _isApi = false;
  late Animation<double> scaleAnimation;
  late Animation<double> scaleAnimation_2;

  late Animation<Offset> slideAnimation;

  late AnimationController controller;
  late AnimationController controller_1;
  late AnimationController controller_2;
  FlutterTts flutterTts = FlutterTts();
  String response = "";
  late Map currentVoice;
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
    initTTS();
    initTorch();
  }

  void initTorch() async {
    try {
      await TorchLight.isTorchAvailable();
    } on Exception catch (_) {
      (_);
    }
  }

  void torchOn() async {
    try {
      await TorchLight.enableTorch();
    } on Exception catch (_) {
      (_);
    }
  }

  void torchOff() async {
    try {
      await TorchLight.disableTorch();
    } on Exception catch (_) {
      (_);
    }
  }

  void initTTS() async {
    try {
      final voices = await flutterTts.getVoices;
      List<Map> voices0 = List<Map>.from(voices);

      voices0 = voices0.where((voice) => voice["name"].contains('en')).toList();
      (voices0);
      setState(() {
        currentVoice = voices0.first;
        setVoice(currentVoice);
      });
    } catch (e) {
      (e.toString());
    }
  }

  void setVoice(Map voice) {
    flutterTts.setVoice({"name": voice['name'], "locale": voice['locale']});
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Future _pickImageGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImagePath = File(returnedImage.path).path;
    });
  }

  Future _pickImageCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    (File(returnedImage.path));
    setState(() {
      _selectedImagePath = File(returnedImage.path).path;
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
    // controller.reverse();
    // controller_1.reverse();
    controller_2.stop();

    setState(() {});
  }

  void listen() {
    if (speechToText.isListening) {
      stopListening();
    } else {
      startListening();
    }
    flutterTts.stop();
  }

  Future<void> onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      wordsSpoken = result.recognizedWords;
    });
    // Define the excluded words
    const excludedWords = [
      "lumos",
      "no lumos",
      "read from camera",
      "read from storage"
    ];

    // Check if the spoken words are in the excluded list
    if (!excludedWords.contains(wordsSpoken.toLowerCase())) {
      if (wordsSpoken.toLowerCase().contains("assistant")) {
        Future.delayed(const Duration(seconds: 5), () {
          context.read<AiBloc>().add(AiEventGetResponse(prompt: wordsSpoken));
        });
      }

      logger
          .e({excludedWords.contains(wordsSpoken.toLowerCase()), wordsSpoken});
    } else {
      switch (wordsSpoken.toLowerCase()) {
        case "lumos":
          torchOn();
          flutterTts.speak("Flash Light On");
          break;
        case "no lumos":
          torchOff();
          flutterTts.speak("Flash Light Off");
          break;
        case "read from camera":
          await _pickImageCamera();
          break;

        case "read from storage":
          await _pickImageGallery();
          logger.e(_selectedImagePath);
          final InputImage inputImage =
              InputImage.fromFilePath(_selectedImagePath);
          final textRecognizer = TextRecognizer();
          final RecognizedText recognizedText =
              await textRecognizer.processImage(inputImage);
          String extractedText = recognizedText.text;
          logger.e(extractedText);
          setState(() {
            wordsExtracted = extractedText;
          });
          flutterTts.speak(extractedText);

          break;
        default:
          Future.delayed(const Duration(seconds: 5), () {});
      }
    }
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
                  // Image.file(_selectedImage!),
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
                    margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
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
            BlocConsumer<AiBloc, AiState>(
              listener: (context, state) {
                if (state is AiResponseIsLoading) {
                  flutterTts.speak("Please be patient as I assist you");
                }
                if (state is AiResponseError) {
                  InfoSnackBar.showErrorSnackBar(context, state.error.message);

                  flutterTts.speak(
                      "Unfortunately we are unable to help with that today");
                }

                if (state is AiResponseRetrieved) {
                  response = state.response.responseText!.replaceAll("*", " ");

                  flutterTts.speak(response);
                }
              },
              builder: (context, state) {
                return state is AiResponseIsLoading
                    ? const LoadingWidget()
                    : state is AiResponseRetrieved
                        ? Container(
                            margin: const EdgeInsets.only(
                                top: 20, left: 15, right: 15),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(10)),
                            child: ListView(children: [
                              TextWidget(
                                text:
                                    "Assistant: ${state.response.responseText!.replaceAll("*", " ")}",
                                textAlign: TextAlign.start,
                                fontSize: 20,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ]),
                          )
                        : Container(
                            margin: const EdgeInsets.only(
                                top: 20, left: 15, right: 15),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(10)),
                            child: ListView(children: [
                              TextWidget(
                                text: wordsExtracted == ""
                                    ? ""
                                    : "Assistant: $wordsExtracted",
                                textAlign: TextAlign.start,
                                fontSize: 20,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ]),
                          );
              },
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
