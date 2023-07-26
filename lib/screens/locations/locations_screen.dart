import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/location_bloc.dart';
import '../../models/location_model.dart';
import '../../services/api_service.dart';
import 'location_detail.dart';

class LocationsScreen extends StatefulWidget {
  @override
  _LocationsScreenState createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  late LocationBloc _locationBloc;
  List<Location> allLocations = [];
  List<Location> filteredLocations = [];
  String? searchQuery;
  String? selectedType;
  String? selectedDimension;

  @override
  void initState() {
    super.initState();
    _locationBloc = LocationBloc(ApiService());
    _locationBloc.add(FetchLocations());
  }

  @override
  void dispose() {
    _locationBloc.close();
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
    filteredLocations = allLocations.where((location) {
      final typeMatch =
          selectedType == null || selectedType == 'All' || location.type.toLowerCase() == selectedType!.toLowerCase();
      final dimensionMatch = selectedDimension == null ||
          selectedDimension == 'All' ||
          location.dimension.toLowerCase() == selectedDimension!.toLowerCase();

      final nameMatch = searchQuery == null ||
          searchQuery!.isEmpty ||
          location.name.toLowerCase().contains(searchQuery!.toLowerCase()) ||
          location.type.toLowerCase().contains(searchQuery!.toLowerCase());

      return typeMatch && dimensionMatch && nameMatch;
    }).toList();

    // If there are no matches after applying filters, set filteredLocations to an empty list explicitly
    if (filteredLocations.isEmpty) {
      filteredLocations = [];
    }
  });
}



  LocationState? _latestLocationState;

  void handleLocationState(LocationState state) {
    _latestLocationState = state;
    if (state.locations.isNotEmpty) {
      setState(() {
        allLocations.clear();
        allLocations.addAll(state.locations);
        applyFilters();
      });
    } else {
      setState(() {
        allLocations.clear();
        applyFilters();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Locations'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: performSearch,
              decoration: InputDecoration(
                hintText: 'Search locations...',
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                FilterDropdown(
                  title: 'Type',
                  items: ['All', 'Planet', 'Cluster', 'Space station', 'Microverse', 'Resort', 'Fantasy town', 'Dream', 'Dimension', 'unknown', 'Game', 'Customs', 'Daycare', 'Spacecraft'],
                  selectedValue: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                      applyFilters();
                    });
                  },
                ),
                FilterDropdown(
                  title: 'Dimension',
                  items: ['All', 'Dimension C-137', 'unknown'],
                  selectedValue: selectedDimension,
                  onChanged: (value) {
                    setState(() {
                      selectedDimension = value;
                      applyFilters();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollEndNotification &&
                    scrollNotification.metrics.extentAfter == 0) {
                  
                }
                return false;
              },
              child: BlocListener<LocationBloc, LocationState>(
                bloc: _locationBloc,
                listener: (context, state) {
                  handleLocationState(state);
                },
                child: BlocBuilder<LocationBloc, LocationState>(
                  bloc: _locationBloc,
                  builder: (context, state) {
                    if (_latestLocationState == null || _latestLocationState!.locations.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return LocationPage(
                        locations: filteredLocations,
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

class LocationPage extends StatelessWidget {
  final List<Location> locations;
  final int currentPage;

  LocationPage({
    required this.locations,
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
                      crossAxisCount: 1,
                      childAspectRatio: 2.7,
                    ),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      return LocationTile(location: locations[index]);
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

class LocationTile extends StatelessWidget {
  final Location location;

  LocationTile({required this.location});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocationDetailScreen(location: location),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    location.type!,
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
