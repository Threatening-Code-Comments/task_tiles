import 'package:flutter/material.dart';

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
    print("halllo bewegegunge");

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

          _stroke_color = (isFree()) ? Colors.amber : Colors.blueAccent;

          print("halllo bewegegunge");

          tile.tempBounds = tile.bounds;
          tile.tempBounds!.moveToPoint(_coordinate, _width);
        });
      },
      onLeave: (data) {
        setState(() {
          _stroke_color = Colors.transparent;
        });
      },
      onAccept: (data) => setState(() {
        //animateColor();
        setState(() {
          _stroke_color = Colors.transparent;
        });
        data.bounds.moveToPoint(_coordinate, _width);
      }),
    );
  }
}
