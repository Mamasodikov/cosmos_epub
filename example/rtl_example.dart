import 'package:flutter/material.dart';
import 'package:cosmos_epub/cosmos_epub.dart';

/// Example demonstrating RTL (Right-to-Left) support in CosmosEpub
///
/// This example shows how the library automatically detects and handles
/// RTL languages like Persian, Arabic, Hebrew, and Urdu.
///
/// The library will automatically:
/// - Detect text direction based on content
/// - Apply proper text alignment
/// - Reverse navigation buttons for RTL content
/// - Support RTL layout in chapter list
///
/// Usage example for Persian/Arabic EPUB files:

class RTLEpubExample extends StatelessWidget {
  const RTLEpubExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RTL EPUB Example'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Example for Persian EPUB
            ElevatedButton(
              onPressed: () async {
                await CosmosEpub.openAssetBook(
                  assetPath:
                      'assets/persian_book.epub', // Your Persian EPUB file
                  context: context,
                  bookId: 'persian_book_1',
                  onPageFlip: (currentPage, totalPages) {
                    print('Page: $currentPage of $totalPages');
                  },
                );
              },
              child: Text('Open Persian EPUB'),
            ),

            SizedBox(height: 20),

            // Example for Arabic EPUB
            ElevatedButton(
              onPressed: () async {
                await CosmosEpub.openAssetBook(
                  assetPath: 'assets/arabic_book.epub', // Your Arabic EPUB file
                  context: context,
                  bookId: 'arabic_book_1',
                  onPageFlip: (currentPage, totalPages) {
                    print('Page: $currentPage of $totalPages');
                  },
                );
              },
              child: Text('Open Arabic EPUB'),
            ),

            SizedBox(height: 20),

            // Example for mixed content (LTR + RTL)
            ElevatedButton(
              onPressed: () async {
                await CosmosEpub.openAssetBook(
                  assetPath:
                      'assets/mixed_content.epub', // Mixed LTR/RTL content
                  context: context,
                  bookId: 'mixed_book_1',
                  onPageFlip: (currentPage, totalPages) {
                    print('Page: $currentPage of $totalPages');
                  },
                );
              },
              child: Text('Open Mixed Content EPUB'),
            ),

            SizedBox(height: 40),

            Text(
              'RTL Features Included:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• Automatic text direction detection'),
                  Text('• RTL-aware navigation buttons'),
                  Text('• Proper text alignment for RTL content'),
                  Text('• RTL support in chapter list'),
                  Text('• Mixed content support (LTR + RTL)'),
                  Text('• Supports: Arabic, Persian, Hebrew, Urdu, etc.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sample usage in main.dart:
/// 
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   
///   // Initialize CosmosEpub
///   bool initialized = await CosmosEpub.initialize();
///   
///   if (initialized) {
///     runApp(MyApp());
///   }
/// }
/// 
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       title: 'RTL EPUB Reader',
///       home: RTLEpubExample(),
///     );
///   }
/// }
/// ```
