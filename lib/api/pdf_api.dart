import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> saveDocument(String name, Document pdf) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    print(DateFormat('dd-MMM-yyyy-jms').format(DateTime.now()));
    print(dir.path);

    final file = File('${dir.path}/$name');
    file.writeAsBytes(bytes);
    return file;
  }
}
