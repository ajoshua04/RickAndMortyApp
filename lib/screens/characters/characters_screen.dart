import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/character_bloc.dart';
import '../../models/character_model.dart';
import '../../services/api_service.dart';
import 'character_detail.dart';

class CharactersScreen extends StatefulWidget {
  @override
  _CharactersScreenState createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late CharacterBloc _characterBloc;
  List<Character> allCharacters = [];
  List<Character> filteredCharacters = [];
  String? searchQuery;
  String? selectedStatus;
  String? selectedGender;
  String? selectedOrigin;
  String? selectedSpecies;
  

  @override
  void initState() {
    super.initState();
    _characterBloc = CharacterBloc(ApiService());
    _characterBloc.add(FetchCharacters());
  }

  @override
  void dispose() {
    _characterBloc.close();
    super.dispose();
  }

  void performSearch(String query) {
    setState(() {
      searchQuery = query;
      applyFilters();
    });
  }

  void applyFilters() {
    setState(() {
      filteredCharacters = allCharacters.where((character) {
        final statusMatch = selectedStatus == null || selectedStatus == 'All' || character.status.toLowerCase() == selectedStatus!.toLowerCase();
        final genderMatch = selectedGender == null || selectedGender == 'All' || character.gender.toLowerCase() == selectedGender!.toLowerCase();
        final originMatch = selectedOrigin == null || selectedOrigin == 'All' || character.origin.toLowerCase() == selectedOrigin!.toLowerCase();
        final speciesMatch = selectedSpecies == null || selectedSpecies == 'All' || character.species.toLowerCase() == selectedSpecies!.toLowerCase();

        final nameMatch = searchQuery == null ||
            searchQuery!.isEmpty ||
            character.name.toLowerCase().contains(searchQuery!.toLowerCase());

        return statusMatch && genderMatch && originMatch && speciesMatch && nameMatch;
      }).toList();
    });
  }

  CharacterState? _latestCharacterState;

  void handleCharacterState(CharacterState state) {
    _latestCharacterState = state;
    setState(() {
      if (state.characters.isNotEmpty) {
        allCharacters.clear();
        allCharacters.addAll(state.characters);
      } else {
        allCharacters.clear();
      }
      applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Characters'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: performSearch,
              decoration: InputDecoration(
                hintText: 'Search characters...',
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                FilterDropdown(
                  title: 'Status',
                  items: ['All', 'Alive', 'Dead', 'unknown'],
                  selectedValue: selectedStatus, // Pass the selected status
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                      applyFilters();
                    });
                  },
                ),
                FilterDropdown(
                  title: 'Gender',
                  items: ['All', 'Male', 'Female', 'Genderless', 'unknown'],
                  selectedValue: selectedGender, // Pass the selected gender
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                      applyFilters();
                    });
                  },
                ),
                FilterDropdown(
                  title: 'Origin',
                  items: ['All', 'Unknown', 'Post-Apocalyptic Earth', 'Nuptia 4', 'Other Origins'],
                  selectedValue: selectedOrigin, // Pass the selected origin
                  onChanged: (value) {
                    setState(() {
                      selectedOrigin = value;
                      applyFilters();
                    });
                  },
                ),
                FilterDropdown(
                  title: 'Species',
                  items: ['All', 'Human', 'Alien', 'Robot', 'Other Species'],
                  selectedValue: selectedSpecies, // Pass the selected species
                  onChanged: (value) {
                    setState(() {
                      selectedSpecies = value;
                      applyFilters();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              
              child: BlocListener<CharacterBloc, CharacterState>(
                bloc: _characterBloc,
                listener: (context, state) {
                  handleCharacterState(state);
                },
                child: BlocBuilder<CharacterBloc, CharacterState>(
                  bloc: _characterBloc,
                  builder: (context, state) {
                    if (_latestCharacterState == null || _latestCharacterState!.characters.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return CharacterPage(
                        characters: filteredCharacters,
                        currentPage: 1,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterDropdown extends StatelessWidget {
  final String title;
  final List<String> items;
  final String? selectedValue; 
  final Function(String?) onChanged;

  FilterDropdown({
    required this.title,
    required this.items,
    required this.selectedValue, 
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: DropdownButton<String>(
        value: selectedValue, 
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        hint: Text(title),
      ),
    );
  }
}




class CharacterPage extends StatelessWidget {
  final List<Character> characters;
  final int currentPage;

  CharacterPage({
    required this.characters,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://wallpapercave.com/dwp1x/wp11151412.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      return CharacterTile(character: characters[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class CharacterTile extends StatelessWidget {
  final Character character;

  CharacterTile({required this.character});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterDetailScreen(character: character),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  character.image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    character.status!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


