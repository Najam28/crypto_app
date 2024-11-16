import 'package:crypto_app/screens/crypto_price_screen.dart';
import 'package:flutter/material.dart';

class PriceListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> priceHistory;
  final Stream<Map<String, dynamic>> stream;

  const PriceListScreen({
    super.key,
    required this.priceHistory,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade300,
        title: const Text(
          'Price List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const CryptoPriceScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: priceHistory.length,
        itemBuilder: (context, index) {
          final entry = priceHistory[index];
          return ListTile(
            title: Text(
              'BTC: \$${entry['BTC']}, ETH: \$${entry['ETH']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('Time: ${entry['time']}'),
          );
        },
      ),
    );
  }
}
