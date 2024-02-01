import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_app/pages/tasks_page.dart'; // TODO consider replacing this with 'isar' which can also store our objects nicesly, and has real noSql features

// start with this https://api.flutter.dev/flutter/material/BottomAppBar-class.html
// then this https://docs.flutter.dev/cookbook/navigation/passing-data
// can probably use the content frame to toggle between views, tasks can get their own full navigate.push

// based around https://api.flutter.dev/flutter/material/NavigationDrawer-class.html
// docs also described a side drawer as another option
class ViewDestination {
  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final Widget widget;
  final bool wantAppBar;

  const ViewDestination(
      {required this.label,
      required this.icon,
      required this.selectedIcon,
      required this.widget,
      this.wantAppBar=false});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final _myBox = Hive.box('taskbox'); // TODO pass this in as an argument
  
  static const List<ViewDestination> destinations = <ViewDestination>[
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
  ];

  int screenIndex = 1; // default to Tasks view

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO avoid nested scaffold, will require using the below appBar and floating action button
      // appBar: destinations[screenIndex].wantAppBar
      //     ? AppBar(title: Text(destinations[screenIndex].label))
      //     : null,
      body: destinations[screenIndex].widget,
      bottomNavigationBar: NavigationBar(
        selectedIndex: screenIndex,
        onDestinationSelected: (int index) {
          setState(() {
            screenIndex = index;
          });
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
