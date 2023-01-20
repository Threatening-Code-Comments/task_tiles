import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:task_tiles/provider.dart';
import 'package:task_tiles/tile.dart';

import 'custom_widgets.dart';

class NoteTile extends StatefulWidget {
  const NoteTile({super.key, required this.tile});

  final Tile tile;

  @override
  State<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  @override
  Widget build(BuildContext context) {
    var tile = widget.tile;
    var bounds = tile.tempBounds ?? tile.bounds;
    var x = bounds.x;
    var y = bounds.y;

    var stroke = (tile.enabled) ? null : Theme.of(context).colorScheme.primary;
    double? strokeWidth = (tile.enabled) ? null : 4;

    return GridPlacement(
      columnStart: x.from,
      columnSpan: x.size,
      rowStart: y.from,
      rowSpan: y.size,
      child: LongPressDraggable<Tile>(
        feedback: SizedCard(
            height: (100 * bounds.height).toDouble(),
            width: (100 * bounds.width).toDouble(),
            child: Center(
                child: Column(
              children: [
                const Spacer(),
                NoteTileTitle(tile: tile),
                const Icon(Icons.add_location_alt_outlined),
                const Spacer(),
              ],
            ))),
        data: tile,
        onDragStarted: () => setState(() {
          tile.enabled = false;

          Provider.of<IgnorePointerProvider>(context, listen: false)
              .setIgnore(false);
        }),
        onDragEnd: (details) => setState(() {
          tile.enabled = true;

          Provider.of<IgnorePointerProvider>(context, listen: false)
              .setIgnore(true);
        }),
        child: SizedCard(
          cornerRadius: 10,
          transparent: !tile.enabled,
          stroke: stroke,
          strokeWidth: strokeWidth,
          child: Center(
              child: Column(
            children: [
              const Spacer(),
              NoteTileTitle(tile: tile),
              const Icon(Icons.add_location_alt_outlined),
              const Spacer(),
            ],
          )),
        ),
      ),
    );
  }
}

class NoteTileTitle extends StatelessWidget {
  const NoteTileTitle({super.key, required this.tile});

  final Tile tile;

  @override
  Widget build(BuildContext context) {
    return Text(tile.title);
  }
}
