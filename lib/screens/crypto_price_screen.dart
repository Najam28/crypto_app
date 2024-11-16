import 'dart:async';
import 'dart:math';

import 'package:crypto_app/screens/price_screen.dart';
import 'package:flutter/material.dart';

class CryptoPriceScreen extends StatefulWidget {
  const CryptoPriceScreen({super.key});

  @override
  State<CryptoPriceScreen> createState() => _CryptoPriceScreenState();
}

class _CryptoPriceScreenState extends State<CryptoPriceScreen> {
  final StreamController<Map<String, dynamic>> _priceController =
      StreamController.broadcast();
  final List<Map<String, dynamic>> _priceHistory = [];
  int _btcDropCount = 0;
  int _ethDropCount = 0;

  @override
  void initState() {
    super.initState();
    _startPriceUpdates();
  }

  void _startPriceUpdates() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final random = Random();
      final btcPrice = 500 + random.nextInt(2500);
      final ethPrice = 500 + random.nextInt(2500);
      final prices = {
        'BTC': btcPrice,
        'ETH': ethPrice,
        'time': DateTime.now(),
      };

      _priceController.add(prices);
      _priceHistory.add(prices);

      if (btcPrice < 1500) _btcDropCount++;
      if (ethPrice < 1500) _ethDropCount++;

      if (_btcDropCount >= 10 || _ethDropCount >= 10) {
        _priceController.close();
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PriceListScreen(
              priceHistory: _priceHistory,
              stream: _priceController.stream,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _priceController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade300,
        title: const Text(
          'Crypto Prices',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: _priceController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final prices = snapshot.data!;
          return ListView(
            children: [
              _buildPriceTile('BTC', prices['BTC']),
              _buildPriceTile('ETH', prices['ETH']),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Last updated: ${prices['time']}'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPriceTile(String crypto, int price) {
    return ListTile(
      title: Text('$crypto Price: \$${price.toString()}'),
      tileColor: price < 1500 ? Colors.red.shade400 : null,
    );
  }
}
