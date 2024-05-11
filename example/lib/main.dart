import 'package:cosmos_epub/cosmos_epub.dart';
import 'package:cosmos_epub/show_epub.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initializer returns a bool
  var _initialized = await CosmosEpub.initialize();

  // You can control database with singleton class member
  if (_initialized) {
    bookProgress.getBookProgress('bookId');
    bookProgress.setCurrentPageIndex('bookId', 1);
    bookProgress.setCurrentChapterIndex('bookId', 2);
    bookProgress.deleteBookProgress('bookId');
    bookProgress.deleteAllBooksProgress();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      title: 'CosmosEpub 💫 Reader Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff0a0e21),
        ),
        scaffoldBackgroundColor: Color(0xff0a0e21),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> readerFuture = Future.value(true);

  Future<void> _openEpubReader(BuildContext context) async {
    await CosmosEpub.openAssetBook(
        assetPath: 'assets/book.epub',
        context: context,
        bookId: '3',
        onPageFlip: (int currentPage, int totalPages) {
          print(currentPage);
        },
        onLastPage: (int lastPageIndex) {
          print('We arrived to the last widget');
        });
  }

  lateFuture() {
    setState(() {
      readerFuture = _openEpubReader(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CosmosEpub 💫 Reader Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            lateFuture();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.yellow),
              padding: MaterialStateProperty.all(EdgeInsets.all(20))),
          child: FutureBuilder<void>(
            future: readerFuture, // Set the future to the async operation
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  {
                    // While waiting for the future to complete, display a loading indicator.
                    return CupertinoActivityIndicator(
                      radius: 15,
                      color: Colors.black, // Adjust the radius as needed
                    );
                  }
                default:
                  // By default, show the button text
                  return Text(
                    'Open book  🚀',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
