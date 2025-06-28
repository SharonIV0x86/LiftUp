import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_quotes_app/QuotesManagement.dart';
import 'package:daily_quotes_app/GeneratorPage.dart';
import 'package:daily_quotes_app/app_theme.dart';
import 'package:daily_quotes_app/ThemeToggle.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuotesManager()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: const MyApp(),
    ),
  );
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return ChangeNotifierProvider(
      create: (context) => QuotesManager(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeNotifier.themeMode,
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError("Page not found");
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600 ? true : false,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text("Home"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text("Favorites"),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) => {
                    setState(() {
                      selectedIndex = value;
                    }),
                  },
                ),
              ),
              Expanded(child: Container(child: page)),
            ],
          ),
        );
      },
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var managerState = context.watch<QuotesManager>();
    var theme = Theme.of(context);
    var style = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    if (managerState.quotes_list.isEmpty) {
      return Center(child: Text("No Favorites Yet"));
    }
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "You have ${managerState.quotes_list.length} favorites",
            ),
          ),
          for (var quote in managerState.quotes_list)
            (ListTile(
              title: Text(quote.text),
              leading: Icon(Icons.favorite),
              trailing: IconButton(
                onPressed: () {
                  managerState.removeQuoteFromFavorite(quote);
                },
                icon: Icon(Icons.delete),
              ),
            )),
        ],
      ),
    );
  }
}

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key, required this.quote, required this.author});

  final String quote;
  final String author;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final quoteStyle = theme.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );

    final authorStyle = theme.textTheme.bodyMedium!.copyWith(
      fontSize: 16,
      fontStyle: FontStyle.italic,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        children: [
          Text(
            '"$quote"',
            style: quoteStyle,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "- $author",
              style: authorStyle,
              textAlign: TextAlign.right,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
