import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/episode_model.dart';
import '../services/api_service.dart';

class EpisodeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchEpisodes extends EpisodeEvent {}

class EpisodeState extends Equatable {
  final List<Episode> episodes;

  EpisodeState(this.episodes);

  @override
  List<Object?> get props => [episodes];
}

class EpisodeBloc extends Bloc<EpisodeEvent, EpisodeState> {
  final ApiService apiService;

  EpisodeBloc(this.apiService) : super(EpisodeState([]));

  @override
  Stream<EpisodeState> mapEventToState(EpisodeEvent event) async* {
    if (event is FetchEpisodes) {
      try {
        List<Episode> allEpisodes = await apiService.fetchAllEpisodes();
        yield EpisodeState(allEpisodes);
      } catch (e) {
        
        print('Error fetching episodes: $e');
      }
    }
  }
}


