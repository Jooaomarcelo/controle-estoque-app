import 'dart:async';
import 'package:flutter/material.dart';

class SearchProductBar extends StatefulWidget {
  final void Function(String) onSearch;

  const SearchProductBar({
    required this.onSearch,
    super.key,
  });

  @override
  State<SearchProductBar> createState() => _SearchProductBarState();
}

class _SearchProductBarState extends State<SearchProductBar> {
  Timer? _timer;
  final ValueNotifier<bool> _isSearching = ValueNotifier(false);

  void _handleSearch(String value) {
    _isSearching.value = true;

    if (_timer?.isActive ?? false) _timer?.cancel();

    _timer = Timer(const Duration(milliseconds: 1000), () {
      _isSearching.value = false;
      widget.onSearch(value); // Chama a função para atualizar a busca
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isSearching,
      builder: (context, isSearching, child) {
        return TextField(
          onChanged: _handleSearch,
          decoration: InputDecoration(
            fillColor: Theme.of(context).colorScheme.primary.withAlpha(25),
            filled: true,
            suffixIcon: isSearching
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )
                : IconButton(
                    onPressed: () => FocusScope.of(context).unfocus(),
                    icon: const Icon(Icons.search),
                  ),
            label: const Center(child: Text('Pesquisar no estoque')),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 3.0,
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  width: 2.0, color: Theme.of(context).colorScheme.primary),
            ),
          ),
        );
      },
    );
  }
}
