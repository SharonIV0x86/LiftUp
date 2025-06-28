import 'package:daily_quotes_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_quotes_app/QuotesManagement.dart';

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});

  @override
  State<GeneratorPage> createState() => _GeneratorPage();
}

class _GeneratorPage extends State<GeneratorPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      // ignore: use_build_context_synchronously
      () => Provider.of<QuotesManager>(context, listen: false).fetchQuotes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final managerState = context.watch<QuotesManager>();
    IconData icon;
    if (managerState.quotes_list.contains(managerState.current)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    return Scaffold(
      body: Center(
        child: managerState.isLoading
            ? const CircularProgressIndicator()
            : managerState.currentQuote == null
            ? const Text("Failed to load quote.")
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QuoteCard(
                    quote: managerState.currentQuote!.text,
                    author: managerState.currentQuote!.author,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          managerState.toggleFavorites();
                        },
                        label: Text("Like"),
                        icon: Icon(icon),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          managerState.fetchQuotes();
                        },
                        child: const Text("New Quote"),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
