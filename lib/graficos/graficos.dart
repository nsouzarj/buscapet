import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Posicao do Caes',
      home: PizzaChartExample(),
    );
  }
}

class PizzaChartExample extends StatefulWidget {
  @override
  _PizzaChartExampleState createState() => _PizzaChartExampleState();
}

class _PizzaChartExampleState extends State<PizzaChartExample> {
  List<_ChartData> chartData = [
    _ChartData('Adotados', 5, Colors.blue),
    _ChartData('Abandonados', 4, Colors.orange),
    _ChartData('Desaparecidos', 3, Colors.green),
    _ChartData('Outros', 2, Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico Atual', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView( // Adiciona SingleChildScrollView
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 300,
                child: SfCircularChart(
                  title: const ChartTitle(text: 'Cães do Aplicativo',textStyle: TextStyle(fontSize: 20,color: Colors.blue),),
                  series: <CircularSeries>[
                    PieSeries<_ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (_ChartData data, _) => data.category,
                      yValueMapper: (_ChartData data, _) => data.value,
                      pointColorMapper: (_ChartData data, _) => data.color,
                      enableTooltip: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0), // Espaço entre a legenda e a borda
                child: PizzaChartLegend(chartData: chartData),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartData {
  final String category;
  final int value;
  final Color color;

  _ChartData(this.category, this.value, this.color);
}

class PizzaChartLegend extends StatelessWidget {
  final List<_ChartData> chartData;

  const PizzaChartLegend({Key? key, required this.chartData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: chartData.map((data) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4.0,left: 8.0),
          child: Row(
            children: [
              Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  color: data.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                '${data.category}: ${data.value}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}