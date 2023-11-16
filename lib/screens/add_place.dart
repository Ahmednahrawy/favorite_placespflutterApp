import 'package:favotite_places/models/place_item.dart';
import 'package:favotite_places/widgets/image_input.dart';
import 'package:favotite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:favotite_places/providers/user_places.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    final enteredName = _titleController.text;

    if (enteredName.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      return;
    }
    ref.read(UserPlacesProvider.notifier).addPlace(Place(
        name: enteredName,
        image: _selectedImage!,
        location: _selectedLocation!));
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 10),
            ImageInput(
              onPickImage: (File image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 10),
            LocationInput(
              onPickLocation: (PlaceLocation location) {
                _selectedLocation = location;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
                onPressed: _savePlace,
                icon: const Icon(Icons.add),
                label: const Text('Add Place'))
          ],
        ),
      ),
    );
  }
}
