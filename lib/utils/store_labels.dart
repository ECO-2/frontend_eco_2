import 'package:flutter/widgets.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';

/// Textos de la tienda, resueltos en la capa de UI.
///
/// El catálogo de artículos es una lista `const` de nivel superior, así que no
/// puede llamar a `AppLocalizations` — no hay `BuildContext` ahí. Igual que en
/// [catalog_labels.dart], el dato crudo (el `id` del artículo) queda intacto y
/// la traducción se decide al pintar.

String storeItemTitle(BuildContext context, String id) {
  final l = AppLocalizations.of(context)!;
  switch (id) {
    case 'o2_plus_2w':
      return l.storeO2Plus2wTitle;
    case 'maceta_rental_2w':
      return l.storePotRentalTitle;
    case 'jardinera':
      return l.storeJardineraTitle;
    case 'explorador':
      return l.storeExploradorTitle;
    case 'criadora':
      return l.storeCriadoraTitle;
    case 'noctilana':
      return l.storeNoctilanaTitle;
    case 'maceta_pack3':
      return l.storePotPack3Title;
    case 'o2_plus_4w':
      return l.storeO2Plus4wTitle;
    default:
      return id;
  }
}

String storeItemSubtitle(BuildContext context, String id) {
  final l = AppLocalizations.of(context)!;
  switch (id) {
    case 'o2_plus_2w':
      return l.storeO2Plus2wSubtitle;
    case 'maceta_rental_2w':
      return l.storePotRentalSubtitle;
    case 'jardinera':
    case 'explorador':
    case 'criadora':
    case 'noctilana':
      return l.storeAvatarSubtitle;
    case 'maceta_pack3':
      return l.storePotPack3Subtitle;
    case 'o2_plus_4w':
      return l.storeO2Plus4wSubtitle;
    default:
      return '';
  }
}

/// Categorías del filtro. "O2+" no se traduce: es el nombre del producto.
String storeCategoryLabel(BuildContext context, String key) {
  final l = AppLocalizations.of(context)!;
  switch (key) {
    case 'bestsellers':
      return l.storeBestsellers;
    case 'avatars':
      return l.storeAvatars;
    case 'pots':
      return l.storePots;
    default:
      return key;
  }
}
