import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';

class LocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLocations extends LocationEvent {}

class LocationState extends Equatable {
  final List<Location> locations;

  LocationState(this.locations);

  @override
  List<Object?> get props => [locations];
}

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final ApiService apiService;

  LocationBloc(this.apiService) : super(LocationState([]));

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if (event is FetchLocations) {
      try {
        List<Location> allLocations = await apiService.fetchAllLocations();
        yield LocationState(allLocations);
      } catch (e) {
        
        print('Error fetching locations: $e');
      }
    }
  }
}
