import 'package:app_http/app_http.dart' show ServerService, UserEndpoints;
import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Card,
        Center,
        Column,
        EdgeInsets,
        FloatingActionButton,
        Icon,
        IconButton,
        Icons,
        MainAxisSize,
        Padding,
        Row,
        Scaffold,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        Theme,
        Widget,
        debugPrint;
import 'package:kib_theme_switcher/common_export.dart' show ThemeService, getIt;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _themeService = getIt<ThemeService>();
  final _serverService = getIt<ServerService>();

  @override
  void initState() {
    super.initState();
    () async {
      final String path = UserEndpoints.userPosts.withParams({'userId': '123'});
      _serverService.get<Map<String, dynamic>>(
        path,
        queryParameters: {"test": "jumping_jack"},
      ).then(
        (response) {
          debugPrint('** MyHomePage:initState: $response');
          switch (response.success) {
            case true:
              // TODO: Handle this case.
            case false:
              // TODO: Handle this case.
          }
        },
        onError: (e) {
          debugPrint('** MyHomePage:initState: error[ $e ] *');
        },
      );
    }();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(
              _themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: _themeService.toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Counter Manager',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '$_counter',
                    style: theme.textTheme.displayLarge,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        onPressed: _decrementCounter,
                        tooltip: 'Decrement',
                        child: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 16),
                      FloatingActionButton(
                        onPressed: _resetCounter,
                        tooltip: 'Reset',
                        child: const Icon(Icons.refresh),
                      ),
                      const SizedBox(width: 16),
                      FloatingActionButton(
                        onPressed: _incrementCounter,
                        tooltip: 'Increment',
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
