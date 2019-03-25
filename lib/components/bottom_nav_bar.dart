import 'package:flutter/material.dart';
import 'package:eco_connect/route/home.dart';

class BottomNavBarComponet extends StatefulWidget {
  Function _onTap;
  int _index;
  @override
  _BottomNavBarComponetState createState() =>
      _BottomNavBarComponetState(this._onTap, this._index);

  BottomNavBarComponet(this._onTap, this._index);
}

class _BottomNavBarComponetState extends State<BottomNavBarComponet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  int index;
  Function onTap;
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _BottomNavBarComponetState(this.onTap, this.index) {}
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (val) {
        onTap(val);
      },
      currentIndex: index,
      fixedColor: Theme.of(context).primaryColor,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.home,
            ),
            title: Text("Dashboard")),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
            ),
            title: Text("Notifications")),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.local_shipping,
            ),
            title: Text("Pick History")),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
            title: Text("Profile")),
      ],
    );
  }
}
