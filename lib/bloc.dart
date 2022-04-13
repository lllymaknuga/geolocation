import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocation/repositories/geolocation/geolocation_repository.dart';
import 'package:geolocator/geolocator.dart';

abstract class GeolocationState extends Equatable {
  const GeolocationState();

  @override
  List<Object?> get props => [];
}

class GeolocationLoading extends GeolocationState {}

class GeolocationLoaded extends GeolocationState {
  final Position position;

  const GeolocationLoaded({required this.position});

  @override
  List<Object?> get props => [position];
}

class GeolocationError extends GeolocationState {}

abstract class GeolocationEvent extends Equatable {
  const GeolocationEvent();

  @override
  List<Object?> get props => [];
}

class LoadGeolocation extends GeolocationEvent {}

class UpdateGeolocation extends GeolocationEvent {
  final Position position;

  const UpdateGeolocation({required this.position});

  @override
  List<Object?> get props => [position];
}

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  final GeolocationRepository _geolocationRepository;
  StreamSubscription? _subscription;

  GeolocationBloc({required repository})
      : _geolocationRepository = repository,
        super(GeolocationLoading()) {
    print(999);
    on<LoadGeolocation>(_mapLoadGeolocationToState);
    on<UpdateGeolocation>(_mapUpdateGeolocationToState);
  }

  void _mapLoadGeolocationToState(
    GeolocationEvent event,
    Emitter<GeolocationState> emit,
  ) async {
    print(123321);
    _subscription?.cancel();
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    print(permission);
    if (permission == LocationPermission.denied) {
      print(123);
      permission = await Geolocator.requestPermission();
      print(123);
      if (permission == LocationPermission.denied) {
        print(3453453453);
        emit(GeolocationError());
      }
    } else {
      final Position position =
          await _geolocationRepository.getCurrentLocation();
      print(4124);
      add(UpdateGeolocation(position: position));
    }
  }

  void _mapUpdateGeolocationToState(
    UpdateGeolocation event,
    Emitter<GeolocationState> emit,
  ) {
    print(888);
    emit(GeolocationLoaded(position: event.position));
  }

  // @override
  // Stream<GeolocationState> mapEventToState(GeolocationEvent event) async* {
  //   if(event is LoadGeolocation) {
  //     yield* _mapLoadGeolocationToState();
  //   } else if (event is UpdateGeolocation) {
  //     yield* _mapUpdateGeolocationToState(event);
  //   }
  // }

  // Stream<GeolocationState> _mapLoadGeolocationToState() async* {
  //   _subscription?.cancel();
  //   final Position? position = await _geolocationRepository.getCurrentLocation();
  //   add(UpdateGeolocation(position: position as Position));
  // }
  // Stream<GeolocationState> _mapUpdateGeolocationToState(UpdateGeolocation event) async* {
  //   yield GeolocationLoaded(position: event.position);
  // }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
