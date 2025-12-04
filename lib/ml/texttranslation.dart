import 'package:flutter/material.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';


class TextTranslation extends StatefulWidget {

  const TextTranslation({Key? key}) : super(key: key);


  @override
  State<TextTranslation> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TextTranslation> {

  TextEditingController textEditingController = TextEditingController();
  String result = "Translated text...";
  String sourceLang = "en";
  String targetLang = "ur";

  late OnDeviceTranslator translator;
  final modelManager = OnDeviceTranslatorModelManager();
  bool modelReady = false;

  @override
  void initState() {
    super.initState();
    checkAndDownloadModel();
  }

  // ---------------------------------------------------
  // ✅ Check + Download Language Models (Required Once)
  // ---------------------------------------------------
  checkAndDownloadModel() async {
    print("Checking language models...");

    bool sourceDownloaded = await modelManager.isModelDownloaded(sourceLang);
    bool targetDownloaded = await modelManager.isModelDownloaded(targetLang);

    if (!sourceDownloaded) {
      print("Downloading English model...");
      await modelManager.downloadModel(sourceLang);
    }
    if (!targetDownloaded) {
      print("Downloading Urdu model...");
      await modelManager.downloadModel(targetLang);
    }

    print("Models Ready!");

    // Create translator once models are ready
    translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.urdu,
    );

    setState(() {
      modelReady = true;
    });
  }

  // ---------------------------------------------------
  // ✅ Translate Text
  // ---------------------------------------------------
  translateText(String text) async {
    if (!modelReady) {
      setState(() {
        result = "Model is downloading... please wait.";
      });
      return;
    }

    if (text.isEmpty) {
      setState(() => result = "Please type something...");
      return;
    }

    String translated = await translator.translateText(text);

    setState(() {
      result = translated;
    });
  }

  // ---------------------------------------------------
  // ✅ Identify Language Automatically
  // ---------------------------------------------------
  identifyLanguages(String text) async {
    final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
    final lang = await languageIdentifier.identifyLanguage(text);
    languageIdentifier.close();
    return lang;
  }

  @override
  void dispose() {
    translator.close();
    super.dispose();
  }

  // ---------------------------------------------------
  // ✅ UI (Clean + With Comments)
  // ---------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            color: Colors.black12,
            child: Column(
              children: [
                // ---------------------------------------------------
                // 🔵 Language Card (English → Urdu)
                // ---------------------------------------------------
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  height: 50,
                  child: Card(
                    elevation: 2,
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text(
                          'English',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                        Text(
                          'Urdu',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                // ---------------------------------------------------
                // ✏️ Input Text Field
                // ---------------------------------------------------
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  width: double.infinity,
                  height: 220,
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: textEditingController,
                        decoration: const InputDecoration(
                          hintText: "Type text here...",
                          border: InputBorder.none,
                        ),
                        maxLines: 10,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),

                // ---------------------------------------------------
                // 🟢 "Translate" Button
                // ---------------------------------------------------
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        backgroundColor: Colors.green),
                    onPressed: () async {
                      translateText(textEditingController.text);
                    },
                    child: const Text(
                      "Translate",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                // ---------------------------------------------------
                // 📘 Output: Translated Text
                // ---------------------------------------------------
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  width: double.infinity,
                  height: 220,
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        result,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
