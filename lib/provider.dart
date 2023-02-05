import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
export 'package:provider/provider.dart';
import 'package:task_tiles/tile.dart';

class LayoutParams with ChangeNotifier {
  int _width = 3;

  int get width => _width;

  void regenerate(BuildContext context) {
    var width = MediaQuery.of(context).size.width ~/ 100;
    setWidth(width);
  }

  void setWidth(int width) {
    _width = width;
    notifyListeners();
  }
}

class IgnorePointerProvider with ChangeNotifier {
  bool _ignore = true;

  bool get ignore => _ignore;

  void toggle() {
    setIgnore(!_ignore);
  }

  void setIgnore(bool value) {
    _ignore = value;
    notifyListeners();
  }
}

class NoteTiles with ChangeNotifier {
  NoteTiles({List<Tile>? tiles}) : _tiles = tiles ?? [];

  final List<Tile> _tiles;

  UnmodifiableListView<Tile> get tiles => UnmodifiableListView(_tiles);

  final Map<Point, Tile> _tileMap = {};
  Map<Point, Tile> get tileMap =>
      (!_tileMapIsInvalid) ? _tileMap : refreshTileMap();
  bool _tileMapIsInvalid = false;

  int get maxY =>
      _tiles.reduce((curr, next) => curr.maxY > next.maxY ? curr : next).maxY;

  // refresh tileMap and notify listeners
  Map<Point, Tile> refreshTileMap() {
    _tileMap.clear();
    for (var tile in _tiles) {
      for (var x in tile.bounds.x.asIterable) {
        for (var y in tile.bounds.y.asIterable) {
          _tileMap[Point(x, y)] = tile;
        }
      }
    }

    _tileMapIsInvalid = false;
    return _tileMap;
  }

  void _notify() {
    _tileMapIsInvalid = true;

    notifyListeners();
  }

  void addTile(Tile tile) {
    _tiles.add(tile);
    _notify();
  }

  void remove(Tile tile) {
    _tiles.remove(tile);
    _notify();
  }

  void notify() => _notify();

  void updateTiles(List<Tile> newTiles, {Tile? blockingTile}) {
    //debug
    var before = _tiles;

    //mark old tiles for deletion
    var tilesToRemove = <Tile>{};

    for (var tile in _tiles) {
      if (!newTiles.contains(tile)) tilesToRemove.add(tile);
    }

    //apply changes
    for (var tile in newTiles) {
      if (!_tiles.contains(tile)) _tiles.add(tile);
    }
    for (var tile in tilesToRemove) {
      _tiles.remove(tile);
    }

    // _tiles.clear();
    // _tiles.addAll(newTiles);

    if (blockingTile != null && !_tiles.contains(blockingTile)) {
      _tiles.add(blockingTile);
    }

    _notify();
  }

  void clear() => _tiles.clear;

  addAll(List<Tile> tiles) => _tiles.addAll(tiles);

  void rebuild(List<Tile> list) {
    _tiles.clear();
    _tiles.addAll(list);

    _notify();
  }
}
