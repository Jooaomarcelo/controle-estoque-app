import 'package:flutter/material.dart';

class SearchProductBar extends StatelessWidget {
  final void Function(String) onSearch;

  const SearchProductBar({
    required this.onSearch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearch,
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.primary.withAlpha(25),
        filled: true,
        suffixIcon: IconButton(
          onPressed: () => FocusScope.of(context).unfocus(),
          icon: const Icon(Icons.search),
        ),
        label: Center(child: Text('Pesquisar produto')),
        contentPadding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 25,
        ),
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
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
    );
  }
}
