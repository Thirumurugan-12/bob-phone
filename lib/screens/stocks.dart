import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

class PredictStockPage extends StatefulWidget {
  @override
  _PredictStockPageState createState() => _PredictStockPageState();
}

class _PredictStockPageState extends State<PredictStockPage> {
  Future<String>? _prediction;

  final _formKey = GlobalKey<FormState>();
  final _openController = TextEditingController();
  final _highController = TextEditingController();
  final _lowController = TextEditingController();
  final _adjCloseController = TextEditingController();
  final _volumeController = TextEditingController();

  Future<List<FlSpot>> _predictStocksPrices() async {
    List<FlSpot> predictions = [];

    for (int i = 0; i < 10; i++) {
      DateTime date = DateTime.now().add(Duration(days: i));
      final response = await http.post(
        Uri.parse(
            'https://trackriz-stocks.swedencentral.inference.ml.azure.com/score'), // replace with your API URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ('Bearer ' + 'KJQ29nNrnRrhHSXYiZct0Ff1H6he3TYt'),
          'azureml-model-deployment': 'stockapi'
        },
        body: jsonEncode({
          'Inputs': {
            'data': [
              {
                'Datetime': DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ')
                    .format(DateTime.now()),
                'Open': double.parse(_openController.text),
                'High': double.parse(_highController.text),
                'Low': double.parse(_lowController.text),
                'Adj Close': double.parse(_adjCloseController.text),
                'Volume': int.parse(_volumeController.text),
              },
            ],
          },
          'GlobalParameters': 0,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        List<dynamic> results = responseBody['Results'];
        double prediction = results[0];
        predictions.add(FlSpot(i.toDouble(), prediction));
      } else {
        throw Exception('Failed to predict stock price');
      }
    }

    return predictions;
  }

  Future<String> _predictStockPrice() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse(
            'https://trackriz-stocks.swedencentral.inference.ml.azure.com/score'), // replace with your API URL
        headers: {
          'Content-Type': 'application/json',
          'Authorization': ('Bearer ' + 'KJQ29nNrnRrhHSXYiZct0Ff1H6he3TYt'),
          'azureml-model-deployment': 'stockapi'
        },
        body: jsonEncode({
          'Inputs': {
            'data': [
              {
                'Datetime': DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ')
                    .format(DateTime.now()),
                'Open': double.parse(_openController.text),
                'High': double.parse(_highController.text),
                'Low': double.parse(_lowController.text),
                'Adj Close': double.parse(_adjCloseController.text),
                'Volume': int.parse(_volumeController.text),
              },
            ],
          },
          'GlobalParameters': 0,
        }),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to predict stock price ${response.body}');
      }
    } else {
      throw Exception('Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Predict Stock Price')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _openController,
                decoration: InputDecoration(labelText: 'Open'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _highController,
                decoration: InputDecoration(labelText: 'High'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lowController,
                decoration: InputDecoration(labelText: 'Low'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _adjCloseController,
                decoration: InputDecoration(labelText: 'Adj Close'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _volumeController,
                decoration: InputDecoration(labelText: 'Volume'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
              ),
              // add similar TextFormFields for Low, Adj Close, and Volume
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _prediction = _predictStockPrice();
                    _predictStocksPrices();
                  });
                },
                child: Text('Predict'),
              ),
              FutureBuilder<String>(
                future: _prediction,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text('Predicted Stock Price: ${snapshot.data}');
                  }
                },
              ),
              Container(
                height: 200,
                // width: 500,
                child: FutureBuilder<List<FlSpot>>(
                  future: _predictStocksPrices(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<FlSpot>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return ListView(
                        children: [
                          DataTable(
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text('Days'),
                              ),
                              DataColumn(
                                label: Text('Price'),
                              ),
                            ],
                            rows: snapshot.data!
                                .map(
                                  (spot) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text('${spot.x}')),
                                      DataCell(Text('${spot.y}')),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
