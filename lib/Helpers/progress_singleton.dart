import 'package:cosmos_epub/Model/book_progress_model.dart';
import 'package:isar/isar.dart';

class BookProgressSingleton {
  final Isar isar;

  BookProgressSingleton({required this.isar});

  Future<bool> setCurrentChapterIndex(String bookId, int chapterIndex) async {
    try {
      BookProgressModel? oldBookProgressModel = await isar.bookProgressModels
          .where()
          .filter()
          .bookIdEqualTo(bookId)
          .findFirst();

      if (oldBookProgressModel != null) {
        oldBookProgressModel.currentChapterIndex = chapterIndex;
        await isar.writeTxn(() async {
          isar.bookProgressModels.put(oldBookProgressModel);
        });
      } else {
        var newBookProgressModel = BookProgressModel(
            currentPageIndex: 0,
            currentChapterIndex: chapterIndex,
            bookId: bookId);
        await isar.writeTxn(() async {
          isar.bookProgressModels.put(newBookProgressModel);
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setCurrentPageIndex(String bookId, int pageIndex) async {
    try {
      BookProgressModel? oldBookProgressModel = await isar.bookProgressModels
          .where()
          .filter()
          .bookIdEqualTo(bookId)
          .findFirst();

      if (oldBookProgressModel != null) {
        oldBookProgressModel.currentPageIndex = pageIndex;
        await isar.writeTxn(() async {
          isar.bookProgressModels.put(oldBookProgressModel);
        });
      } else {
        var newBookProgressModel = BookProgressModel(
            currentPageIndex: pageIndex,
            currentChapterIndex: 0,
            bookId: bookId);
        await isar.writeTxn(() async {
          isar.bookProgressModels.put(newBookProgressModel);
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  BookProgressModel getBookProgress(String bookId) {
    var newBookProgressModel =
        BookProgressModel(currentPageIndex: 0, currentChapterIndex: 0);

    try {
      BookProgressModel? oldBookProgressModel = isar.bookProgressModels
          .where()
          .filter()
          .bookIdEqualTo(bookId)
          .findFirstSync();
      if (oldBookProgressModel != null) {
        return oldBookProgressModel;
      } else {
        return newBookProgressModel;
      }
    } on Exception {
      return newBookProgressModel;
    }
  }

  Future<bool> deleteBookProgress(String bookId) async {
    try {
      await isar.writeTxn(() async {
        await isar.bookProgressModels
            .where()
            .filter()
            .bookIdEqualTo(bookId)
            .deleteAll();
      });
      return true;
    } on Exception {
      return false;
    }
  }

  Future<bool> deleteAllBooksProgress() async {
    try {
      await isar.writeTxn(() async {
        await isar.bookProgressModels.where().deleteAll();
      });
      return true;
    } on Exception {
      return false;
    }
  }
}
