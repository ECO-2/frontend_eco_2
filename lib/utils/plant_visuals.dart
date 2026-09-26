import 'package:flutter/material.dart';

/// Visual theme (icon + colors) for a plant category. There are no real
/// per-species photos in the database, so instead of a single generic
/// placeholder for every species we give each botanical category its own
/// deliberate icon/color — an honest illustration, not a fake photo.
class PlantCategoryVisual {
  final IconData icon;
  final Color color;
  final Color background;

  const PlantCategoryVisual({
    required this.icon,
    required this.color,
    required this.background,
  });
}

const Map<String, PlantCategoryVisual> _kCategoryVisuals = {
  'tropical': PlantCategoryVisual(
    icon: Icons.park_rounded,
    color: Color(0xFF2E7D32),
    background: Color(0xFFEAF5EA),
  ),
  'succulent': PlantCategoryVisual(
    icon: Icons.spa_rounded,
    color: Color(0xFF8D8741),
    background: Color(0xFFF5F2E0),
  ),
  'cactus': PlantCategoryVisual(
    icon: Icons.grass_rounded,
    color: Color(0xFFC08A3E),
    background: Color(0xFFF7EFDE),
  ),
  'fern': PlantCategoryVisual(
    icon: Icons.eco_rounded,
    color: Color(0xFF1B5E20),
    background: Color(0xFFE6F0E6),
  ),
  'flowering': PlantCategoryVisual(
    icon: Icons.local_florist_rounded,
    color: Color(0xFFC2185B),
    background: Color(0xFFFBEAF1),
  ),
  'herb': PlantCategoryVisual(
    icon: Icons.yard_rounded,
    color: Color(0xFF558B2F),
    background: Color(0xFFEEF3E2),
  ),
  'tree': PlantCategoryVisual(
    icon: Icons.forest_rounded,
    color: Color(0xFF33691E),
    background: Color(0xFFE8F0DE),
  ),
  'other': PlantCategoryVisual(
    icon: Icons.local_florist_outlined,
    color: Color(0xFF10454F),
    background: Color(0xFFF0F4F2),
  ),
};

const PlantCategoryVisual _kDefaultVisual = PlantCategoryVisual(
  icon: Icons.local_florist_outlined,
  color: Color(0xFF10454F),
  background: Color(0xFFF0F4F2),
);

PlantCategoryVisual visualForCategory(String? category) {
  if (category == null) return _kDefaultVisual;
  return _kCategoryVisuals[category.toLowerCase()] ?? _kDefaultVisual;
}






/// Kind of tag chip, used to color-code the pill by what it represents.
enum TagKind { category, light, water, humidity, temperature, generic }

class TagStyle {
  final IconData icon;
  final Color color;
  final Color background;

  const TagStyle({required this.icon, required this.color, required this.background});
}

const Map<TagKind, TagStyle> _kTagStyles = {
  TagKind.category: TagStyle(
    icon: Icons.spa_rounded,
    color: Color(0xFF2E7D32),
    background: Color(0xFFEAF5EA),
  ),
  TagKind.light: TagStyle(
    icon: Icons.wb_sunny_rounded,
    color: Color(0xFFB8860B),
    background: Color(0xFFFBF3DE),
  ),
  TagKind.water: TagStyle(
    icon: Icons.water_drop_rounded,
    color: Color(0xFF1565C0),
    background: Color(0xFFE3F0FB),
  ),
  TagKind.humidity: TagStyle(
    icon: Icons.opacity_rounded,
    color: Color(0xFF00796B),
    background: Color(0xFFE0F2F0),
  ),
  TagKind.temperature: TagStyle(
    icon: Icons.thermostat_rounded,
    color: Color(0xFFD84315),
    background: Color(0xFFFCE9E3),
  ),
  TagKind.generic: TagStyle(
    icon: Icons.eco_rounded,
    color: Color(0xFF10454F),
    background: Color(0xFFEFF2F1),
  ),
};

TagStyle styleForTagKind(TagKind kind) => _kTagStyles[kind] ?? _kTagStyles[TagKind.generic]!;

// tagKindFor se eliminó: adivinaba el tipo del chip buscando "riego", "luz" o
// "humedad" dentro del texto visible, así que con la app en inglés ninguna
// coincidía y todos los chips salían grises. Ahora el tipo viaja en SpeciesTag.
