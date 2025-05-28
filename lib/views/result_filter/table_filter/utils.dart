bool fuzzyMatchToTongCong(String input) {
  final normalized = removeVietnameseDiacritics(input.toLowerCase());
  final distance = levenshtein(normalized, 'tong cong');
  return distance <= 2;
}

bool fuzzyMatchToStt(String input) {
  final normalized = removeVietnameseDiacritics(input.toLowerCase());
  final distance = levenshtein(normalized, 'stt');
  return distance <= 1;
}

List<List<String>> extractSectionBetweenRows({
  required List<List<String>> table,
  required bool Function(String) isStart,
  required bool Function(String) isEnd,
}) {
  int startIndex =
      table.indexWhere((row) => row.isNotEmpty && isStart(row.first));
  int endIndex = table.indexWhere((row) => row.isNotEmpty && isEnd(row.first));

  // Nếu không tìm thấy 1 trong 2, trả về rỗng
  if (startIndex == -1 || endIndex == -1 || endIndex < startIndex) return [];

  return table.sublist(startIndex, endIndex + 1); // lấy cả start và end
}

//formula------------
int levenshtein(String s, String t) {
  if (s == t) return 0;
  if (s.isEmpty) return t.length;
  if (t.isEmpty) return s.length;

  List<List<int>> dp = List.generate(
    s.length + 1,
    (_) => List<int>.filled(t.length + 1, 0),
  );

  for (int i = 0; i <= s.length; i++) {
    dp[i][0] = i;
  }
  for (int j = 0; j <= t.length; j++) {
    dp[0][j] = j;
  }

  for (int i = 1; i <= s.length; i++) {
    for (int j = 1; j <= t.length; j++) {
      int cost = s[i - 1] == t[j - 1] ? 0 : 1;
      dp[i][j] = [
        dp[i - 1][j] + 1, // xóa
        dp[i][j - 1] + 1, // chèn
        dp[i - 1][j - 1] + cost // thay thế
      ].reduce((a, b) => a < b ? a : b);
    }
  }

  return dp[s.length][t.length];
}

String removeVietnameseDiacritics(String str) {
  const withDiacritics = 'ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚÝàáâãèéêìíòóôõùúýĂăĐđĨĩŨũƠơƯưẠ-ỹ';
  const withoutDiacritics = 'AAAAEEEIIOOOOUUYaaaaeeeiiioooouuyAaDdIiUuOoUuA-y';

  String result = str;
  for (int i = 0;
      i < withDiacritics.length && i < withoutDiacritics.length;
      i++) {
    result = result.replaceAll(withDiacritics[i], withoutDiacritics[i]);
  }
  return result;
}