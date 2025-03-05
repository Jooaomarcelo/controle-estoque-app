import 'package:flutter/material.dart';

class NewEstoqueButtton extends StatelessWidget {
  const NewEstoqueButtton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 144,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 40),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Espaço superior
          SizedBox(height: 10),
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          // Primeiro botão
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: 280,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
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
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Espaço entre os botões
          SizedBox(height: 2),
          // Segundo botão
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: 280,
              height: 48,
              child: ElevatedButton(
                
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Registrar Baixa',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          // Espaço inferior
          
          SizedBox(height:10),
        ],
      ),
    );
  }
}
