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
  Stream<String> _name;

  AnimationController _transitionController;
  Animation<double> _curvedAnimation;
  Animation<Offset> _offsetAnimation;

  AnimationController _cursorController;
  Animation<double> _cursorAnimation;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<String>(
                initialData: '',
                stream: _name,
                builder: (context, snapshot) => _BlurShadowed(
                  blur: 8,
                  opacity: 0.5,
                  child: Text(
                    snapshot.data,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ),
              FadeTransition(
                opacity: _cursorAnimation,
                child: _BlurShadowed(
                  blur: 4,
                  opacity: 0.5,
                  child: Text(
                    '|',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Flexible(
            child: FadeTransition(
              opacity: _curvedAnimation,
              child: _BlurShadowed(
                blur: 16,
                opacity: 1,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 200, maxHeight: 200),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage('images/me.jpg')),
                  ),
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
                  _ShadowIconButton(
                    url: 'mailto:brianji@umd.edu',
                    tooltip: 'Email',
                    icon: MdiIcons.email,
                  ),
                  _ShadowIconButton(
                    url: 'https://github.com/brianji',
                    tooltip: 'GitHub',
                    icon: MdiIcons.github,
                  ),
                  _ShadowIconButton(
                    url: 'https://linkedin.com/in/brianji',
                    tooltip: 'LinkedIn',
                    icon: MdiIcons.linkedin,
                  ),
                  _ShadowIconButton(
                    url: 'https://instagram.com/brianji3',
                    tooltip: 'Instagram',
                    icon: MdiIcons.instagram,
                  ),
                  _ShadowIconButton(
                    url: 'https://twitter.com/isgy',
                    tooltip: 'Twitter',
                    icon: MdiIcons.twitter,
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

class _ShadowIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final String url;

  const _ShadowIconButton({Key key, this.tooltip, this.icon, this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BlurShadowed(
      blur: 4,
      opacity: 0.4,
      child: IconButton(
        tooltip: tooltip,
        onPressed: () => launch(url),
        icon: Icon(icon),
      ),
    );
  }
}

class _BlurShadowed extends StatelessWidget {
  final double blur;
  final double opacity;
  final Widget child;

  const _BlurShadowed({Key key, this.blur, this.opacity, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: opacity,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: IgnorePointer(child: child),
          ),
        ),
        child,
      ],
    );
  }
}
