/// Conversions de dates utilisees par la serialisation JSON des modeles.
///
/// Les modeles ne dependent d'aucun backend : ils stockent des `DateTime`,
/// et chaque adaptateur de backend se charge de traduire ce format vers
/// le sien (timestamp Firestore, ISO-8601, epoch, ...).
library;

/// Convertit une valeur JSON en date UTC.
///
/// Toutes les dates sont normalisees en UTC : la serialisation ecrit de
/// l'ISO-8601 en UTC, la lecture fait donc de meme. Cela garantit un
/// aller-retour stable, independamment du fuseau horaire de l'appareil.
DateTime dateTimeFromJson(Object? value) {
  if (value is DateTime) {
    return value.toUtc();
  }
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
  }
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return parsed.toUtc();
    }
  }
  return DateTime.now().toUtc();
}

Object dateTimeToJson(DateTime value) => value.toUtc().toIso8601String();

/// Formatte une date pour l'affichage : `jj/MM/aaaa`.
String formatDate(DateTime? date) {
  if (date == null) {
    return '';
  }
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
