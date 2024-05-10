import 'dart:io';

import 'package:cosmos_epub/Model/book_progress_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

const SCHEMES = [BookProgressModelSchema];

class IsarService {
  late final Isar isar;

  IsarService._create(this.isar);

  static Future<Isar> buildIsarService() async {
    final dir = await getApplicationDocumentsDirectory();
    final dirNew = Directory("${dir.path}/cosmos_epub");
    dirNew.create(recursive: true);

    var isarInstance = Isar.getInstance();

    if (isarInstance == null) {
      final isar = await Isar.open(
        SCHEMES,
        directory: dirNew.path,
      );

      IsarService._create(isar);
      return isar;
    } else {
      return isarInstance;
    }
  }
}
