import 'package:flutter/material.dart';
import 'package:frontend_eco_2/l10n/app_localizations.dart';
import 'package:frontend_eco_2/models/models.dart';

/// Pie de las tarjetas de "añadir planta".
///
/// Estaba escrito a mano en dos sitios como `[N macetas de 10 gratis]`: en
/// español fijo, con el 10 en duro y sin mirar el plan, así que seguía
/// anunciando el tope gratuito a quien había alquilado una maceta, comprado el
/// pack o pagado O2+. El número sale ahora del plan y el texto del idioma.
String potsCaption(BuildContext context, PlanStatus status, int plantCount) {
  final l = AppLocalizations.of(context)!;
  final limit = status.plantsLimit;
  if (status.isPlusActive || limit == null) return l.potsUnlimited;
  return l.potsUsedOfLimit(plantCount, limit);
}
