library cosmos_epub;

import 'dart:io';

import 'package:cosmos_epub/Component/constants.dart';
import 'package:cosmos_epub/Helpers/isar_service.dart';
import 'package:cosmos_epub/Helpers/progress_singleton.dart';
import 'package:cosmos_epub/Model/book_progress_model.dart';
import 'package:cosmos_epub/show_epub.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

class CosmosEpub {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static bool _initialized = false;

  static Future<void> openLocalBook(
      {required String localPath,
      required BuildContext context,
      required String bookId,
      Color accentColor = Colors.indigoAccent,
      Function(int currentPage, int totalPages)? onPageFlip,
      Function(int lastPageIndex)? onLastPage,
      String chapterListTitle = 'Table of Contents',
      bool shouldOpenDrawer = false,
      int starterChapter = -1}) async {
    ///TODO: Optimize with isolates
    var bytes = File(localPath).readAsBytesSync();
    EpubBook epubBook = await EpubReader.readBook(bytes.buffer.asUint8List());

    if (!context.mounted) return;
    _openBook(
        context: context,
        epubBook: epubBook,
        bookId: bookId,
        shouldOpenDrawer: shouldOpenDrawer,
        starterChapter: starterChapter,
        chapterListTitle: chapterListTitle,
        onPageFlip: onPageFlip,
        onLastPage: onLastPage,
        accentColor: accentColor);
  }

  static Future<void> openAssetBook(
      {required String assetPath,
      required BuildContext context,
      Color accentColor = Colors.indigoAccent,
      Function(int currentPage, int totalPages)? onPageFlip,
      Function(int lastPageIndex)? onLastPage,
      required String bookId,
      String chapterListTitle = 'Table of Contents',
      bool shouldOpenDrawer = false,
      int starterChapter = -1}) async {
    ///TODO: Optimize with isolates

    var bytes = await rootBundle.load(assetPath);
    EpubBook epubBook = await EpubReader.readBook(bytes.buffer.asUint8List());

    if (!context.mounted) return;
    _openBook(
        context: context,
        epubBook: epubBook,
        bookId: bookId,
        shouldOpenDrawer: shouldOpenDrawer,
        starterChapter: starterChapter,
        chapterListTitle: chapterListTitle,
        onPageFlip: onPageFlip,
        onLastPage: onLastPage,
        accentColor: accentColor);
  }

  static _openBook(
      {required BuildContext context,
      required EpubBook epubBook,
      required String bookId,
      required bool shouldOpenDrawer,
      required Color accentColor,
      required int starterChapter,
      required String chapterListTitle,
      Function(int currentPage, int totalPages)? onPageFlip,
      Function(int lastPageIndex)? onLastPage}) async {
    _checkInitialization();

    ///Set starter chapter as current
    if (starterChapter != -1) {
      await bookProgress.setCurrentChapterIndex(bookId, starterChapter);
      await bookProgress.setCurrentPageIndex(bookId, 0);
    }

    var route = MaterialPageRoute(
      builder: (context) {
        return ShowEpub(
          epubBook: epubBook,
          starterChapter: starterChapter >= 0
              ? starterChapter
              : bookProgress
                      .getBookProgress(bookId)
                      .currentChapterIndex ??
                  0,
          shouldOpenDrawer: shouldOpenDrawer,
          bookId: bookId,
          accentColor: accentColor,
          chapterListTitle: chapterListTitle,
          onPageFlip: onPageFlip,
          onLastPage: onLastPage,
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      shouldOpenDrawer != false || starterChapter != -1
          ? Navigator.pushReplacement(
              context,
              route,
            )
          : Navigator.push(
              context,
              route,
            );
    });
  }

  static Future<bool> initialize() async {
    await ScreenUtil.ensureScreenSize();
    await GetStorage.init();
    var isar = await IsarService.buildIsarService();
    bookProgress = BookProgressSingleton(isar: isar);
    _initialized = true;
    return true;
  }

  static _checkInitialization() {
    if (!_initialized) {
      throw Exception(
          'CosmosEpub is not initialized. Please call initialize() before using other methods. For more info pls read the docs');
    }
  }

  static Future<bool> clearThemeCache() async {
    if (await GetStorage().initStorage) {
      var get = GetStorage();
      await get.remove(LIB_THEME);
      await get.remove(LIB_FONT);
      await get.remove(LIB_FONT_SIZE);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> setCurrentPageIndex(String bookId, int index) async {
    return await bookProgress.setCurrentPageIndex(bookId, index);
  }

  static Future<bool> setCurrentChapterIndex(String bookId, int index) async {
    return await bookProgress.setCurrentChapterIndex(bookId, index);
  }

  static BookProgressModel getBookProgress(String bookId) {
    return bookProgress.getBookProgress(bookId);
  }

  static Future<bool> deleteBookProgress(String bookId) async {
    return await bookProgress.deleteBookProgress(bookId);
  }

  static Future<bool> deleteAllBooksProgress() async {
    return await bookProgress.deleteAllBooksProgress();
  }
}
