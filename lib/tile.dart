import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:task_tiles/tile_move_algo.dart';

class Tile {
  String name;

  Tile(
      {int? id,
      required this.name,
      bool? enabled,
      bool? isVisible,
      Bounds? bounds})
      : id = id ?? Random().nextInt(999999), //const Uuid().v1().toString(),
        enabled = enabled ?? true,
        isVisible = isVisible ?? true,
        bounds = bounds ?? Bounds.empty();

  Tile.copy(Tile tile)
      : id = tile.id, //const Uuid().v1().toString(),
        enabled = tile.enabled,
        isVisible = tile.isVisible,
        name = tile.name,
        bounds = Bounds.fromBounds(tile.bounds),
        tempBounds = tile.tempBounds != null
            ? Bounds.fromBounds(tile.tempBounds!)
            : null;

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

  Tile.move(
      {required Tile origin, required Direction dir, required num amountMoved})
      : this(
          id: origin.id,
          name: origin.name,
          bounds: Bounds.fromBounds(origin.bounds)
            ..move(dir, amountMoved), //move bounds in constructor
          enabled: origin.enabled,
          isVisible: origin.isVisible,
        );
}

class Bounds {
  Bounds({required this.x, required this.y});

  Bounds.empty() : this(x: Range.empty(), y: Range.empty());

  Bounds.fromBounds(Bounds bounds)
      : this(x: Range.fromRange(bounds.x), y: Range.fromRange(bounds.y));

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

  bool overlaps(Bounds other) {
    if (x.to <= other.x.from ||
        x.from >= other.x.to ||
        y.to <= other.y.from ||
        y.from >= other.y.to) {
      return false;
    }
    return true;
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

  void move(Direction dir, num amountMoved) {
    assert(amountMoved < double.infinity);

    int amount = amountMoved.toInt();

    var width = x.size;
    var height = y.size;

    switch (dir) {
      case Direction.D:
        y = Range.fromOffset(y, amount);
        break;
      case Direction.U:
        y = Range.fromOffset(y, -amount);
        break;

      case Direction.L:
        x = Range.fromOffset(x, -amount);
        break;

      case Direction.R:
        x = Range.fromOffset(x, amount);
        break;

      default:
    }
  }
}

class Range {
  Range(this.from, this.to)
      : asSet = {for (int i = from; i <= to; i++) i},
        size = (from - to).abs();

  Range.empty() : this(-1, -1);
  Range.fromRange(Range range) : this(range.from, range.to);
  Range.fromOffset(Range range, int offset)
      : this(range.from + offset, range.to + offset);

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
