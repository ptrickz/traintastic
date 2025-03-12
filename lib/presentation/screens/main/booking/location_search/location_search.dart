import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  bool isSearched = false;
  bool isChanging = false;
  bool isLoading = false;
  String searchText = "";

  final List<String> locations =
      List.generate(20, (index) => "Location ${index + 1}");

  List<String> filtered = [];

  void _initScreen() async {
    if (searchText == '') {
      filtered = List.from(locations);
    } else {
      filtered = locations
          .where((location) =>
              location.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    if (searchController.text != '') {
      _initScreen();
    }
    super.initState();
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
            onChanged: (val) {
              setState(() {
                isLoading = true;
                isChanging = true;
                isSearched = true;
                searchText = val;
                _initScreen();
              });
            },
            prefixIcon: isChanging
                ? const SizedBox.shrink()
                : const Icon(CupertinoIcons.search),
            autofocus: true,
            onSubmitted: (val) {
              setState(() {
                isLoading = true;
                isSearched = true;
                searchText = val;
                _initScreen();
              });
            },
            onSuffixTap: () {
              searchController.clear();
              setState(() {
                isSearched = false;
                isChanging = false;
              });
            },
            style: Theme.of(context).textTheme.bodyLarge,
            controller: searchController,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: filtered.isEmpty
              ? const Center(
                  child: Text("No results found"),
                )
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (BuildContext context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                          child: Icon(Icons.location_pin)), // Icon/Avatar
                      title: Text(filtered[index]), // Main text
                      subtitle: Text(
                          "Subtitle for ${filtered[index]}"), // Secondary text
                      trailing:
                          const Icon(Icons.arrow_forward_ios), // Trailing icon
                      onTap: () {
                        Navigator.pop(context, filtered[index]);
                        FocusScope.of(context).unfocus();
                      }, // Click action
                    );
                  }),
        ),
      ),
    );
  }
}
