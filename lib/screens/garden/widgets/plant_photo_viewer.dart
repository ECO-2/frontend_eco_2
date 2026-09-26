import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';

/// Visor a pantalla completa de la foto de una planta, con zoom por pellizco.
///
/// En el detalle la imagen se muestra pequeña y con `BoxFit.contain`, así que
/// no se apreciaban los detalles de la hoja. Aquí se abre sobre fondo oscuro y
/// se puede acercar; el doble toque alterna entre ajustada y ampliada.
class PlantPhotoViewer extends StatefulWidget {
  /// Foto que el usuario tomó, guardada en el dispositivo.
  final File? customPhoto;

  /// Foto de la especie que sirve el backend, si no hay foto propia.
  final String? imageUrl;

  /// Nombre a mostrar en la barra superior.
  final String title;

  const PlantPhotoViewer({
    super.key,
    this.customPhoto,
    this.imageUrl,
    required this.title,
  });

  /// True cuando hay algo que enseñar. Sin esto el visor abriría en negro.
  static bool hasPhoto({File? customPhoto, String? imageUrl}) =>
      customPhoto != null || imageUrl != null;

  @override
  State<PlantPhotoViewer> createState() => _PlantPhotoViewerState();
}

class _PlantPhotoViewerState extends State<PlantPhotoViewer> {
  final _controller = TransformationController();
  TapDownDetails? _lastTap;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleZoom() {
    final isZoomed = _controller.value.getMaxScaleOnAxis() > 1.01;
    if (isZoomed) {
      _controller.value = Matrix4.identity();
      return;
    }
    // Amplía centrando en el punto tocado, no en el medio de la pantalla.
    final position = _lastTap?.localPosition;
    if (position == null) return;
    const scale = 2.5;
    _controller.value = Matrix4.identity()
      ..translateByDouble(
          -position.dx * (scale - 1), -position.dy * (scale - 1), 0, 1)
      ..scaleByDouble(scale, scale, scale, 1);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontFamily: 'DM Sans'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: l.close,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        onDoubleTapDown: (d) => _lastTap = d,
        onDoubleTap: _toggleZoom,
        child: InteractiveViewer(
          transformationController: _controller,
          minScale: 1,
          maxScale: 5,
          child: Center(child: _buildImage()),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.customPhoto != null) {
      return Image.file(widget.customPhoto!, fit: BoxFit.contain);
    }
    if (widget.imageUrl != null) {
      return CachedNetworkImage(
        // Sin la transformación de fondo transparente: sobre negro conviene
        // ver la foto tal cual, sin recortes de fondo.
        imageUrl: widget.imageUrl!,
        fit: BoxFit.contain,
        placeholder: (_, _) => const Center(
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        ),
        errorWidget: (_, _, _) => const Icon(
          Icons.broken_image_outlined,
          size: 64,
          color: Colors.white38,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

/// Abre el visor si hay foto que enseñar.
Future<void> showPlantPhoto(
  BuildContext context, {
  File? customPhoto,
  String? imageUrl,
  required String title,
}) {
  if (!PlantPhotoViewer.hasPhoto(customPhoto: customPhoto, imageUrl: imageUrl)) {
    return Future.value();
  }
  return Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => PlantPhotoViewer(
        customPhoto: customPhoto,
        imageUrl: imageUrl,
        title: title,
      ),
    ),
  );
}
