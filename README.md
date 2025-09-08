# CosmosEpub 💫

**CosmosEpub** is a Flutter package that allows users to open and read **EPUB** files easily. It provides features like opening **EPUB** files from ***assets*** or ***local path***, changing themes, adjusting font styles and sizes, accessing chapter contents, and more.
The reader is **responsive**, enabling its use with both normal-sized smartphones and tablets.

## Showcase

![banner](https://github.com/Mamasodikov/cosmos_epub/assets/64262986/b3ca850b-96da-48fc-9b9e-ff5f92544f53)

## Features


- Open EPUB files from assets or local path.
- **RTL (Right-to-Left) language support** for Arabic, Persian, Hebrew, Urdu, and other RTL languages
- **Automatic text direction detection** with proper alignment and navigation
- Change themes with 5 options: Grey, Purple, White, Black, and Pink
- Customize font style and size
- Access table of contents and navigate to specific chapters
- Display current chapter name at the bottom of the screen
- Previous and next buttons to switch between chapters (RTL-aware)
- Adjust screen brightness
- Save book reading progress
- Nice page flip animation while reading
- **Mixed content support** (LTR + RTL text in the same document)
- ...and feel free to ask for new features @ generalmarshallinbox@gmail.com or open an issue.

## Getting Started #

In your flutter project add the dependency:

   ```yaml
   dependencies:
     cosmos_epub: ^x.y.z
   ```  

Run the command:

   ```yaml
   flutter pub get
   ```    
For more information, check out the [documentation](https://flutter.dev/).

## Usage example
Import the package in your Dart code:

   ```yaml
   import 'package:cosmos_epub/cosmos_epub.dart';
   ```  
First things first, you have to `initialize` databases before using any other method. Kindly, do it earlier, preferably in the main.dart file.

There are various methods to control over book progress DB too for your ease :)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initializer and methods return a bool
  var _initialized = await CosmosEpub.initialize();
  
  if (_initialized) {
    BookProgressModel bookProgress = CosmosEpub.getBookProgress('bookId');
    await CosmosEpub.setCurrentPageIndex('bookId', 1);
    await CosmosEpub.setCurrentChapterIndex('bookId', 2);
    await CosmosEpub.deleteBookProgress('bookId');
    await CosmosEpub.deleteAllBooksProgress();
  }

  runApp(MyApp());
}
```

To open an EPUB file from the assets, use the `openAssetBook` method:

   ```dart
    await CosmosEpub.openAssetBook(
        assetPath: 'assets/book.epub',
        context: context,
        // Book ID is required to save the progress for each opened book
        bookId: '3',
        // Callbacks are optional
        onPageFlip: (int currentPage, int totalPages) {
          print(currentPage);
        },
        onLastPage: (int lastPageIndex) {
          print('We arrived to the last widget');
        });
   ```  
To open an EPUB file from a local storage, use the `openLocalBook` method:

   ```dart
    await CosmosEpub.openLocalBook(
        localPath: book.path,
        context: context,
        // Book ID is required to save the progress for each opened book
        bookId: '3'
        // Callbacks are optional
        onPageFlip: (int currentPage, int totalPages) {
          print(currentPage);
        },
        onLastPage: (int lastPageIndex) {
          print('We arrived to the last widget');
        });
   ``` 

Also you can use `CosmosEpub.openURLBook` and `CosmosEpub.openFileBook` for your convenience. 

For clearing theming cache, use this method:

  ```dart
    await CosmosEpub.clearThemeCache();
  ```

## RTL Language Support 🌍

CosmosEpub now includes comprehensive support for Right-to-Left (RTL) languages such as Arabic, Persian (Farsi), Hebrew, Urdu, and more.

### Features:
- **Automatic Detection**: The library automatically detects RTL content and applies appropriate text direction
- **Smart Navigation**: Navigation buttons automatically reverse for RTL content (left arrow becomes "next" for RTL)
- **Proper Alignment**: Text is properly aligned based on language direction
- **Chapter List Support**: Table of contents supports RTL layout with proper indentation
- **Mixed Content**: Handles documents with both LTR and RTL text seamlessly

### Supported Languages:
- Arabic (العربية)
- Persian/Farsi (فارسی)
- Hebrew (עברית)
- Urdu (اردو)
- Pashto (پښتو)
- Sindhi (سنڌي)
- Kurdish (کوردی)
- Dhivehi/Maldivian (ދިވެހި)
- Yiddish (ייִדיש)

### Usage:
No additional configuration is required! Simply open your RTL EPUB file as usual:

```dart
await CosmosEpub.openAssetBook(
    assetPath: 'assets/arabic_book.epub',
    context: context,
    bookId: 'arabic_book_1',
    onPageFlip: (currentPage, totalPages) {
      print('Page: $currentPage of $totalPages');
    },
);
```

The library will automatically:
1. Detect the text direction from the content
2. Apply proper RTL layout and navigation
3. Handle mixed LTR/RTL content appropriately

***Note: I haven't handled all exceptions, so control it on your own side. For example, if you give same bookId to the another book, it can open page and chapter from that book's progress or may break 💀***

***Feel free to contact me if you have any questions: https://allmylinks.com/mamasodikov***
