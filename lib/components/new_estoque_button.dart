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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              mainAxisSize: MainAxisSize.min,
              children: [
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
                  ),
                ),
                
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
                      onPressed: () {
                        
                      },
                      child: Text(
                            'Registrar Baixa',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.primary, 
                                ),
                          ),
                      
                    
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
