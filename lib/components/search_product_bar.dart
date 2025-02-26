import 'package:flutter/material.dart';

class SearchProductBar extends StatelessWidget {
  const SearchProductBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        fillColor: Theme.of(context).colorScheme.primary.withAlpha(25),
        filled: true,
        suffixIcon: Icon(Icons.search),
        label: Center(child: Text('Pesquisar por produto')),
        // floatingLabelBehavior: FloatingLabelBehavior.never,
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
    );
  }
}
