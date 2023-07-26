import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/episode_bloc.dart';
import '../../models/episode_model.dart';
import '../../services/api_service.dart';
import 'episode_detail.dart';

class EpisodesScreen extends StatefulWidget {
  @override
  EpisodesScreenState createState() => EpisodesScreenState();
}

class EpisodesScreenState extends State<EpisodesScreen> {
  late EpisodeBloc _episodeBloc;
  List<Episode> allEpisodes = [];
  List<Episode> filteredEpisodes = [];
  String? searchQuery;
  String? selectedSeason;


  @override
  void initState() {
    super.initState();
    _episodeBloc = EpisodeBloc(ApiService());
    _episodeBloc.add(FetchEpisodes());
  }

  @override
  void dispose() {
    _episodeBloc.close();
    super.dispose();
  }

  void performSearch(String query) {
    setState(() {
      searchQuery = query;
    });
    applyFilters();
  }

  void applyFilters() {
    setState(() {
      filteredEpisodes = allEpisodes.where((episode) {
        final seasonMatch =
            selectedSeason == null || selectedSeason == 'All' || episode.episode.startsWith('S' + selectedSeason!);
        final nameMatch = searchQuery == null ||
            searchQuery!.isEmpty ||
            episode.name.toLowerCase().contains(searchQuery!.toLowerCase());

        return seasonMatch && nameMatch;
      }).toList();

      // If there are no matches after applying filters, set filteredEpisodes to an empty list explicitly
      if (filteredEpisodes.isEmpty) {
        filteredEpisodes = [];
      }
    });
  }


  EpisodeState? _latestEpisodeState;

  void handleEpisodeState(EpisodeState state) {
    _latestEpisodeState = state;
    setState(() {
      if (state.episodes.isNotEmpty) {
        allEpisodes.clear();
        allEpisodes.addAll(state.episodes);
      } else {
        allEpisodes.clear();
      }
      applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Episodes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: performSearch,
              decoration: InputDecoration(
                hintText: 'Search episodes...',
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                FilterDropdown(
                  title: 'Season',
                  items: ['01','02','03','04','05','All'],
                  selectedValue: selectedSeason,
                  onChanged: (value) {
                    setState(() {
                      selectedSeason = value;
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
              child: BlocListener<EpisodeBloc, EpisodeState>(
                bloc: _episodeBloc,
                listener: (context, state) {
                  handleEpisodeState(state);
                },
                child: BlocBuilder<EpisodeBloc, EpisodeState>(
                  bloc: _episodeBloc,
                  builder: (context, state) {
                    if (_latestEpisodeState == null || _latestEpisodeState!.episodes.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return EpisodePage(
                        episodes: filteredEpisodes,
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

class EpisodePage extends StatelessWidget {
  final List<Episode> episodes;
  final int currentPage;

  EpisodePage({
    required this.episodes,
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
                    itemCount: episodes.length,
                    itemBuilder: (context, index) {
                      return EpisodeTile(episode: episodes[index]);
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

class EpisodeTile extends StatelessWidget {
  final Episode episode;

  EpisodeTile({required this.episode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EpisodeDetailScreen(episode: episode),
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
                    episode.name!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    episode.airDate!,
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
