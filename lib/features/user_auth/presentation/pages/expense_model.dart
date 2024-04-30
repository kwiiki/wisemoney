import 'package:hive/hive.dart';

part 'expense_model.g.dart'; // This line will be added by the Hive code generator

@HiveType(typeId: 0)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  final String item;

  @HiveField(1)
  final int amount;

  @HiveField(2)
  final bool isIncome;

  @HiveField(3)
  final DateTime date;

  ExpenseModel({
    required this.item,
    required this.amount,
    required this.isIncome,
    required this.date,
  });
}