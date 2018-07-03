import 'package:flutter/material.dart';

void main() {
  MaterialPageRoute.debugEnableFadingRoutes = true;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<NavigatorState> _redNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _blueNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _greenNavigatorKey =
      GlobalKey<NavigatorState>();

  Tab _currentTab = Tab.red;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldWarn = true;

        switch (_currentTab) {
          case Tab.red:
            if (_redNavigatorKey.currentState.canPop()) {
              shouldWarn = !_redNavigatorKey.currentState.pop();
            }
            break;
          case Tab.blue:
            if (_blueNavigatorKey.currentState.canPop()) {
              shouldWarn = !_blueNavigatorKey.currentState.pop();
            }
            break;
          case Tab.green:
            if (_greenNavigatorKey.currentState.canPop()) {
              shouldWarn = !_greenNavigatorKey.currentState.pop();
            }
            break;
        }

        if (shouldWarn) {
          return showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Exit App'),
                  content: Text('Would you like to exit the app?'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text('Close'),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                ),
          );
        } else {
          return false;
        }
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Offstage(
              offstage: _currentTab != Tab.red,
              child: Red(
                navigatorKey: _redNavigatorKey,
              ),
            ),
            Offstage(
              offstage: _currentTab != Tab.blue,
              child: Blue(
                navigatorKey: _blueNavigatorKey,
              ),
            ),
            Offstage(
              offstage: _currentTab != Tab.green,
              child: Green(
                navigatorKey: _greenNavigatorKey,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _currentTab.index,
          onTap: (index) {
            setState(() {
              _currentTab = Tab.values[index];
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.clear),
              title: Text('Red'),
              backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              title: Text('Blue'),
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.nature),
              title: Text('Green'),
              backgroundColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

enum Tab { red, blue, green }

class TabHistoryEntry {
  final WidgetBuilder builder;

  TabHistoryEntry(this.builder);
}

class Red extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const Red({Key key, this.navigatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return PageRouteBuilder(
              pageBuilder: (
                BuildContext context,
                Animation animation,
                Animation secondaryAnimation,
              ) {
                return TabChild(
                  childNumber: 0,
                  appBarColor: Colors.red,
                  titleBuilder: (childNumber) =>
                      childNumber == 0 ? 'Red Home' : 'Red Child $childNumber',
                );
              },
            );
        }
      },
    );
  }
}

class Blue extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const Blue({Key key, this.navigatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return PageRouteBuilder(
              pageBuilder: (
                BuildContext context,
                Animation animation,
                Animation secondaryAnimation,
              ) {
                return TabChild(
                  childNumber: 0,
                  appBarColor: Colors.blue,
                  titleBuilder: (childNumber) => childNumber == 0
                      ? 'Blue Home'
                      : 'Blue Child $childNumber',
                );
              },
            );
        }
      },
    );
  }
}

class TabChild extends StatelessWidget {
  final int childNumber;
  final Color appBarColor;
  final String Function(int childNumber) titleBuilder;

  TabChild({
    this.childNumber,
    @required this.appBarColor,
    @required this.titleBuilder,
  }) : super(key: Key("$appBarColor$childNumber"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: appBarColor,
        onPressed: () {},
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: Text(titleBuilder(childNumber)),
        backgroundColor: appBarColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GoToChildButton(
              childNumber: childNumber,
              appBarColor: appBarColor,
              titleBuilder: titleBuilder,
            ),
            VerifyShowDialogButton(),
            Navigator.of(context).canPop()
                ? PopCurrentRouteWithReturnValueButton(childNumber: childNumber)
                : Container(),
          ],
        ),
      ),
    );
  }
}

class PopCurrentRouteWithReturnValueButton extends StatelessWidget {
  const PopCurrentRouteWithReturnValueButton({
    Key key,
    @required this.childNumber,
  }) : super(key: key);

  final int childNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: () => Navigator.pop(context, childNumber),
        child: Text('Pop Current Route'),
      ),
    );
  }
}

class VerifyShowDialogButton extends StatelessWidget {
  const VerifyShowDialogButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: Text('Show Dialog'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text('This is a dialog'),
                ),
          );
        },
      ),
    );
  }
}

class GoToChildButton extends StatelessWidget {
  const GoToChildButton({
    Key key,
    @required this.childNumber,
    @required this.appBarColor,
    @required this.titleBuilder,
  }) : super(key: key);

  final int childNumber;
  final Color appBarColor;
  final String Function(int childNumber) titleBuilder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return TabChild(
                  childNumber: childNumber + 1,
                  appBarColor: appBarColor,
                  titleBuilder: (childNumber) => titleBuilder(childNumber),
                );
              },
            ),
          );

          if (result != null) {
            Scaffold
                .of(context)
                .showSnackBar(SnackBar(content: Text('Child $result closed')));
          }
        },
        child: Text('Go to child'),
      ),
    );
  }
}

class Green extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const Green({Key key, this.navigatorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return PageRouteBuilder(
              pageBuilder: (
                BuildContext context,
                Animation animation,
                Animation secondaryAnimation,
              ) {
                return TabChild(
                  childNumber: 0,
                  appBarColor: Colors.green,
                  titleBuilder: (childNumber) => childNumber == 0
                      ? 'Green Home'
                      : 'Green Child $childNumber',
                );
              },
            );
        }
      },
    );
  }
}
