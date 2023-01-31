import 'package:flutter/material.dart';
import 'package:task_tiles/provider.dart';

import '../tile.dart';

class TileSettingsPage extends StatefulWidget {
  const TileSettingsPage({super.key, required this.tile});

  final Tile tile;

  @override
  State<TileSettingsPage> createState() => _TileSettingsPageState();
}

class _TileSettingsPageState extends State<TileSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Provider.of<NoteTiles>(context, listen: false).notify();
            Navigator.of(context).pop();
          });
          //TODO add update tiles here?
        },
      ),
      body: TileSettingsContent(tile: widget.tile),
    );
  }
}

class TileSettingsContent extends StatelessWidget {
  const TileSettingsContent({super.key, required this.tile});

  final Tile tile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: TileTextAreas(tile: tile),
    );
  }
}

class TileTextAreas extends StatelessWidget {
  const TileTextAreas({super.key, required this.tile});

  final Tile tile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TileTitleField(tile: tile),
        const Divider(),
        TileTextField(tile: tile)
      ],
    );
  }
}

class TileTextField extends StatefulWidget {
  const TileTextField({super.key, required this.tile});

  final Tile tile;

  @override
  State<TileTextField> createState() => _TileTextFieldState();
}

class _TileTextFieldState extends State<TileTextField> {
  var _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController(text: widget.tile.text);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: TextField(
      maxLines: null,
      controller: _controller,
      onChanged: (value) => widget.tile.text = value,
      keyboardType: TextInputType.multiline,
    ));
  }
}

class TileTitleField extends StatefulWidget {
  const TileTitleField({super.key, required this.tile});

  final Tile tile;

  @override
  State<TileTitleField> createState() => _TileTitleFieldState();
}

class _TileTitleFieldState extends State<TileTitleField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.tile.title);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: _controller,
      onChanged: (value) => widget.tile.title = value,
      decoration: const InputDecoration(hintText: 'Title'),
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    );
  }
}
