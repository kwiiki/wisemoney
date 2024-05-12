import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'expense_model.dart';
import 'fund_condition_widget.dart';
import 'item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomePageState();
}

List options = ["Expense", "Income"];
List<ExpenseModel> expenses = [];

class _HomePageState extends State<Home> {
  final itemController = TextEditingController();
  final amountController = TextEditingController();
  late final Box<ExpenseModel> _expensesBox;
  int amount = 0;
  final dateController = TextEditingController();
  int totalMoney = 0;
  int spentMoney = 0;
  int income = 0;
  String currentOption = options[0];
  String dialogOption = options[0];

  @override
  void initState() {
    super.initState();
    _expensesBox = Hive.box('expenses');
    _loadExpenses();
    _setCurrentDate();
  }

  void _loadExpenses() {
    expenses = _expensesBox.values.toList();
    _calculateTotals();
  }

  void _saveExpense(ExpenseModel expense) {
    _expensesBox.add(expense);
    setState(() {
      expenses.add(expense);
      _calculateTotals();
    });
  }

  void _deleteExpense(ExpenseModel expense) {
    _expensesBox.delete(expense.key);
    setState(() {
      expenses.remove(expense);
      _calculateTotals();
    });
  }

  void _calculateTotals() {
    totalMoney = 0;
    spentMoney = 0;
    income = 0;
    for (var expense in expenses) {
      if (expense.isIncome) {
        income += expense.amount;
      } else {
        spentMoney += expense.amount;
      }
    }
    totalMoney = income - spentMoney;
  }

  void _setCurrentDate() {
    final now = DateTime.now();
    String date = DateFormat.yMMMMd().format(now);
    dateController.text = date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: SizedBox(
        height: 67,
        child: FloatingActionButton(
          backgroundColor: Colors.orangeAccent,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: 400,
                  child: AlertDialog(
                    title: const Padding(
                      padding: EdgeInsets.only(left: 1.6),
                      child: Text("Add Entry"),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (itemController.text.isNotEmpty &&
                              amountController.text.isNotEmpty &&
                              double.tryParse(amountController.text) != null) {
                            double amount = double.parse(amountController.text);
                            final expense = ExpenseModel(
                              item: itemController.text,
                              amount: amount.toInt(),
                              isIncome: dialogOption == "Income" ? true : false,
                              date: DateTime.now(),
                            );
                            _saveExpense(expense);

                            itemController.clear();
                            amountController.clear();
                            Navigator.pop(context);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text(
                                      "Please enter a valid amount and fill in all the required fields."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("OK"),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text(
                          "Add",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                    content: SizedBox(
                      height: 250,
                      width: 400,
                      child: Column(
                        children: [
                          TextField(
                            controller: itemController,
                            decoration: const InputDecoration(
                              hintText: "Item Name",
                              hintStyle: TextStyle(
                                color: Colors.blueGrey,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            decoration: const InputDecoration(
                              hintText: "Amount ",
                              helperText: "Enter a valid amount with number",
                              helperStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          RadioMenuButton(
                            value: options[0],
                            groupValue: dialogOption,
                            onChanged: (expense) {
                              setState(() {
                                dialogOption = expense.toString();
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                "Expense",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.4,
                                ),
                              ),
                            ),
                          ),
                          RadioMenuButton(
                            style: ButtonStyle(
                              iconSize: MaterialStateProperty.all(20),
                            ),
                            value: options[1],
                            groupValue: dialogOption,
                            onChanged: (income) {
                              setState(() {
                                dialogOption = income.toString();
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                "Income",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.add, size: 26),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 8),
                  child: FundCondition(
                    type: "Income",
                    amount: "$income",
                    icon: "grey",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: FundCondition(
                    type: "Expense",
                    amount: "$spentMoney",
                    icon: "orange",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FundCondition(
                    type: "Balance",
                    amount: "$totalMoney",
                    icon: "blue",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Delete Entry",
                              style: TextStyle(
                                fontSize: 19.0,
                              ),
                            ),
                            content: const Text(
                                "Are you sure you want to delete this entry?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  final myExpense = expenses[index];
                                  _deleteExpense(myExpense);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Item(
                      expense: ExpenseModel(
                        item: expenses[index].item,
                        amount: expenses[index].amount,
                        isIncome: expenses[index].isIncome,
                        date: expenses[index].date,
                      ),
                      onDelete: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
