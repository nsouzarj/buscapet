import 'package:flutter/material.dart';

class PetForm extends StatefulWidget {
  @override
  _PetFormState createState() => _PetFormState();
}

class _PetFormState extends State<PetForm> {
  String _tipoSelecionado = 'CANINO';
  String _racaSelecionada = '';
  String _racagatoSelecionada = '';

  final List<String> _listaTipos = ['CANINO', 'FELINO'];
  final List<String> _listaRacas = [
    'Golden Retriever',
    'Labrador',
    'Buldogue Francês',
    'Poodle',
    'Pastor Alemão'
  ];
  final List<String> _listaracagatos = [
    'Siamês',
    'Persa',
    'Maine Coon',
    'Sphynx',
    'Ragdoll'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Pet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _tipoSelecionado,
              onChanged: (value) {
                setState(() {
                  _tipoSelecionado = value!;
                  // Limpa a seleção da raça ao trocar o tipo
                  _racaSelecionada = '';
                  _racagatoSelecionada = '';
                });
              },
              items: _listaTipos.map((tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Tipo',
              ),
            ),
            SizedBox(height: 20),
            // Mostra a lista de raças de acordo com o tipo selecionado
            if (_tipoSelecionado == 'CANINO')
              DropdownButtonFormField<String>(
                value: _racaSelecionada,
                onChanged: (value) {
                  setState(() {
                    _racaSelecionada = value!;
                  });
                },
                items: _listaRacas.map((raca) {
                  return DropdownMenuItem(
                    value: raca,
                    child: Text(
                      raca,
                      style: TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Raça',
                ),
              )
            else if (_tipoSelecionado == 'FELINO')
              DropdownButtonFormField<String>(
                value: _racagatoSelecionada,
                onChanged: (value) {
                  setState(() {
                    _racagatoSelecionada = value!;
                  });
                },
                items: _listaracagatos.map((raca) {
                  return DropdownMenuItem(
                    value: raca,
                    child: Text(
                      raca,
                      style: TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Raça',
                ),
              ),
          ],
        ),
      ),
    );
  }
}