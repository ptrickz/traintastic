import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:traintastic/core/services/firestore_services.dart';
import 'package:traintastic/data/models/locations_model.dart';

class LocationSearchPage extends StatefulWidget {
  final bool selectable;
  final VoidCallback refreshCallback;

  const LocationSearchPage({
    super.key,
    required this.selectable,
    required this.refreshCallback,
  });

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isChanging = false;
  bool isLoading = false;
  String searchText = "";

  List<Locations> allLocations = [];
  List<Locations> filteredLocations = [];

  void _filterLocations(String query) {
    setState(() {
      isLoading = true;
      searchText = query;
      if (query.isEmpty) {
        filteredLocations = List.from(allLocations); // Show all if empty
      } else {
        filteredLocations = allLocations.where((location) {
          final nameMatch =
              location.locationName.toLowerCase().contains(query.toLowerCase());
          final idMatch =
              location.id.toLowerCase().contains(query.toLowerCase());

          return nameMatch || idMatch;
        }).toList();
      }
      isLoading = false;
    });
  }

  void _fetchLocations() {
    FirestoreServices().getLocations().listen((locations) {
      setState(() {
        allLocations = locations;
        filteredLocations = locations; // Initially show all locations
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
              },
              icon: const Icon(CupertinoIcons.chevron_back)),
          title: CupertinoSearchTextField(
            prefixInsets: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            suffixInsets: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            onChanged: _filterLocations,
            prefixIcon: isChanging
                ? const SizedBox.shrink()
                : const Icon(CupertinoIcons.search),
            autofocus: true,
            onSuffixTap: () {
              searchController.clear();
              _filterLocations('');
            },
            style: Theme.of(context).textTheme.bodyLarge,
            controller: searchController,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : filteredLocations.isEmpty
                  ? const Center(child: Text("No results found"))
                  : ListView.builder(
                      itemCount: filteredLocations.length,
                      itemBuilder: (BuildContext context, index) {
                        final loca = filteredLocations[index];
                        return ListTile(
                          leading: const CircleAvatar(
                              child: Icon(Icons.location_pin)), // Icon/Avatar
                          title: Text(loca.id.toUpperCase()), // Main text
                          subtitle: Text(loca.locationName), // Secondary text
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.pop(context, loca.locationName);
                            FocusScope.of(context).unfocus();
                          },
                        );
                      }),
        ),
      ),
    );
  }
}
