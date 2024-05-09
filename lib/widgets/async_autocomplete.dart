import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AsyncAutocomplete extends StatefulWidget {
  const AsyncAutocomplete({super.key, required this.future});

  final Future<List<String>> Function(String query) future;
  @override
  _AsyncAutocompleteState createState() => _AsyncAutocompleteState();
}

class _AsyncAutocompleteState extends State<AsyncAutocomplete> {
  var results = <String>[];
  Timer? timer;

  Future<void> getResults(String query) async {
    final results = await widget.future(query);

    setState(() => this.results = results);
  }

  void debounce(VoidCallback action) {
    timer?.cancel();
    timer = Timer(600.ms, action);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Autocomplete<String>(
        optionsBuilder: (value) {
          final query = value.text;
          debounce(() => getResults(query));

          return query.isEmpty ? [] : results;
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);

                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      onSelected(option);
                    },
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: options.length,
              ),
            ),
          );
        },
      ),
    );
  }
}
