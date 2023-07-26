import 'package:flutter/material.dart';

enum AppTab { characters, locations, episodes }

class AppBottomNavigationBar extends StatelessWidget {
  final AppTab currentTab;
  final ValueChanged<AppTab> onTabChanged;

  AppBottomNavigationBar({required this.currentTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: AppTab.values.indexOf(currentTab),
      onTap: (index) => onTabChanged(AppTab.values[index]),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Characters',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Locations',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tv),
          label: 'Episodes',
        ),
      ],
    );
  }
}
