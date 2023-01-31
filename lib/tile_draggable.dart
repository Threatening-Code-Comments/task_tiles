import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:task_tiles/provider.dart';
import 'custom_widgets.dart';
import 'note_tile.dart';
import 'tile.dart';
import 'package:flutter/material.dart';

class DraggableNoteTile extends StatefulWidget {
  const DraggableNoteTile({super.key, required this.tile});

  final Tile tile;

  @override
  State<DraggableNoteTile> createState() => _DraggableNoteTileState();
}

class _DraggableNoteTileState extends State<DraggableNoteTile> {
  @override
  Widget build(BuildContext context) {
    var tile = widget.tile;

    return LongPressDraggable<Tile>(
      data: tile,
      feedback: DragFeedbackNoteTile(tile: tile),
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
      onDragCompleted: () => setState(() {
        tile.enabled = true;

        Provider.of<IgnorePointerProvider>(context, listen: false)
            .setIgnore(true);
      }),
      child: NoteTile(tile: tile),
    );
  }
}

class DragFeedbackNoteTile extends StatelessWidget {
  const DragFeedbackNoteTile({super.key, required this.tile});

  final Tile tile;

  @override
  Widget build(BuildContext context) {
    var bounds = tile.bounds;

    return SizedCard(
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
        )));
  }
}
