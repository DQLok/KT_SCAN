class TextGroup {
  String index;
  ConrnerPoints conrnerPoints;
  String text;

  TextGroup(
      {required this.index, required this.conrnerPoints, required this.text});
  
  factory TextGroup.fromJson(Map<String, dynamic> json) => TextGroup(
        index: json["index"],
        conrnerPoints: ConrnerPoints.fromJson(json["conrnerPoints"]),
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "index": index,
        "conrnerPoints": conrnerPoints,
        "text": text,
      };

  @override
  String toString() {
    return "$index: ${conrnerPoints.toString()}";
  }
}

class ConrnerPoints {
  Point pointLT;
  Point pointRT;
  Point pointRB;
  Point pointLB;

  ConrnerPoints(
      {required this.pointLT,
      required this.pointRT,
      required this.pointRB,
      required this.pointLB});

  factory ConrnerPoints.fromJson(Map<String, dynamic> json) => ConrnerPoints(
        pointLT: Point.fromJson(json["pointLT"]),
        pointRT: Point.fromJson(json["pointRT"]),
        pointRB: Point.fromJson(json["pointRB"]),
        pointLB: Point.fromJson(json["pointLB"]),
      );

  Map<String, dynamic> toJson() => {
        "pointLT": pointLT,
        "pointRT": pointRT,
        "pointRB": pointRB,
        "pointLB": pointLB,
      };

  @override
  String toString() {
    return "[$pointLT, $pointRT, $pointRB, $pointLB]";
  }
}

class Point {
  int x;
  int y;

  Point({this.x = 0, this.y = 0});

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
      };
}

Point comparePointLeft(Point pointDefault, Point pointLT, Point pointLB) {
  Point point = pointDefault;
  if (point.x >= pointLT.x) {
    point = pointLT;
  }
  if (point.x >= pointLB.x) {
    point = pointLB;
  }
  return point;
}

Point comparePointRight(Point pointDefault, Point pointRT, Point pointRB) {
  Point point = pointDefault;
  if (point.x <= pointRT.x) {
    point = pointRT;
  }
  if (point.x <= pointRB.x) {
    point = pointRB;
  }
  return point;
}

Point comparePointTop(Point pointDefault, Point pointLT, Point pointRT) {
  Point point = pointDefault;
  if (point.y >= pointLT.y) {
    point = pointLT;
  }
  if (point.y >= pointRT.y) {
    point = pointRT;
  }
  return point;
}

Point comparePointBottom(Point pointDefault, Point pointLB, Point pointRB) {
  Point point = pointDefault;
  if (point.y <= pointLB.y) {
    point = pointLB;
  }
  if (point.y <= pointRB.y) {
    point = pointRB;
  }
  return point;
}

//-------------------------------------------------
class KeyValueFilter {
  TextGroup keyTG;
  List<TextGroup> valueTG;

  KeyValueFilter({required this.keyTG, required this.valueTG});

  sortListValueTG() {
    valueTG.sort(
      (a, b) => a.conrnerPoints.pointLT.x.compareTo(b.conrnerPoints.pointLT.x),
    );
  }

  factory KeyValueFilter.fromJson(Map<String, dynamic> json) => KeyValueFilter(
        keyTG: TextGroup.fromJson(json["keyTG"]),
        valueTG: List<TextGroup>.from(json["valueTG"].map((x) => TextGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "keyTG": keyTG,
        "valueTG": List<dynamic>.from(valueTG.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return "${keyTG.index}: ${valueTG.toString()}";
  }
}
