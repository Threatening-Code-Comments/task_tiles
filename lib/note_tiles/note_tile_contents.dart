import 'package:flutter/material.dart';
import 'package:task_tiles/tile.dart';

import '../pages/tile_settings_page.dart';
import 'note_tile.dart';

class NoteTileContents extends StatefulWidget {
  const NoteTileContents({super.key, required this.tile});
  final Tile tile;

  @override
  State<NoteTileContents> createState() => _NoteTileContentsState();
}

class _NoteTileContentsState extends State<NoteTileContents> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TileSettingsPage(tile: widget.tile)),
            ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                NoteTileTitle(tile: widget.tile),
                const Divider(),
                NoteTileText(tile: widget.tile),
              ],
            )));
  }
}

class NoteTileTitle extends StatefulWidget {
  const NoteTileTitle({super.key, required this.tile});

  final Tile tile;

  @override
  State<NoteTileTitle> createState() => _NoteTileTitleState();
}

class _NoteTileTitleState extends State<NoteTileTitle> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      widget.tile.title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineSmall,
    ));
  }
}

class NoteTileText extends StatefulWidget {
  const NoteTileText({super.key, required this.tile});

  final Tile tile;

  @override
  State<NoteTileText> createState() => _NoteTileTextState();
}

class _NoteTileTextState extends State<NoteTileText> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        widget.tile.text,
      ),
    );
  }
}
