import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

const _chartColors = [
  Colors.blue,
  Colors.orange,
  Colors.teal,
  Colors.purple,
  Colors.pink,
  Colors.cyan,
  Colors.amber,
  Colors.indigo,
  Colors.lime,
  Colors.red,
];

class TagDistributionChart extends StatelessWidget {
  final Map<String, double> data;
  final String currencySymbol;
  final double total;

  const TagDistributionChart({
    super.key,
    required this.data,
    required this.currencySymbol,
    required this.total,
  });

  String _formatMoney(double value) => value.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No data', style: TextStyle(color: Colors.grey)),
      );
    }

    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                for (int i = 0; i < entries.length; i++)
                  PieChartSectionData(
                    value: entries[i].value,
                    color: _chartColors[i % _chartColors.length],
                    title: '${(entries[i].value / total * 100).round()}%',
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    radius: 50,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...entries.asMap().entries.map((e) {
          final index = e.key;
          final tag = e.value.key;
          final amount = e.value.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _chartColors[index % _chartColors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(tag)),
                Text('$currencySymbol ${_formatMoney(amount)}'),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class RecurringSplitChart extends StatelessWidget {
  final double recurringTotal;
  final double oneTimeTotal;
  final String currencySymbol;

  const RecurringSplitChart({
    super.key,
    required this.recurringTotal,
    required this.oneTimeTotal,
    required this.currencySymbol,
  });

  String _formatMoney(double value) => value.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final total = recurringTotal + oneTimeTotal;
    if (total == 0) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No data', style: TextStyle(color: Colors.grey)),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 30,
              sections: [
                if (recurringTotal > 0)
                  PieChartSectionData(
                    value: recurringTotal,
                    color: Colors.blue,
                    title: '${(recurringTotal / total * 100).round()}%',
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    radius: 40,
                  ),
                if (oneTimeTotal > 0)
                  PieChartSectionData(
                    value: oneTimeTotal,
                    color: Colors.orange,
                    title: '${(oneTimeTotal / total * 100).round()}%',
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    radius: 40,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(child: Text('Recurring')),
              Text('$currencySymbol ${_formatMoney(recurringTotal)}'),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(child: Text('One-time')),
              Text('$currencySymbol ${_formatMoney(oneTimeTotal)}'),
            ],
          ),
        ),
      ],
    );
  }
}
