import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';


class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  List<Map<String, dynamic>> _transactions = [
    {'id': 1, 'operation': 'sell', 'currency': 'CNY', 'quantity': 758.3, 'rate': 531.03},
    {'id': 98, 'operation': 'sell', 'currency': 'RUB', 'quantity': 975.8, 'rate': 319.83},
    {'id': 99, 'operation': 'buy', 'currency': 'RUB', 'quantity': 928.74, 'rate': 349.3},
    {'id': 100, 'operation': 'sell', 'currency': 'USD', 'quantity': 979.07, 'rate': 80.38},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Обзор"),
              background: Container(
                color: Colors.blueGrey,
              ),
            ),
            actions: [

            ],
          ),
          _buildSectionTitle("По валютам"),
          _buildTransactionList(),
          _buildSectionTitle("По количеству транзакций"),
          _buildTransactionList(),
          _buildSectionTitle("По динамике роста"),
          _buildTransactionList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.currency_exchange), label: 'Продажа/Покупка'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'История'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Статистика'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Настройки'),
        ],
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0: Navigator.pushReplacementNamed(context, '/home'); break;
            case 1: Navigator.pushReplacementNamed(context, '/event'); break;
            case 3: Navigator.pushReplacementNamed(context, '/profile'); break;
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var transaction = _transactions[index % _transactions.length];
          return ListTile(
            title: Text(
              "${transaction['currency']} - ${transaction['operation']}",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text("Количество: ${transaction['quantity']}", style: TextStyle(color: Colors.grey)),
          );
        },
        childCount: 10,
      ),
    );
  }
}
