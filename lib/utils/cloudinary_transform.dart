/// Inserta la transformación de Cloudinary que quita el fondo de una foto
/// (add-on de IA "Background Removal", confirmado activo en esta cuenta) y
/// la entrega como PNG con transparencia real (canal alfa), en vez del fondo
/// gris de estudio que trae la foto original.
///
/// Cloudinary genera y cachea esa variante la primera vez que se pide esa
/// combinación de transformación + imagen; las siguientes cargas (de
/// cualquier usuario) se sirven ya procesadas, no se reprocesa cada vez.
///
/// Si la URL no es de Cloudinary (o no tiene el segmento /upload/ esperado),
/// se devuelve tal cual — evita romper imágenes de otro origen.
String withTransparentBackground(String url) {
  if (!url.contains('res.cloudinary.com') || !url.contains('/upload/')) {
    return url;
  }
  return url.replaceFirst('/upload/', '/upload/e_background_removal/f_png/');
}
