import 'package:flutter/material.dart';

class Plane extends StatefulWidget {
  const Plane({super.key});

  @override
  State<Plane> createState() => _PlaneState();
}

class _PlaneState extends State<Plane>
    with AutomaticKeepAliveClientMixin<Plane> {
  List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.blue,
  ];
  int _colorIndex = 0;

  @override
  void initState() {
    print('creating plane');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        onPressed: () {
          setState(() {
            _colorIndex++;
            _colorIndex %= colors.length;
          });
        },
        icon: Icon(
          Icons.airplanemode_active_outlined,
          size: 60,
          color: colors[_colorIndex],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
