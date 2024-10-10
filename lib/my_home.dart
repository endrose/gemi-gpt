import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemi_gpt/models/message.dart';
import 'package:gemi_gpt/theme_notifier.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final TextEditingController _textCon = TextEditingController();

  bool isLoading = false;

  final List<MessageModel> _message = [
    // MessageModel(text: 'Hi', user: true),
    // MessageModel(text: 'Hello', user: false),
    // MessageModel(text: 'Can I ask something', user: true),
  ];

  callGeminiMode() async {
    try {
      if (_textCon.text.isNotEmpty) {
        _message.add(MessageModel(text: _textCon.text, user: true));
        isLoading = true;
      }
      final model = GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: dotenv.env['GOOGLE_API_KEY']!);

      final prompt = _textCon.text.trim();
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        _message.add(MessageModel(text: response.text!, user: false));
        isLoading = false;
      });

      _textCon.clear();
    } catch (e) {
      print("Error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: false,
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/gpt-robot.png',
                ),
                const SizedBox(
                  width: 18,
                ),
                Text(
                  'Gemi Gpt',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                ref.read(themeProvider.notifier).toggleTheme();
              },
              child: (currentTheme == ThemeMode.dark)
                  ? const Icon(
                      Icons.light_mode,
                      color: Color(0xffffffff),
                    )
                  : const Icon(Icons.dark_mode, color: Color(0xff3369FF)),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _message.length,
              itemBuilder: (context, index) {
                final message = _message[index];
                return ListTile(
                    title: Align(
                  alignment: message.user
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: message.user
                              ? Colors.grey.withOpacity(0.0)
                              : Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      color: message.user
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                      borderRadius: message.user
                          ? const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              topLeft: Radius.circular(
                                20,
                              ),
                            )
                          : const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              topRight: Radius.circular(
                                20,
                              ),
                            ),
                    ),
                    child: Text(
                      message.text,
                      style: message.user
                          ? Theme.of(context).textTheme.bodyMedium
                          : Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 32,
              top: 16.0,
              left: 16,
              right: 16,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          callGeminiMode();
                          setState(() {
                            isLoading = false;
                            _textCon.clear();
                          });
                        }
                      },
                      style: Theme.of(context).textTheme.titleSmall,
                      controller: _textCon,
                      decoration: InputDecoration(
                          hintText: 'Write your message',
                          hintStyle:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Colors.grey,
                                  ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: () {
                              callGeminiMode();
                            },
                            child: Image.asset('assets/images/send.png'),
                          ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
