import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:provider/provider.dart';
import 'package:task_tiles/main.dart';
import 'package:task_tiles/tile.dart';
import 'package:task_tiles/note_tiles/tile_drag_receiver.dart';

import '../provider.dart';
import '../note_tiles/note_tile.dart';

class TileGridPage extends StatefulWidget {
  const TileGridPage({super.key, required BottomAppBar appBar});

  @override
  State<TileGridPage> createState() => _TileGridPageState();
}

class _TileGridPageState extends State<TileGridPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TileGrid(),
      floatingActionButton:
          FloatingActionButton(onPressed: () => setState(() {})),
    );
  }
}

class TileGrid extends StatefulWidget {
  const TileGrid({super.key});

  @override
  State<TileGrid> createState() => _TileGridState();
}

class _TileGridState extends State<TileGrid> {
  @override
  Widget build(BuildContext context) {
    //Flexible
    return SizedBox(
        height: 2000,
        child: SingleChildScrollView(
            // child: Expanded(
            child: Stack(
          children: const [
            //this is to give the stack a
            //default child => a default size
            SizedBox(
              height: 2000,
              child: DraggableLayer(),
            ),

            SizedBox(
              height: 2000,
              child: ReceivingLayer(),
            ),

            //TODO hier berechnen?
          ],
        )));
  }
}

class DraggableLayer extends StatefulWidget {
  const DraggableLayer({super.key});

  @override
  State<DraggableLayer> createState() => _DraggableLayerState();
}

class _DraggableLayerState extends State<DraggableLayer> {
  @override
  Widget build(BuildContext context) {
    //get tiles with data
    var tiles = context.watch<NoteTiles>().tiles;
    //create NoteTiles from data

    int maxY = (tiles.isEmpty)
        ? 1
        // get tile with largest maxY
        : tiles
            .reduce((curr, next) => (curr.maxY > next.maxY) ? curr : next)
            // save maxY into var
            .maxY;

    var size = (MediaQuery.of(context).size.width) /
        context.watch<LayoutParams>().width;

    // i = -1 for having at least one rowSize, it crashes else
    var rowSizes = [for (var i = -1; i < maxY; i++) size.px];

    return LayoutGrid(
      columnSizes: [1.fr, 1.fr, 1.fr],
      rowSizes: [
        for (var i = -1; i < maxY + 10; i++) size.px
      ], //start at i=-1 to get >1 entry
      children: tiles.map((tile) => PlacedNoteTile(tile: tile)).toList(),
    );
  }
}

class ReceivingLayer extends StatefulWidget {
  const ReceivingLayer({super.key});

  @override
  State<ReceivingLayer> createState() => _ReceivingLayerState();
}

class _ReceivingLayerState extends State<ReceivingLayer> {
  var _height = 0;

  @override
  Widget build(BuildContext context) {
    // context.watch<NoteTiles>().maxY;

    // make an infinitely large grid to be able to move tiles and to create them
    return Consumer<IgnorePointerProvider>(
      builder: (context, provider, child) => IgnorePointer(
        ignoring: provider.ignore,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: ((context, index) {
              return TileDragReceiver(
                  index: index, ignorePointer: provider.ignore);
            })),
      ),
    );
  }
}
