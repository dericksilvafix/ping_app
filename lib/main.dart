import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ping App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PingPage(),
    );
  }
}

class PingPage extends StatefulWidget {
  @override
  _PingPageState createState() => _PingPageState();
}

class _PingPageState extends State<PingPage> {
  final TextEditingController _ipController = TextEditingController();
  String _result = '';
  bool _isPinging = false;

  Future<void> _pingIP(String ip) async {
    setState(() {
      _isPinging = true;
      _result = 'Ping...';
    });

    try {
      final result = await Process.run('ping', ['-c', '4', ip]);
      setState(() {
        _result = result.stdout.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Erro ao tentar fazer o ping: $e';
      });
    }

    setState(() {
      _isPinging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ping IP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _ipController,
              decoration: InputDecoration(
                labelText: 'Digite o IP',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isPinging
                  ? null
                  : () {
                String ip = _ipController.text.trim();
                if (ip.isNotEmpty) {
                  _pingIP(ip);
                } else {
                  setState(() {
                    _result = 'Insira um IP válido.';
                  });
                }
              },
              child: Text('Ping'),
            ),
            SizedBox(height: 20),
            if (_isPinging)
              Center(child: CircularProgressIndicator())
            else
              Text(
                _result,
                style: TextStyle(fontFamily: 'monospace'),
              ),
          ],
        ),
      ),
    );
  }
}