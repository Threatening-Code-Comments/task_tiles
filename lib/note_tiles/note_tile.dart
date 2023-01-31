import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:task_tiles/pages/tile_settings_page.dart';
import 'package:task_tiles/provider.dart';
import 'package:task_tiles/tile.dart';

import 'note_tile_contents.dart';
import 'tile_draggable.dart';
export 'tile_draggable.dart';

import '../custom_widgets.dart';

class NoteTile extends StatefulWidget {
  const NoteTile({super.key, required this.tile});

  final Tile tile;

  @override
  State<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends State<NoteTile> {
  @override
  Widget build(BuildContext context) {
    return (widget.tile.enabled)
        ? EnabledNoteTile(tile: widget.tile)
        : DisabledNoteTile(tile: widget.tile);
  }
}

class EnabledNoteTile extends StatefulWidget {
  const EnabledNoteTile({super.key, required this.tile});

  final Tile tile;

  @override
  State<EnabledNoteTile> createState() => _EnabledNoteTileState();
}

class _EnabledNoteTileState extends State<EnabledNoteTile> {
  @override
  Widget build(BuildContext context) {
    return SizedCard(
        cornerRadius: 10,
        stroke: null,
        strokeWidth: null,
        child: NoteTileContents(tile: widget.tile));
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
        stroke: Theme.of(context).colorScheme.primary,
        strokeWidth: 4,
        enabled: false,
        child: NoteTileContents(tile: tile));
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
