import 'package:flutter/material.dart';
import 'package:imc_flutter/imc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IMC Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculadora de IMC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<IMC> items = [];
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();

  double calcularIMC(IMC imc) {
    if (imc.altura > 0 && imc.peso > 0) {
      return double.parse(
        (imc.peso / (imc.altura * imc.altura)).toStringAsFixed(1),
      );
    } else {
      return 0.0;
    }
  }

  String classificacao(double imc) {
    var classificacao = "";

    if (imc == 0) {
      return "IMC incorreto";
    }

    if (imc < 16) {
      classificacao = "Magreza grave";
    } else if (imc >= 16 && imc < 17) {
      classificacao = "Magreza moderada";
    } else if (imc >= 17 && imc < 18.5) {
      classificacao = "Magreza leve";
    } else if (imc >= 18.5 && imc < 25) {
      classificacao = "Saudável";
    } else if (imc >= 25 && imc < 30) {
      classificacao = "Sobrepeso";
    } else if (imc >= 30 && imc < 35) {
      classificacao = "Obesidade Grau I";
    } else if (imc >= 35 && imc < 40) {
      classificacao = "Obesidade Grau II (severa)";
    } else {
      classificacao = "Obesidade Grau III (mórbida)";
    }

    return classificacao;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: items.isEmpty
              ? const Text(
                  "Nenhum IMC cadastrado",
                  style: TextStyle(fontSize: 16),
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    double imc = calcularIMC(items[index]);
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Peso: ${items[index].peso}",
                          ),
                          Text(
                            "Altura: ${items[index].altura}",
                          ),
                          Text("IMC: $imc"),
                        ],
                      ),
                      subtitle: Text("Classificação: ${classificacao(imc)}"),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets +
                    const EdgeInsets.symmetric(vertical: 5),
                duration: const Duration(milliseconds: 100),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _pesoController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Peso', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _alturaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Altura', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final peso = double.tryParse(
                              _pesoController.text.replaceAll(',', '.'));
                          final altura = double.tryParse(
                              _alturaController.text.replaceAll(',', '.'));
                          if (peso != null && altura != null) {
                            items.add(IMC(peso: peso, altura: altura));
                            _pesoController.clear();
                            _alturaController.clear();
                            Navigator.of(context).pop();
                            setState(() {});
                          }
                        },
                        child: const Text('Cadastrar'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.calculate_outlined),
      ),
    );
  }
}
