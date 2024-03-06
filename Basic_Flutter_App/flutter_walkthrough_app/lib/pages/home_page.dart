import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_app/data/pomodoro_timer_class.dart';
import 'package:test_app/pages/tasks_page.dart'; // TODO consider replacing this with 'isar' which can also store our objects nicesly, and has real noSql features
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:test_app/pages/pomodoro_timer_widget.dart';


// start with this https://api.flutter.dev/flutter/material/BottomAppBar-class.html
// then this https://docs.flutter.dev/cookbook/navigation/passing-data
// can probably use the content frame to toggle between views, tasks can get their own full navigate.push

// based around https://api.flutter.dev/flutter/material/NavigationDrawer-class.html
// docs also described a side drawer as another option
/// Used to draw either a widget inside the top scaffold (you see the navbar at the bottom)
///
/// Or draw an entire new page with Navigator.push() (new page takes the full screen)
///
/// You must have one or the other
///
/// Pass either a Widget to widget field.
///
/// Or pass a Widget Build function to navBuilder field. See `examplePage` at the bottom for an example
class ViewDestination {
  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final Widget? widget;
  final bool wantAppBar;
  final Widget Function(BuildContext)? navBuilder;

  const ViewDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.widget,
    this.wantAppBar = false,
    this.navBuilder,
  });

  // TODO enforce that widget and navBuilder can't both be null
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _myBox = Hive.box('taskbox'); // TODO pass this in as an argument
  final PomodoroTimer pomodoroTimer = PomodoroTimer(duration: Duration(seconds: 20));

  int screenIndex = 1; // default to Tasks view

  @override
  Widget build(BuildContext context) {
    List<ViewDestination> destinations = <ViewDestination>[
    ViewDestination(
      label: 'User Account',
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      widget: Placeholder(),
    ),
    ViewDestination(
      label: 'Tasks',
      icon: Icon(Icons.task_outlined),
      selectedIcon: Icon(Icons.task),
      widget: TaskPage(),
      wantAppBar: true,
    ),
    ViewDestination(
      label: 'XP',
      icon: Icon(Icons.star_outline),
      selectedIcon: Icon(Icons.star),
      widget: Placeholder(),
    ),
    ViewDestination(
      label: 'Pomodoro Timer',
      icon: Icon(Icons.timer_outlined),
      selectedIcon: Icon(Icons.timer),
      widget: PomodoroTimerWidget(pomodoroTimer: pomodoroTimer),
    ),
    ViewDestination(
      // show an example of a full screen page, using navigator push instead
      label: 'Example fullpage',
      icon: Icon(Icons.fullscreen),
      selectedIcon: Icon(Icons.fullscreen_exit),
      navBuilder: (context) => ExamplePage(),
    ),
    ];

    return Scaffold(
      // TODO avoid nested scaffold, will require using the below appBar and floating action button
      // appBar: destinations[screenIndex].wantAppBar
      //     ? AppBar(title: Text(destinations[screenIndex].label))
      //     : null,
      body: destinations[screenIndex].widget,
      bottomNavigationBar: NavigationBar(
        selectedIndex: screenIndex,
        onDestinationSelected: (int index) {
          if (destinations[index].navBuilder ==
              null) // use a widget instead of a new page
          {
            // remember, setState redraws the current widget
            setState(() {
              screenIndex = index;
            });
          } else // push a new route
          {
            // without setState(), we can push a navigator without also redrawing this widget
            screenIndex = index;
            // has to be wrapped in a closure, otherwise it reuses the same route, which gets disposed of every time
            Navigator.push(context,
                MaterialPageRoute(builder: destinations[index].navBuilder!));
          }
        },
        destinations: destinations.map(
          (ViewDestination destination) {
            return NavigationDestination(
              label: destination.label,
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
              tooltip: destination.label,
            );
          },
        ).toList(),
      ),
    );
  }
}

// This is an example of a dedicated page we can Navigate.push() to
// example route from https://docs.flutter.dev/cookbook/navigation/navigation-basics
class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

@pragma('vm:entry-point')
void alarmCallback()
{
  print("Callback in home_page");
}