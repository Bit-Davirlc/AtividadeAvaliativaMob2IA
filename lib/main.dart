import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      home: const Locadora(),
    );
  }
}

class Locadora extends StatefulWidget {
  const Locadora({super.key});
  @override
  State<Locadora> createState() => _LocadoraState();
}

class _LocadoraState extends State<Locadora> {
  // Veículo escolhido no SegmentedButton
  String veiculo = 'Econômico';

  // Opcionais
  bool seguro = false;
  bool gps = false;
  bool motorista = false;

  // Quantidade de dias (Slider)
  double dias = 1;

  // Retorna o valor da diária do veículo escolhido
  double valorVeiculo() {
    if (veiculo == 'Econômico') {
      return 120;
    } else if (veiculo == 'SUV') {
      return 180;
    } else {
      return 300;
    }
  }

  // Valor diário = veículo + seguro + gps
  double calcularValorDiario() {
    double valorDiario = valorVeiculo();
    if (seguro) {
      valorDiario = valorDiario + 40;
    }
    if (gps) {
      valorDiario = valorDiario + 15;
    }
    return valorDiario;
  }

  // Valor bruto = valor diário x dias + motorista adicional
  double calcularValorBruto() {
    double valorBruto = calcularValorDiario() * dias;
    if (motorista) {
      valorBruto = valorBruto + 100;
    }
    return valorBruto;
  }

  // Porcentagem de desconto por fidelidade
  double calcularPorcentagem() {
    if (dias >= 15) {
      return 10;
    } else if (dias >= 7) {
      return 5;
    } else {
      return 0;
    }
  }

  double calcularDesconto() {
    return calcularValorBruto() * calcularPorcentagem() / 100;
  }

  double calcularValorFinal() {
    return calcularValorBruto() - calcularDesconto();
  }

  // Desafio extra: categoria do cliente
  String calcularCategoria() {
    double valorFinal = calcularValorFinal();
    if (valorFinal <= 1000) {
      return 'Cliente Bronze';
    } else if (valorFinal <= 3000) {
      return 'Cliente Prata';
    } else if (valorFinal <= 5000) {
      return 'Cliente Ouro';
    } else {
      return 'Cliente Platinum';
    }
  }

  // Transforma true/false em Sim/Não
  String simNao(bool valor) {
    if (valor) {
      return 'Sim';
    } else {
      return 'Não';
    }
  }

  // Formata o valor em reais (ex.: R$ 120,00)
  String moeda(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  void finalizarReserva() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Resumo da Reserva', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Veículo: $veiculo'),
              Text('Dias: ${dias.toInt()}'),
              Text('Seguro: ${simNao(seguro)}'),
              Text('GPS: ${simNao(gps)}'),
              Text('Motorista adicional: ${simNao(motorista)}'),
              const Divider(height: 20),
              Text('Valor bruto: ${moeda(calcularValorBruto())}'),
              Text('Desconto: ${moeda(calcularDesconto())}'),
              Text('Valor final: ${moeda(calcularValorFinal())}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(calcularCategoria(), style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reserva realizada com sucesso!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Confirmar Reserva'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locadora de Carros', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Escolha do veículo
              const Text('Escolha o veículo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Econômico', label: Text('Econômico'), icon: Icon(Icons.directions_car)),
                  ButtonSegment(value: 'SUV', label: Text('SUV'), icon: Icon(Icons.airport_shuttle)),
                  ButtonSegment(value: 'Luxo', label: Text('Luxo'), icon: Icon(Icons.star)),
                ],
                selected: {veiculo},
                onSelectionChanged: (valor) {
                  setState(() {
                    veiculo = valor.first;
                  });
                },
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Diária: ${moeda(valorVeiculo())}',
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),

              // Opcionais em Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      // 2. Seguro completo
                      CheckboxListTile(
                        title: const Text('Seguro Completo'),
                        subtitle: const Text('+ R\$ 40,00 por dia'),
                        secondary: const Icon(Icons.security),
                        value: seguro,
                        onChanged: (valor) {
                          setState(() {
                            seguro = valor!;
                          });
                        },
                      ),
                      const Divider(height: 1),
                      // 3. GPS
                      CheckboxListTile(
                        title: const Text('GPS'),
                        subtitle: const Text('+ R\$ 15,00 por dia'),
                        secondary: const Icon(Icons.map),
                        value: gps,
                        onChanged: (valor) {
                          setState(() {
                            gps = valor!;
                          });
                        },
                      ),
                      const Divider(height: 1),
                      // 4. Motorista adicional
                      SwitchListTile(
                        title: const Text('Motorista Adicional'),
                        subtitle: const Text('Taxa única de R\$ 100,00'),
                        secondary: const Icon(Icons.person_add),
                        value: motorista,
                        onChanged: (valor) {
                          setState(() {
                            motorista = valor;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 5. Quantidade de dias
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Quantidade de dias', style: TextStyle(fontWeight: FontWeight.bold)),
                          Chip(
                            label: Text('${dias.toInt()} dias'),
                            backgroundColor: Colors.deepPurple.shade50,
                          ),
                        ],
                      ),
                      Slider(
                        value: dias,
                        min: 1,
                        max: 30,
                        divisions: 29,
                        label: dias.toInt().toString(),
                        onChanged: (valor) {
                          setState(() {
                            dias = valor;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 8. Resumo da locação
              Card(
                elevation: 3,
                color: Colors.deepPurple.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumo da Locação',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      ),
                      const Divider(height: 20),
                      Text('Veículo: $veiculo'),
                      Text('Dias: ${dias.toInt()}'),
                      Text('Seguro: ${simNao(seguro)}'),
                      Text('GPS: ${simNao(gps)}'),
                      Text('Motorista adicional: ${simNao(motorista)}'),
                      const Divider(height: 15),
                      Text('Valor bruto: ${moeda(calcularValorBruto())}'),
                      Text('Desconto (${calcularPorcentagem().toInt()}%): ${moeda(calcularDesconto())}'),
                      const SizedBox(height: 5),
                      Text(
                        'Valor final: ${moeda(calcularValorFinal())}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      // Desafio extra
                      Center(
                        child: Chip(
                          label: Text(
                            calcularCategoria(),
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // 9. Botão Finalizar Reserva
              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  onPressed: finalizarReserva,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Finalizar Reserva', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}