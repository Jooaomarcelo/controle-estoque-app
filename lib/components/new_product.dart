import 'package:controle_estoque_app/pages/product_form_page.dart';
import 'package:flutter/material.dart';

class NewProduct extends StatelessWidget {
  final void Function() onSuccess;

  const NewProduct({
    required this.onSuccess,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void wasSuccess() async {
      final success = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const ProductFormPage(),
        ),
      );

      if (success) {
        onSuccess();
      }
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.8),
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: wasSuccess,
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
              'Cadastrar Produto',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
