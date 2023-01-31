import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:task_tiles/provider.dart';
import 'package:task_tiles/tile.dart';

import 'tile_draggable.dart';
export 'tile_draggable.dart';

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
    if (widget.tile.enabled) {
      return EnabledNoteTile(tile: widget.tile);
    } else {
      return DisabledNoteTile(tile: widget.tile);
    }
  }
}

class NoteTileContents extends StatelessWidget {
  const NoteTileContents({super.key, required this.tile});
  final Tile tile;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Spacer(),
        NoteTileTitle(tile: tile),
        const Icon(Icons.add_location_alt_outlined),
        const Spacer(),
      ],
    ));
  }
}

class EnabledNoteTile extends StatelessWidget {
  const EnabledNoteTile({super.key, required this.tile});

  final Tile tile;

  @override
  Widget build(BuildContext context) {
    return SizedCard(
        cornerRadius: 10,
        transparent: false,
        stroke: null,
        strokeWidth: null,
        child: NoteTileContents(tile: tile));
  }
}

class DisabledNoteTile extends StatelessWidget {
  const DisabledNoteTile({super.key, required this.tile});

  final Tile tile;

  @override
  Widget build(BuildContext context) {
    if (tile.enabled) {
      print("DisabledNoteTile was created with enabled tile!\nTile: $tile");
    }

    return SizedCard(
        cornerRadius: 10,
        transparent: true,
        stroke: Theme.of(context).colorScheme.primary,
        strokeWidth: 4,
        child: NoteTileContents(tile: tile));
  }
}

class NoteTileTitle extends StatelessWidget {
  const NoteTileTitle({super.key, required this.tile});

  final Tile tile;

  @override
  Widget build(BuildContext context) {
    return Text(tile.name);
  }
}

class PlacedNoteTile extends StatefulWidget {
  const PlacedNoteTile({super.key, required this.tile});

  final Tile tile;

  @override
  State<PlacedNoteTile> createState() => _PlacedNoteTileState();
}

class _PlacedNoteTileState extends State<PlacedNoteTile> {
  @override
  Widget build(BuildContext context) {
    var tile = widget.tile;
    var bounds = tile.tempBounds;
    var x = bounds.x;
    var y = bounds.y;

    return GridPlacement(
        columnStart: x.from,
        columnSpan: x.size,
        rowStart: y.from,
        rowSpan: y.size,
        child: DraggableNoteTile(tile: widget.tile));
  }
}
