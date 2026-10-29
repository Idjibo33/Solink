/// Formatte une date pour l'affichage : `jj/MM/aaaa`.
///
/// Le formatage ne depend d'aucun backend : les dates sont stockees en
/// `DateTime` dans les modeles.
String formatTimestamp(DateTime? timestamp) {
  if (timestamp == null) {
    return '';
  }
  final day = timestamp.day.toString().padLeft(2, '0');
  final month = timestamp.month.toString().padLeft(2, '0');
  return '$day/$month/${timestamp.year}';
}
