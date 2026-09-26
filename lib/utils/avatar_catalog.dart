import 'package:flutter/widgets.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';

/// Catálogo de avatares de ECO2.
///
/// El usuario guarda solo el **id** (`agronoma`, `granjero`…) en `avatar_url`,
/// no la ruta del asset: así se puede reorganizar la carpeta o migrar a
/// imágenes servidas por el backend sin invalidar lo que ya eligió la gente.
///
/// Los nombres visibles se traducen aquí, en la capa de UI, porque el id es un
/// dato estable y el nombre no.
class AvatarOption {
  final String id;

  /// Coste en semillas. 0 = incluido con la cuenta.
  ///
  /// El precio se repite aquí solo para pintarlo; quien decide si una compra es
  /// válida es el backend (src/domain/avatars/catalog.ts). Si la app fuera la
  /// única que lo sabe, bastaría con editar la petición para llevárselo gratis.
  final int cost;

  const AvatarOption(this.id, {this.cost = 0});

  bool get isFree => cost == 0;

  String get asset => 'assets/avatars/$id.png';
}

const List<AvatarOption> kAvatars = [
  // Incluidos desde el registro.
  AvatarOption('agronoma'),
  AvatarOption('granjero'),
  AvatarOption('tecnologo'),
  AvatarOption('cientifico'),

  // De pago en la tienda de semillas.
  AvatarOption('jardinera', cost: 250),
  AvatarOption('explorador', cost: 300),
  AvatarOption('criadora', cost: 350),
  AvatarOption('noctilana', cost: 400),
];

/// Los que se venden en la tienda.
List<AvatarOption> get kPurchasableAvatars =>
    kAvatars.where((a) => !a.isFree).toList();

AvatarOption? avatarOptionFor(String id) {
  for (final a in kAvatars) {
    if (a.id == id) return a;
  }
  return null;
}

/// Ruta del asset para un id guardado, o null si no se reconoce.
///
/// Devuelve null en vez de caer en uno por defecto para que quien lo llame
/// decida qué enseñar: en el perfil interesa el icono genérico, no otro avatar
/// que la persona no eligió.
String? avatarAssetFor(String? id) {
  if (id == null || id.isEmpty) return null;
  for (final a in kAvatars) {
    if (a.id == id) return a.asset;
  }
  return null;
}

String avatarName(BuildContext context, String id) {
  final l = AppLocalizations.of(context)!;
  switch (id) {
    case 'agronoma':
      return l.avatarAgronomist;
    case 'granjero':
      return l.avatarFarmer;
    case 'jardinera':
      return l.avatarGardener;
    case 'tecnologo':
      return l.avatarTechnologist;
    case 'criadora':
      return l.avatarBreeder;
    case 'explorador':
      return l.avatarExplorer;
    case 'cientifico':
      return l.avatarScientist;
    case 'noctilana':
      return l.avatarFlorist;
    default:
      return id;
  }
}
