import 'dart:math';

class FormulaEvaluator {
  final Map<String, Function> _formulas = {
    'SUM': (List<double> numbers) => numbers.reduce((a, b) => a + b),
    'AVERAGE': (List<double> numbers) =>
        numbers.reduce((a, b) => a + b) / numbers.length,
    'COUNT': (List<double> numbers) => numbers.length,
    'MAX': (List<double> numbers) => numbers.reduce((a, b) => a > b ? a : b),
    'MIN': (List<double> numbers) => numbers.reduce((a, b) => a < b ? a : b),
    'PRODUCT': (List<double> numbers) => numbers.reduce((a, b) => a * b),
    'MEDIAN': (List<double> numbers) {
      final sortedNumbers = [...numbers]..sort();
      if (sortedNumbers.length % 2 == 1) {
        return sortedNumbers[sortedNumbers.length ~/ 2];
      } else {
        final mid = sortedNumbers.length ~/ 2;
        return (sortedNumbers[mid - 1] + sortedNumbers[mid]) / 2;
      }
    },
    'POWER': (List<double> numbers) => pow(numbers[0], numbers[1]),
    'SQRT': (List<double> numbers) => sqrt(numbers[0]),
    'LN': (List<double> numbers) => log(numbers[0]),
    'LOG': (List<double> numbers) => log(numbers[0]) / ln10,
    'EXP': (List<double> numbers) => exp(numbers[0]),
    'ABS': (List<double> numbers) => numbers[0].abs(),
    'ROUND': (List<double> numbers) => numbers[0].roundToDouble(),
    'CEILING': (List<double> numbers) => numbers[0].ceilToDouble(),
    'FLOOR': (List<double> numbers) => numbers[0].floorToDouble(),
    'MOD': (List<double> numbers) => numbers[0] % numbers[1],
    'SIN': (List<double> numbers) => sin(numbers[0]),
    'COS': (List<double> numbers) => cos(numbers[0]),
    'TAN': (List<double> numbers) => tan(numbers[0]),
    'ASIN': (List<double> numbers) => asin(numbers[0]),
    'ACOS': (List<double> numbers) => acos(numbers[0]),
    'ATAN': (List<double> numbers) => atan(numbers[0]),
    'IF': (List<double> args) {
      if (args.length < 3) {
        throw Exception('IF formula requires at least 3 arguments');
      }
      return args[0] != 0.0 ? args[1] : args[2];
    },
    'IFELSE': (List<double> args) {
      if (args.length < 4) {
        throw Exception('IFELSE formula requires at least 4 arguments');
      }
      return args[0] != 0.0 ? args[1] : args[2];
    },
  };

  double evaluate(String formula) {
    var parts = formula.split('(');
    if (parts.length < 2) {
      throw Exception('Invalid formula format');
    }

    var functionName =
        parts[0].toUpperCase().substring(1); // Remove the leading =
    var arguments = parts[1].replaceAll(')', '').split(',');

    if (!_formulas.containsKey(functionName)) {
      throw Exception('Unknown formula: $functionName');
    }

    var argumentsAsNumbers =
        arguments.map((arg) => double.tryParse(arg) ?? 0.0).toList();

    return _formulas[functionName]!(argumentsAsNumbers);
  }
}
