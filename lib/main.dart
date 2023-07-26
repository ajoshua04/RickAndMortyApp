import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/screens/characters/characters_screen.dart';
import 'package:rick_and_morty_app/screens/episodes/episodes_screen.dart';
import 'package:rick_and_morty_app/screens/locations/locations_screen.dart';
import 'package:rick_and_morty_app/services/api_service.dart';


import 'bloc/character_bloc.dart';
import 'bloc/episode_bloc.dart';
import 'bloc/location_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CharacterBloc>(create: (context) => CharacterBloc(ApiService())),
          BlocProvider<LocationBloc>(create: (context) => LocationBloc(ApiService())), 
          BlocProvider<EpisodeBloc>(create: (context) => EpisodeBloc(ApiService())),
        ],
        child: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    CharactersScreen(),
    LocationsScreen(),
    EpisodesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rick and Morty')),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Characters'),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: 'Locations'),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Episodes'),
        ],
      ),
    );
  }
}
