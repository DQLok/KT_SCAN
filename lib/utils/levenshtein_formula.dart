import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class LevenshteinFormula<Value> {
  final int limit;
  final bool caseSensitive;
  List<InputEntry<Value>> _entries = [];

  final Levenshtein _levenshtein = Levenshtein();

  LevenshteinFormula({this.limit = 10, this.caseSensitive = false}) {
    assert(limit > 0, 'limit need to be greater than zero');
  }

  void addEntry(String text, {Value? value}) {
    _entries.add(
        InputEntry<Value>(text, value: value, caseSensitive: caseSensitive));
  }

  void addEntries(List<String> texts) {
    _entries.addAll(
        texts.map((e) => InputEntry<Value>(e, caseSensitive: caseSensitive)));
  }

  void setEntries(List<String> texts) {
    _entries = texts
        .map((e) => InputEntry<Value>(e, caseSensitive: caseSensitive))
        .toList();
  }

  List<MatchResult<Value>> search(String query) {
    var heapPQ = HeapPriorityQueue<MatchResult<Value>>(
        (lhs, rhs) => lhs.score.compareTo(rhs.score));

    for (var entry in _entries) {
      final bestScore = entry.words.fold<double>(0.0, (currentScore, word) {
        final distance = _levenshtein.distance(query, word);
        final maxLength = max(query.length, word.length);
        final score = (maxLength - distance) / maxLength;
        return max<double>(currentScore, score);
      });

      heapPQ.add(MatchResult(bestScore, text: entry.text, value: entry.value));

      if (heapPQ.length > limit) {
        heapPQ.removeFirst();
      }
    }

    final result = heapPQ.toList();
    result.sort((a, b) => b.score.compareTo(a.score));
    return result;
  }

  static double maxRating(String mainString, List<String> targetStrings) {
    LevenshteinFormula levenshteinFormula = LevenshteinFormula();
    levenshteinFormula.setEntries(targetStrings);
    List<MatchResult<dynamic>> listValue =
        levenshteinFormula.search(mainString);
    listValue.sort(
      (a, b) => b.score.compareTo(a.score),
    );
    return listValue.first.score;
  }
}

class Levenshtein {
  int length1;
  int length2;
  late List<List<int>> _dp;

  Levenshtein()
      : length1 = 10,
        length2 = 10 {
    _resizeDPArray(length1, length2);
  }

  void _resizeDPArray(int length1, int length2) {
    if (this.length1 > length1 && this.length2 > length2) {
      return;
    }

    length1 = max(this.length1, length1);
    length2 = max(this.length2, length2);

    _dp = List.generate(
        length1 + 1, (i) => List.filled(length2 + 1, 0, growable: false),
        growable: false);

    for (var k = 0; k < length1 + 1; k++) {
      _dp[k][0] = k;
    }
    for (var k = 0; k < length2 + 1; k++) {
      _dp[0][k] = k;
    }

    this.length1 = length1;
    this.length2 = length2;
  }

  int distance(String word1, String word2) {
    _resizeDPArray(word1.length, word2.length);

    for (var i = 0; i < word1.length; i++) {
      for (var j = 0; j < word2.length; j++) {
        _dp[i + 1][j + 1] = min(_dp[i][j + 1], _dp[i + 1][j]) + 1;
        if (word1[i] == word2[j]) {
          _dp[i + 1][j + 1] = min(_dp[i][j], _dp[i + 1][j + 1]);
        } else {
          _dp[i + 1][j + 1] = min(_dp[i][j] + 1, _dp[i + 1][j + 1]);
        }
      }
    }

    return _dp[word1.length][word2.length];
  }
}

class MatchResult<Value> {
  final double score;
  final String text;
  final Value? value;

  MatchResult(this.score, {required this.text, required this.value});

  @override
  String toString() {
    final textAndScore = 'text: $text, score: ${score.toStringAsFixed(2)}';
    if (value != null) {
      return '$textAndScore, value: $value';
    } else {
      return textAndScore;
    }
  }
}

class InputEntry<Value> {
  final String text;
  final Value? value;
  late List<String> _words;
  List<String> get words => _words;

  InputEntry(this.text, {this.value, required bool caseSensitive}) {
    _words = text.split(' ');
    if (!caseSensitive) {
      _words = _words.map((word) => word.toLowerCase()).toList();
    }
  }
}

//link study: https://github.com/IvoriApp/woozy-search/blob/master/lib/src/Woozy.dart