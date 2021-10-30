import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(_App());

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brian Isganitis',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> with TickerProviderStateMixin {
  late Stream<String> _name;

  late AnimationController _transitionController;
  late Animation<double> _curvedAnimation;
  late Animation<Offset> _offsetAnimation;

  late AnimationController _cursorController;
  late Animation<double> _cursorAnimation;

  @override
  void initState() {
    super.initState();
    _name = _typedName;

    _transitionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..forward(from: 0);
    _curvedAnimation = CurvedAnimation(
      parent: _transitionController,
      curve: Curves.fastOutSlowIn,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(_curvedAnimation);

    _cursorController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    )..repeat(reverse: true);
    _cursorAnimation = CurvedAnimation(
      parent: _cursorController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _cursorController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          StreamBuilder<String>(
            initialData: '',
            stream: _name,
            builder: (context, snapshot) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  snapshot.data ?? '',
                  style: Theme.of(context).textTheme.headline3,
                ),
                if (!(snapshot.data ?? '').contains('n'))
                  FadeTransition(
                    opacity: _cursorAnimation,
                    child: Text(
                      '|',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Flexible(
            child: FadeTransition(
              opacity: _curvedAnimation,
              child: Container(
                constraints: BoxConstraints(maxWidth: 200, maxHeight: 200),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: AssetImage('images/me.jpg')),
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          SlideTransition(
            position: _offsetAnimation,
            child: FadeTransition(
              opacity: _curvedAnimation,
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  _IconButton(
                    url: 'mailto:brianji@umd.edu',
                    tooltip: 'Email',
                    icon: MdiIcons.email,
                  ),
                  _IconButton(
                    url: 'https://github.com/brianji',
                    tooltip: 'GitHub',
                    icon: MdiIcons.github,
                  ),
                  _IconButton(
                    url: 'https://linkedin.com/in/brianji',
                    tooltip: 'LinkedIn',
                    icon: MdiIcons.linkedin,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  static Stream<String> get _typedName async* {
    var title = '';
    Future<String> type(String char) async {
      await Future.delayed(Duration(milliseconds: 750));
      return title += char;
    }

    yield await type('B');

    final max = Random().nextInt(4);
    for (var i = 0; i < max; i++) yield await type('b');

    yield await type('r');
    yield await type('i');
    yield await type('a');
    yield await type('n');
  }
}

class _IconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final String url;

  const _IconButton({
    Key? key,
    required this.tooltip,
    required this.icon,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: () => launch(url),
      icon: Icon(icon),
    );
  }
}
