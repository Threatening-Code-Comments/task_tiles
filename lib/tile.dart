import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class Tile {
  String name;

  Tile({required this.name, bool? enabled, bool? isVisible, Bounds? bounds})
      : id = Random().nextInt(999999), //const Uuid().v1().toString(),
        enabled = enabled ?? true,
        isVisible = isVisible ?? true,
        bounds = bounds ?? Bounds.empty();

  Tile.withSizes(
      {required String name,
      required int xStart,
      required int yStart,
      required int width,
      required int height})
      : this(
            name: name,
            bounds: Bounds.fromSizes(
              xStart: xStart,
              width: width,
              yStart: yStart,
              height: height,
            ));

  String title = "";

  final int id;

  bool enabled;
  bool isVisible;

  Bounds bounds;
  Bounds? tempBounds;

  int get maxY => tempBounds?.y.to ?? bounds.y.to;

  Tile.empty()
      : name = '',
        id = 0,
        enabled = true,
        isVisible = true,
        bounds = Bounds.empty();

  static Tile random() {
    String randomName = "";
    var wordPairs = generateWordPairs().take(1);

    for (WordPair wordPair in wordPairs) {
      randomName = "$randomName $wordPair";
    }

    return Tile(name: randomName);
  }

  @override
  String toString() {
    return "$name (${id})";
  }

  static final emptyTile = Tile.empty();

  void moveTempBoundsDown({required int amount}) {
    //if tempBounds null, assign bounds
    tempBounds ??= bounds;
    var tempB = tempBounds!;

    Point start = Point(
      tempB.x.from,
      (tempB.y.from + amount),
    );

    tempBounds?.moveToPoint(start, 3);
  }

  State? widgetState;
}

class Bounds {
  Bounds({required this.x, required this.y});

  Bounds.empty() : this(x: Range.empty(), y: Range.empty());

  Bounds.fromSizes(
      {required int xStart,
      required int width,
      required int yStart,
      required int height})
      : this(
          x: Range.fromSize(from: xStart, size: width),
          y: Range.fromSize(from: yStart, size: height),
        );

  Range x;
  Range y;

  int get width => x.size;
  int get height => y.size;

  void moveToPoint(Point point, int maxWidth) =>
      moveTo(point.x.toInt(), point.y.toInt(), maxWidth);

  void moveTo(int xStartParam, int yStart, int maxWidth) {
    var xStart = xStartParam;

    if (xStart + x.size > maxWidth) xStart = maxWidth - x.size;
    var newX = Range(xStart, xStart + x.size);
    x = newX;

    var newY = Range(yStart, yStart + y.size);
    y = newY;
  }

  bool isIn(int x, int y) {
    return (this.x.contains(x) && this.y.contains(y));
  }

  bool get hasPosition {
    var empty = Range.empty();

    return x == empty && y == empty;
  }

  Range getRow(int y) {
    if (!this.y.contains(y)) return Range.empty();

    return Range.fromRange(x);
  }

  @override
  String toString() {
    return 'x:${x.from}..${x.to}|y:${y.from}..${y.to}';
  }
}

class Range {
  Range(this.from, this.to)
      : asSet = {for (int i = from; i <= to; i++) i},
        size = (from - to).abs();

  Range.empty() : this(-1, -1);
  Range.fromRange(Range range) : this(range.from, range.to);

  final int from;
  final int to;

  final int size;

  final Set<int> asSet;

  ///[from..(from+1).. (from+n) ..(to - 1)]
  ///ex: this = 2..5
  ///    returns [2, 3, 4]
  Iterable get asIterable {
    return [for (int i = from; i < to; i++) i];
  }

  bool contains(int i) {
    return asSet.contains(i);
  }

  @override
  String toString() {
    return '$from..$to';
  }

  ///Constructor for using width or height. Argument size defaults to 1.
  Range.fromSize({required int from, int? size})
      : this(from, from + (size ?? 1));
}

class Point {
  const Point(this.x, this.y);

  final int x;
  final int y;
}
