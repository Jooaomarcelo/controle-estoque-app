import 'package:flutter/material.dart';

class MensagemErro extends StatelessWidget {
  final String mensagem;
  final int limiteDisponivel;

  const MensagemErro({
    super.key,
    required this.mensagem,
    required this.limiteDisponivel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 4),
        borderRadius: BorderRadius.circular(30)),
      
      child: SizedBox(
       
        width: 375,
        height: 200,
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 33,),
             Text(
              "Tentativa de baixa inválida!",
              style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).colorScheme.primary,
                height: 1,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
                fontSize: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                color: Colors.black,
                ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Limite disponível: ",
                   style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.primary,
                    ),
                ),
                Text(
                  "$limiteDisponivel unidades",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
          ],
        ),
      ),
    );
  }
}