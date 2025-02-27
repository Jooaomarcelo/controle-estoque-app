import 'package:flutter/material.dart';

class EstoquePage1 extends StatelessWidget {
  const EstoquePage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
          Image.asset("assets/images/icone-produtos.png", width: 30),  
          const Text("Estoque"),
          ]
        ),
      ),
      body: const Center(
        child: Text("Nenhum estoque cadastrado."),
      ),
    );
  }
}