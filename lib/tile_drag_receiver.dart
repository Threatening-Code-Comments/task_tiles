import 'package:flutter/material.dart';
import 'package:task_tiles/tile_move_algo.dart';

import 'custom_widgets.dart';
import 'tile.dart';
import 'note_tile.dart';
import 'provider.dart';

class TileDragReceiver extends StatefulWidget {
  const TileDragReceiver({
    super.key,
    required this.index,
    required this.ignorePointer,
  });

  final int index;
  final bool ignorePointer;

  @override
  State<TileDragReceiver> createState() => _TileDragReceiverState();
}

class _TileDragReceiverState extends State<TileDragReceiver> {
  late Point _coordinate;

  //TODO strokeColor unused
  Color _stroke_color = Colors.transparent;

  late Map<Point, Tile> tileMap;

  ///checks if current reciever has a tile associated with it
  bool isFree() {
    //gets value at coordinate and checks if it's null
    return tileMap[_coordinate] == null;
  }

  bool willAccept() {
    if (!isFree()) return false;

    // var tile = tileMap[widget.coordinate];

    // var bounds = tile.temp
    return true; // TODO left off here
  }

  @override
  Widget build(BuildContext context) {
    int _width = context.watch<LayoutParams>().width;
    tileMap = context.watch<NoteTiles>().tileMap;

    _coordinate = Point(
      //index 5 => |1, 2|
      (widget.index % _width), //5 mod 3 = 2
      (widget.index / _width).floor(), //5 / 3 = 1,66 ----floor---> 1
    );

    return DragTarget<Tile>(
      builder: (context, candidateData, rejectedData) => SizedCard(
          stroke: _stroke_color,
          transparent: true,
          enabled: true,
          cornerRadius: 10,
          strokeWidth: 4),
      onWillAccept: (data) => isFree(), //true //change? TODO
      onMove: (details) {
        setState(() {
          var tile = details.data;
          tile.tempBounds = tile.bounds;
          tile.tempBounds.moveToPoint(_coordinate, _width);

          _stroke_color = Colors
              .transparent; //(isFree()) ? Colors.amber : Colors.blueAccent;

          // -------------hier startet der algo code

          var tiles =
              Provider.of<NoteTiles>(context, listen: false).tiles.toList();
          tiles.remove(tile);
          var gridWidth =
              Provider.of<LayoutParams>(context, listen: false).width;
          var ergebnis = MoveAlgorythm(
              tiles: tiles, blockingTile: tile, gridWidth: gridWidth);
          //Algo Klasse => {bool success; Map<Tile, Point> result}

          if (ergebnis.succ) {
            Provider.of<NoteTiles>(context, listen: false)
                .updateTiles(ergebnis.movedTiles, blockingTile: tile);
          } else {
            print("FUCK FUCK FUCK INFINITY");
          }

          // -------------hier endet der algo code
        });
      },
      onLeave: (data) {
        setState(() {
          _stroke_color = Colors.transparent;
        });
      },
      onAccept: (data) => setState(() {
        //animateColor();
        _stroke_color = Colors.transparent;
        data.enabled = true;
        data.promoteTempBounds();

        // data.bounds.moveToPoint(_coordinate, _width);
        var tiles = Provider.of<NoteTiles>(context, listen: false).tiles;
        for (var tile in tiles) {
          tile.enabled = true;
          tile.promoteTempBounds();
        }

        print(tiles);

        Provider.of<NoteTiles>(context, listen: false).updateTiles(tiles);
      }),
    );
  }
}
