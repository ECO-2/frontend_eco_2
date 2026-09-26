import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Formato de fechas según el idioma activo.
///
/// Había cinco listas de meses en español escritas a mano, repartidas por
/// pantallas distintas (`['Ene', 'Feb', ...]`). Con la app en inglés seguían
/// mostrando "Feb"/"Ago"/"Dic", y además había que mantenerlas sincronizadas.
/// `intl` ya trae los nombres de cada locale, así que aquí solo se elige el
/// formato.

String _locale(BuildContext context) =>
    Localizations.localeOf(context).languageCode;

/// "15 feb 2026" en español, "Feb 15, 2026" en inglés.
String formatMediumDate(BuildContext context, DateTime date) =>
    DateFormat.yMMMd(_locale(context)).format(date);

/// "15 feb" — sin año, para listas donde el año se sobreentiende.
String formatDayMonth(BuildContext context, DateTime date) =>
    DateFormat.MMMd(_locale(context)).format(date);

/// "15/2/2026" — numérico y compacto.
String formatShortDate(BuildContext context, DateTime date) =>
    DateFormat.yMd(_locale(context)).format(date);

/// "septiembre 2026" / "September 2026" — para agrupar por mes.
String formatMonthYear(BuildContext context, DateTime date) =>
    DateFormat.yMMMM(_locale(context)).format(date);
