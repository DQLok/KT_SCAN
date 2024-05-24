String removeVietnameseAccent(String text) {
  return text
      .replaceAll(RegExp(r'[àáâãåǻāăąǎαάảạầấẫẩậằắẵẳặа]'), 'a')
      .replaceAll(RegExp(r'[èéêëēĕėęěẽẻẹềếễểệе]'), 'e')
      .replaceAll(RegExp(r'[ìíîïĩīĭǐįıỉịї]'), 'i')
      .replaceAll(RegExp(r'[òóôõōŏǒőơøǿοόỏọồốỗổộờớỡởợо]'), 'o')
      .replaceAll(RegExp(r'[ùúûũūŭůűųưǔǖǘǚǜủụừứữửự]'), 'u')
      .replaceAll(RegExp(r'[ýÿŷỳỹỷỵ]'), 'y')
      .replaceAll(RegExp(r'[đ]'), 'd')
      .replaceAll(RegExp(r'[ÀÁÂÃÄÅǺĀĂĄǍΑΆẢẠẦẪẨẬẰẮẴẲẶА]'), 'A')
      .replaceAll(RegExp(r'[ÈÉÊËĒĔĖĘĚΕΈẼẺẸỀẾỄỂỆЕ]'), 'E')
      .replaceAll(RegExp(r'[ÌÍÎÏĨĪĬǏĮİΊΙΪỈỊ]'), 'I')
      .replaceAll(RegExp(r'[ÒÓÔÕŌŎǑŐƠØǾΟΌỎỌỒỐỖỔỘỜỚỠỞỢО]'), 'O')
      .replaceAll(RegExp(r'[ÙÚÛŨŪŬŮŰŲƯǓǕǗǙǛŨỦỤỪỨỮỬỰ]'), 'U')
      .replaceAll(RegExp(r'[ÝŸŶΥΎΫỲỸỶỴ]'), 'Y')
      .replaceAll(RegExp(r'[Đ]'), 'D')
      .replaceAll(RegExp(r'ĹĻĽĿŁ'), 'L')
      .replaceAll(RegExp(r'ĺļľŀł'), 'l')
      .replaceAll(RegExp(r'ÇĆĈĊČ'), 'C')
      .replaceAll(RegExp(r'çćĉċč'), 'c');
}

String removeChartGetOnlyNumber(String text) {
  return text.replaceAll(RegExp(r'\D'), '');
}
