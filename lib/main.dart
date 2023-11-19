import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soma de Múltiplos de 3 ou 5',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(title: 'Soma de Múltiplos de 3 ou 5'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _numeroController = TextEditingController();
  String _resultado = '';
  final List<int> _numerosSomados = [];
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _numeroController.addListener(() {
      _limitarInput(_numeroController);
    });
  }

  void _calcular() {
    if (_numeroController.text.isEmpty) {
      setState(() {
        _resultado = 'O número deve ser informado.';
        _numerosSomados.clear();
        _showButton = false;
      });
      return;
    }

    int numero = int.parse(_numeroController.text);

    if (numero <= 0) {
      setState(() {
        _resultado = 'O número deve ser positivo.';
        _showButton = false;
      });
      return;
    }

    if (numero <= 3) {
      setState(() {
        _resultado = 'O resultado é 0, porque não há números menores que $numero que sejam múltiplos de 3 ou 5.';
        _showButton = false;
      });
      return;
    }

    int soma = 0;

    _numerosSomados.clear();

    for (int i = 1; i < numero; i++) {
      if (i % 3 == 0 || i % 5 == 0) {
        soma += i;
        if (i <= 10000) {
          _numerosSomados.add(i);
        }
      }
    }

    setState(() {
      _resultado = 'A soma é $soma';
      _showButton = true;
    });
  }

  void _mostrarDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Os números somados são:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 110,
                child: ListView(
                  padding: const EdgeInsets.only(top: 15.0),
                  children: [
                    Text(
                      _numerosSomados.join(', '),
                      style: const TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fechar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _limitarInput(TextEditingController input) {
    if (input.text.length > 8) {
      input.text = input.text.substring(0, 8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 250.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('lib/assets/simbol.png'),
                width: 140,
                height: 140,
                filterQuality: FilterQuality.high,
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: _numeroController,
                  decoration: const InputDecoration(
                    labelText: 'Insira um número inteiro positivo:',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _calcular,
                child: const Text('Calcular'),
              ),
              const SizedBox(height: 16.0),
              Text(_resultado),
              const SizedBox(height: 16.0),
              if (_showButton)
                TextButton(
                  onPressed: _mostrarDialog,
                  child: const Text('Ver Números Somados'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
