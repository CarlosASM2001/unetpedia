import 'dart:io';
import 'dart:math';

class FileModel {
  FileModel({required this.id, required this.name, required this.file});

  final String id;
  final String name;
  final File file;

  String get getExtension {
    final path = file.path;
    final lastDotIndex = path.lastIndexOf('.');

    // Se valida:
    // 1. Si no hay un punto
    // 2. Si el punto es el último carácter, no hay extensión.
    if ((lastDotIndex == -1) || (lastDotIndex == path.length - 1)) {
      return '';
    }

    // (Se incluye el punto)
    // Devuelve la cadena que comienza después del último punto.
    return path.substring(lastDotIndex);
  }

  // Tamaño del archivo en bytes
  int get getSizeInBytes => file.lengthSync();

  // Tamaño del archivo en un formato legible
  String get getSizeInFormattedString {
    final bytes = file.lengthSync();
    if (bytes <= 0) return "0 B";

    const suffixes = ["B", "KB", "MB", "GB", "TB"];

    // Calculamos el índice para el sufijo correcto
    final i = (log(bytes) / log(1024)).floor();

    // Devolvemos el valor formateado
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }
}
