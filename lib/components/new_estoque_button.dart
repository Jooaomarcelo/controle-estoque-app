import 'package:controle_estoque_app/pages/adicionar_estoque_page.dart';
import 'package:flutter/material.dart';

class NewEstoqueButtton extends StatelessWidget {
  const NewEstoqueButtton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.8),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
      child: Column(
        
        
        children: [
          FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const AdicionarEstoquePage(),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 25,
                ),
                const SizedBox(width: 5),
                Text(
                  'Cadastrar no Estoque',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10), 
         
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.remove,
                  color: Theme.of(context).colorScheme.primary,
                  size: 25,
                ),
                const SizedBox(width: 5),
                Text(
                  'Baixa no Estoque',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
