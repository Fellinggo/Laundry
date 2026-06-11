class Formatter {
  static int parseRupiahToInt(String rupiah) {
    if (rupiah.isEmpty) return 0;
    String cleaned = rupiah.replaceAll('Rp ', '').replaceAll('.', '');
    return int.tryParse(cleaned) ?? 0;
  }

  static String formatRupiah(int number) {
    final s = number.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }

  static int calculateFinalTotal(String rawTotal, bool isDummyOrder) {
    int totalNominal = parseRupiahToInt(rawTotal);
    return isDummyOrder ? totalNominal + 5000 : totalNominal;
  }
}
