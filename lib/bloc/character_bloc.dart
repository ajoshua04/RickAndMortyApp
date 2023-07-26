// character_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';

class CharacterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCharacters extends CharacterEvent {}

class CharacterState extends Equatable {
  final List<Character> characters;

  CharacterState(this.characters);

  @override
  List<Object?> get props => [characters];
}

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final ApiService apiService;

  CharacterBloc(this.apiService) : super(CharacterState([]));

  @override
  Stream<CharacterState> mapEventToState(CharacterEvent event) async* {
    if (event is FetchCharacters) {
      try {
        List<Character> allCharacters = await apiService.fetchAllCharacters();
        yield CharacterState(allCharacters);
      } catch (e) {
        
        print('Error fetching characters: $e');
      }
    }
  }
}

