import 'dart:io';
import 'package:path/path.dart' as path;

Future<void> main(List<String> args) async {
  // Checking for the root folder from positional arguments
  if (args.length != 1) {
    print('Usage: dart concat_files.dart <folder>');
    print('Example: dart concat_files.dart /path/to/your/top/level/folder');
    exit(1);
  }

  final String root = args[0];
  await concatenateFiles(root);
}

Future<void> concatenateFiles(String root) async {
  try {
    final directory = Directory(root);
    final entities = directory.listSync(recursive: true);

    for (final FileSystemEntity entity in entities.whereType<File>()) {
      final file = entity as File;
      final ext = path.extension(file.path).replaceFirst('.', '');
      if (ext == 'java' || ext == 'xml') {
        final relativePath = file.path.replaceFirst(root, '');
        final content = await file.readAsString();
        print('File "$relativePath":\n```$ext\n$content\n```\n\n');
      }
    }
  } on Exception catch (e) {
    print('Error: $e');
  }
}
