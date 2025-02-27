import 'package:controle_estoque_app/components/SearchProductBar.dart';
import 'package:controle_estoque_app/pages/adicionar_estoque_page.dart';
import 'package:flutter/material.dart';

class EstoquePage1 extends StatelessWidget {
  const EstoquePage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          Image.asset(
            'assets/images/estoque.png',
            height: 30,
            ),
          const SizedBox(width: 15),
          const Text("Estoque"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Column(
            children: [
              SearchProductBar(),
              const SizedBox(height: 15),
              //StreamBuilder(),
              const SizedBox(height: 100,)
            ],
          ),
        ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdicionarEstoquePage(),
          ),
        );
      },
      child: const Icon(Icons.add),
    ),
       
      
    );
  }
}