class DiceFormula {
  static double compareTwoStrings(String? first, String? second) {
    if (first == null && second == null) {
      return 1;
    }
    if (first == null || second == null) {
      return 0;
    }

    first =
        first.replaceAll(RegExp(r'\s+\b|\b\s'), ''); // remove all whitespace
    second =
        second.replaceAll(RegExp(r'\s+\b|\b\s'), ''); // remove all whitespace

    if (first.isEmpty && second.isEmpty) {
      return 1;
    }
    if (first.isEmpty || second.isEmpty) {
      return 0;
    }
    if (first == second) {
      return 1;
    }
    if (first.length == 1 && second.length == 1) {
      return 0;
    }
    if (first.length < 2 || second.length < 2) {
      return 0;
    }

    final firstBigrams = <String, int>{};
    for (var i = 0; i < first.length - 1; i++) {
      final bigram = first.substring(i, i + 2);
      final count =
          firstBigrams.containsKey(bigram) ? firstBigrams[bigram]! + 1 : 1;
      firstBigrams[bigram] = count;
    }

    var intersectionSize = 0;
    for (var i = 0; i < second.length - 1; i++) {
      final bigram = second.substring(i, i + 2);
      final count =
          firstBigrams.containsKey(bigram) ? firstBigrams[bigram]! : 0;

      if (count > 0) {
        firstBigrams[bigram] = count - 1;
        intersectionSize++;
      }
    }

    return (2.0 * intersectionSize) / (first.length + second.length /*-2*/);
  }

  static BestMatch findBestMatch(
      String? mainString, List<String?> targetStrings) {
    final ratings = <Rating>[];
    var bestMatchIndex = 0;

    for (var i = 0; i < targetStrings.length; i++) {
      final currentTargetString = targetStrings[i];
      final currentRating = compareTwoStrings(mainString, currentTargetString);
      ratings.add(Rating(target: currentTargetString, rating: currentRating));
      if (currentRating > ratings[bestMatchIndex].rating!) {
        bestMatchIndex = i;
      }
    }

    final bestMatch = ratings[bestMatchIndex];

    return BestMatch(
        ratings: ratings, bestMatch: bestMatch, bestMatchIndex: bestMatchIndex);
  }

  static double maxRating(String? mainString, List<String?> targetStrings) {
    List<Rating> listRating = findBestMatch(mainString, targetStrings).ratings;
    listRating.sort(
      (a, b) => b.rating!.compareTo(a.rating!),
    );
    return listRating.first.rating ?? 0;
  }
}

class BestMatch {
  BestMatch(
      {required this.ratings,
      required this.bestMatch,
      required this.bestMatchIndex});
  List<Rating> ratings;
  Rating bestMatch;
  int bestMatchIndex;

  @override
  String toString() => '$bestMatchIndex:${bestMatch.toString()}';
}

class Rating {
  Rating({this.target, this.rating});
  String? target;
  double? rating;

  @override
  String toString() => '\'$target\'[$rating]';
}

//link study: https://github.com/jeremylandon/string-similarity/blob/master/lib/src/models/rating.dart#L2