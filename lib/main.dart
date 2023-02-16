import 'package:flutter/material.dart';
import 'package:task_tiles/tile.dart';
import 'provider.dart';
import 'pages/tile_grid_page.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LayoutParams()),
      ChangeNotifierProvider(create: (context) => NoteTiles(tiles: getTiles())),
      ChangeNotifierProvider(create: (context) => IgnorePointerProvider()),
    ],
    child: const TaskTiles(),
  ));
}

class TaskTiles extends StatelessWidget {
  const TaskTiles({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w300, fontSize: 40));

    ThemeData lightTheme = ThemeData(
      textTheme: textTheme,
      colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EE),
          brightness: Brightness.light,
          primary: const Color(0xFF6200EE),
          secondary: const Color(0xFF03DAC5),
          error: const Color(0xffFF5060)),
    );

    ThemeData darkTheme = ThemeData(
      textTheme: textTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFba86fc),
        brightness: Brightness.dark,
        primary: const Color(0xffba86fc),
        secondary: const Color(0xff6CD8CD),
        error: const Color(0xffFF7080),
      ),
      primarySwatch: Colors.yellow,
    );

    var bottomNavigationBar = BottomAppBar(
      child: FloatingActionButton(
        onPressed: (() {}),
      ),
    );

    return MaterialApp(
        title: 'TaskTiles',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark, //ThemeMode.system,
        home: TileGridPage(appBar: bottomNavigationBar));
  }
}

List<Tile> getTiles() {
  return [
    Tile.withSizes(
      name: 'Tile1',
      xStart: 1,
      yStart: 0,
      height: 2,
      width: 2,
    ),
    Tile.withSizes(
      name: 'Tile2',
      xStart: 0,
      yStart: 1,
      width: 1,
      height: 1,
    ),
    Tile.withSizes(
      name: 'Tile3',
      xStart: 0,
      width: 3,
      yStart: 2,
      height: 1,
    )
  ];
}
