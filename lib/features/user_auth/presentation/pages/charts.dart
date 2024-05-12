import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:wisemoney/features/user_auth/presentation/pages/expense_model.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

Color getRandomColor() {
  Random random = Random();
  // Generate a random color.
  return Color.fromRGBO(
    random.nextInt(256), // Red
    random.nextInt(256), // Green
    random.nextInt(256), // Blue
    1, // Opacity
  );
}

class _ReportState extends State<Report> {
  late Box<ExpenseModel> _expensesBox;
  Map<String, double> categories = {};
  double totalExpenses = 0;
  double totalIncome = 0;

  @override
  void initState() {
    super.initState();
    _expensesBox = Hive.box<ExpenseModel>('expenses');
    _loadData();
  }

  void _loadData() {
    final expenses = _expensesBox.values.toList();
    _calculateTotals(expenses);
  }

  void _calculateTotals(List<ExpenseModel> expenses) {
    double localTotalExpenses = 0;
    double localTotalIncome = 0;
    categories.clear();
    for (var expense in expenses) {
      if (!expense.isIncome) {
        localTotalExpenses += expense.amount;
        categories.update(
          expense.item,
              (value) => value + expense.amount,
          ifAbsent: () => expense.amount.toDouble(),
        );
      }else {
        localTotalIncome += expense.amount; // Sum income amounts.
      }
    }
    setState(() {
      totalExpenses = localTotalExpenses;
      totalIncome = localTotalIncome;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections = categories.entries.map((entry) {
      final percentage = (entry.value / totalExpenses) * 100;
      return PieChartSectionData(
        color: getRandomColor(),
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white
        ),
        titlePositionPercentageOffset: 0.55, // Adjust label position inside each slice
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Monthly Expenses",
          style: TextStyle(color: Colors.black), ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 44,
                      sections: sections,
                    ),
                  ),
                  Text(
                    '\$${totalIncome.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black), // Increased font size
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: categories.entries.map((entry) {
                  return ListTile(
                    leading: const CircleAvatar(backgroundColor: Colors.blue, radius: 12),
                    title: Text(entry.key),
                    subtitle: Text('\$${entry.value.toStringAsFixed(2)} (${(entry.value / totalExpenses * 100).toStringAsFixed(1)}%)'),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}