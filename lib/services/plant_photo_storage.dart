import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Guarda la foto personalizada de cada planta del usuario en el
/// almacenamiento local del dispositivo — nunca se sube al backend.
/// Cada planta tiene, a lo sumo, un archivo `<plantId>.jpg` dentro de
/// `plant_photos/` en el directorio de documentos de la app.
class PlantPhotoStorage {
  Directory? _dir;

  Future<Directory> _photosDir() async {
    if (_dir != null) return _dir!;
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/plant_photos');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _dir = dir;
    return dir;
  }

  String _pathFor(Directory dir, String plantId) => '${dir.path}/$plantId.jpg';

  /// Devuelve el archivo de foto de la planta si el usuario le puso una,
  /// o null si todavía usa la foto de la especie (o el ícono).
  Future<File?> getPhoto(String plantId) async {
    final dir = await _photosDir();
    final file = File(_pathFor(dir, plantId));
    return await file.exists() ? file : null;
  }

  /// Escanea todas las fotos guardadas — usado para poblar el caché en
  /// memoria del provider al iniciar la app.
  Future<Map<String, File>> loadAll() async {
    final dir = await _photosDir();
    final result = <String, File>{};
    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.jpg')) {
        final fileName = entity.uri.pathSegments.last;
        final plantId = fileName.substring(0, fileName.length - 4);
        result[plantId] = entity;
      }
    }
    return result;
  }

  /// Copia la imagen elegida por el usuario (de la galería o la cámara) al
  /// almacenamiento local de la app, reemplazando la anterior si existía.
  Future<File> savePhoto(String plantId, String sourcePath) async {
    final dir = await _photosDir();
    final destination = File(_pathFor(dir, plantId));
    return File(sourcePath).copy(destination.path);
  }

  Future<void> deletePhoto(String plantId) async {
    final dir = await _photosDir();
    final file = File(_pathFor(dir, plantId));
    if (await file.exists()) {
      await file.delete();
    }
  }
}
