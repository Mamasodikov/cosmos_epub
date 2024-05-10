# CosmosEpub 💫

**CosmosEpub** is a Flutter package that allows users to open and read **EPUB** files easily. It provides features like opening **EPUB** files from ***assets*** or ***local path***, changing themes, adjusting font styles and sizes, accessing chapter contents, and more.
The reader is **responsive**, enabling its use with both normal-sized smartphones and tablets.

## Features

- Open EPUB files from assets or local path.
- Change themes with 5 options: Grey, Purple, White, Black, and Pink
- Customize font style and size
- Access table of contents and navigate to specific chapters
- Display current chapter name at the bottom of the screen
- Previous and next buttons to switch between chapters
- Adjust screen brightness
- Save book reading progress
- Nice page flip animation while reading
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

I used [Isar](https://isar.dev/) database to keep the progress. For more control over DB, read Isar docs. So i won't write it here ;)
Isar CRUD docs: https://isar.dev/crud.html

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var instance = await CosmosEpub.initialize();

// Initializer returns an instance to control over book progress DB.
  await instance.writeTxn(() async {
    instance.bookProgressModels.clear();
  });

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
        assetPath: 'assets/book.epub',
        context: context,
        // Book ID is required to save the progress for each opened book
        bookId: '3');
   ``` 

For clearing theming cache, use this method:

  ```dart
    await CosmosEpub.clearThemeCache();
  ```


***Note: I haven't handled all exceptions, so control it on your own side. For example, if you give same bookId to the another book, it can open page and chapter from that book's progress or may break 💀***

***Feel free to contact me if you have any questions: https://allmylinks.com/mamasodikov***