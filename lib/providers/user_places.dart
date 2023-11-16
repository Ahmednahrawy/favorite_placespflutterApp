import 'dart:io';

import 'package:favotite_places/models/place_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'nahroPlaces.db'),
    onCreate: (db, version) => db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)'),
    version: 1,
  );
  return db;
}

class UserPlaceNotifier extends StateNotifier<List<Place>> {
  UserPlaceNotifier() : super(const []);

  Future<void> loadDbPlaces() async {
    final db = await _getDataBase();
    final data = await db.query(
      'user_places',
    );
    final places = data
        .map(
          (e) => Place(
            id: e['id'] as String,
            image: File(e['image'] as String),
            name: e['title'] as String,
            location: PlaceLocation(
                latitude: e['lat'] as double,
                longitude: e['lng'] as double,
                location: e['address'] as String),
          ),
        )
        .toList();
    state = places;
  }

  void addPlace(Place place) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(place.image.path);
    final copiedImage = await place.image.copy('${appDir.path}/$fileName');

    final newPlace = Place(
      name: place.name,
      image: copiedImage,
      location: place.location,
    );
    final db = await _getDataBase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.name,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.location,
    });

    state = [newPlace, ...state];
  }
}

final UserPlacesProvider =
    StateNotifierProvider<UserPlaceNotifier, List<Place>>(
  (ref) => UserPlaceNotifier(),
);
