import 'dart:math';

import 'package:flutter/material.dart';
import 'package:task_tiles/provider.dart';

import 'tile.dart';

//Algo Klasse => {bool success; Map<Tile, Point> result}

enum Direction {
  D(0),
  R(1),
  L(2),
  U(3);

  final num value;
  const Direction(this.value);
}

class MoveAlgorythm {
  bool succ = true;
  List<Tile> movedTiles = [];
  num distance = double.infinity;

  List<Tile> tiles;
  Tile blockingTile;

  int gridWidth;

  MoveAlgorythm(
      {required this.tiles,
      required this.blockingTile,
      required this.gridWidth}) {
    // Integer[Direction] previousValues
    Map<Direction, num> previousValues = {
      Direction.U: 0,
      Direction.D: 0,
      Direction.L: 0,
      Direction.R: 0
    };
    // List<Tile>[Direction] previousTiles => alles leere Listen by default
    Map<Direction, List<Tile>> previousTiles = {
      Direction.U: [],
      Direction.D: [],
      Direction.L: [],
      Direction.R: []
    };

    for (var tile in tiles) {
      tile.tempBounds = null;
    }

    for (int i = 0; i < tiles.length; i++) {
      Map<Direction, num> nextValues = {};
      Map<Direction, List<Tile>> nextTiles = {};

      for (var dir in Direction.values) {
        List<Tile> bestNewTiles = [];
        num bestMovement = double.infinity;

        //        // Wir suchen uns für diese Direction den besten Vorgänger
        for (var prevDir in Direction.values) {
          var movement = howMuchDoINeedToMoveThisTileIn(
              dir, tiles[i], previousTiles[prevDir]!);
          var totalMovement = (previousValues[prevDir] ?? 0) + movement;

          if (totalMovement <= bestMovement) {
            bestMovement = totalMovement;
            bestNewTiles = List.from(previousTiles[prevDir]!);
            bestNewTiles.add(Tile.move(
              origin: tiles[i],
              dir: dir,
              amountMoved: movement == double.infinity ? 0 : movement,
            ));
          }
        }
        nextValues[dir] = bestMovement;
        nextTiles[dir] = bestNewTiles.toList();
      }
      previousValues = nextValues;
      previousTiles = nextTiles;
    }
    // jetzt minimum aus nextValues finden. Wenn alles Infinity dann lass es brudi

    Direction? minIndex;
    for (var dir in Direction.values) {
      if (minIndex == null ||
          previousValues[dir]! < previousValues[minIndex]!) {
        minIndex = dir;
      }
    }

    movedTiles = previousTiles[minIndex]!;
    distance = previousValues[minIndex]!;
    succ = previousValues[minIndex]! < double.infinity;
  }

  num howMuchDoINeedToMoveThisTileIn(
      Direction dir, Tile tileToMove, List<Tile> otherTiles) {
    int iterations = 0;
    Tile tile = Tile.copy(tileToMove);
    var tileToMoveBounds = tile.tempBounds;

    while (hasCollision(tile, otherTiles)) {
      iterations++;
      tile = Tile.move(origin: tile, dir: dir, amountMoved: 1);
      tileToMoveBounds = tile.tempBounds;
      if (tileToMoveBounds.x.from < 0 ||
          tileToMoveBounds.y.from < 0 ||
          tileToMoveBounds.x.to > gridWidth) {
        return double.infinity; // Out of screen bounds
      }
    }

    return iterations;
  }

  bool hasCollision(Tile tile, List<Tile> otherTiles) {
    //start debug
    // var x = [tile.tempBounds.x.from, tile.tempBounds.x.to];
    // if (x.any((element) => element > 3)) throw Exception("maxX must not be >3");

    // if (x.any((element) => element < 0)) throw Exception("minX must be > 0");

    var b = tile.tempBounds;
    if (b.x.from < 0 || b.x.to > gridWidth || b.y.from < 0) return true;

    //end debug

    if (tile.tempBounds.overlaps(blockingTile.tempBounds)) {
      return true;
    }

    for (Tile otherTile in otherTiles) {
      if (tile.tempBounds.overlaps(otherTile.tempBounds)) {
        return true;
      }
    }

    return false;
  }
}
