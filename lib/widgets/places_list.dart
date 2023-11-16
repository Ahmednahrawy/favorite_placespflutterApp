import 'package:favotite_places/models/place_item.dart';
import 'package:favotite_places/screens/place_details.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatefulWidget {
  const PlacesList({super.key, required this.places});

  final List<Place> places;

  @override
  State<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends State<PlacesList> {
  Future<void> _deleteValue(Place item) async {
    setState(() {
      widget.places.remove(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
      'لقد حذفت هذا البند الذي أنفقته',
    )));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.places.isEmpty) {
      return Center(
        child: Text(
          'Add some places',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      );
    }
    return ListView.builder(
      itemCount: widget.places.length,
      itemBuilder: (ctx, index) => Dismissible(
        onDismissed: (direction) {
          _deleteValue(widget.places[index]);
        },
        behavior: HitTestBehavior.opaque,
        key: ValueKey(widget.places[index].id),
        background: Container(
          margin: const EdgeInsets.only(left: 10, right: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.red),
          child: const Center(
              child: Text(
            'Item Deleted',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          )),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundImage: FileImage(
              widget.places[index].image,
            ),
          ),
          title: Text(
            widget.places[index].name,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          subtitle: Text(
            widget.places[index].location.location,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) =>
                    PlaceDetailsScreen(place: widget.places[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
