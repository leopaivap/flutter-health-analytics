// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/health_record_model.dart';
import '../services/data_repository.dart';

/// Tela de Análise de Tendências
/// Exibe análises estatísticas e gráficos de evolução temporal
class TrendsScreen extends StatefulWidget {
  const TrendsScreen({super.key});

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  late List<HealthRecordModel> _records;
  bool _isLoading = true;
  String _selectedPeriod = '30'; // dias

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _isLoading = true;
    });

    _records = DataRepository.generateMockData();

    // Filtrar por período
    final days = int.parse(_selectedPeriod);
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    _records = _records.where((r) => r.data.isAfter(cutoffDate)).toList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise de Tendências'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
                _loadData();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '7', child: Text('Últimos 7 dias')),
              const PopupMenuItem(value: '30', child: Text('Últimos 30 dias')),
              const PopupMenuItem(value: '90', child: Text('Últimos 90 dias')),
              const PopupMenuItem(value: '180', child: Text('Últimos 6 meses')),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPeriodIndicator(),
                  const SizedBox(height: 24),
                  _buildStatisticsCards(),
                  const SizedBox(height: 24),
                  _buildWeightTrendChart(),
                  const SizedBox(height: 24),
                  _buildCalorieDistributionChart(),
                  const SizedBox(height: 24),
                  _buildMovingAverageChart(),
                  const SizedBox(height: 24),
                  _buildInsightsSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildPeriodIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.purple.shade600],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Período de Análise',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  _selectedPeriod == '7'
                      ? 'Últimos 7 dias'
                      : _selectedPeriod == '30'
                      ? 'Últimos 30 dias'
                      : _selectedPeriod == '90'
                      ? 'Últimos 90 dias'
                      : 'Últimos 6 meses',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${_records.length} registros',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards() {
    final stats = _calculateStatistics();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estatísticas do Período',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Balanço Médio',
                '${stats['avgBalance']!.toStringAsFixed(0)} kcal',
                stats['avgBalance']! >= 0
                    ? Icons.trending_up
                    : Icons.trending_down,
                stats['avgBalance']! >= 0 ? Colors.orange : Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Desvio Padrão',
                '${stats['stdDev']!.toStringAsFixed(0)} kcal',
                Icons.show_chart,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Tendência Peso',
                '${stats['weightTrend']! >= 0 ? '+' : ''}${stats['weightTrend']!.toStringAsFixed(2)} kg',
                stats['weightTrend']! >= 0
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                stats['weightTrend']! >= 0 ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Consistência',
                '${stats['consistency']!.toStringAsFixed(0)}%',
                Icons.check_circle_outline,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey.shade900,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightTrendChart() {
    final weightData = _calculateWeightProgression();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up, color: Colors.purple),
              SizedBox(width: 8),
              Text(
                'Projeção de Peso',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Baseado no balanço calórico acumulado (7700 kcal = 1 kg)',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(1)} kg',
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < weightData.length) {
                          final date = weightData[index]['date'] as DateTime;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${date.day}/${date.month}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: weightData.asMap().entries.map((e) {
                      return FlSpot(
                        e.key.toDouble(),
                        e.value['weight'] as double,
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.purple,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.purple,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.purple.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieDistributionChart() {
    final distribution = _calculateCalorieDistribution();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Distribuição Calórica por Categoria',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 500,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${(value / 1000).toStringAsFixed(1)}k',
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 80,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < distribution.length) {
                          final category =
                              distribution[index]['category'] as String;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Transform.rotate(
                              angle: -0.5,
                              child: Text(
                                category,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: distribution.asMap().entries.map((e) {
                  final index = e.key;
                  final data = e.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data['calories'] as double,
                        color: _getCategoryColor(data['category'] as String),
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovingAverageChart() {
    final movingAvg = _calculateMovingAverage(7);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.show_chart, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Média Móvel (7 dias) - Balanço Calórico',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Suaviza flutuações diárias para identificar tendências',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: movingAvg.length / 5,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < movingAvg.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: movingAvg.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value);
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsSection() {
    final insights = _generateInsights();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.amber.shade800),
              const SizedBox(width: 8),
              Text(
                'Insights da Análise',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...insights.map(
            (insight) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.amber.shade700,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      insight,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, double> _calculateStatistics() {
    if (_records.isEmpty) {
      return {'avgBalance': 0, 'stdDev': 0, 'weightTrend': 0, 'consistency': 0};
    }

    // Agrupar por dia
    final dailyBalance = <DateTime, double>{};
    for (var record in _records) {
      final dateKey = DateTime(
        record.data.year,
        record.data.month,
        record.data.day,
      );
      dailyBalance[dateKey] =
          (dailyBalance[dateKey] ?? 0) + record.caloriasLiquidas;
    }

    final balances = dailyBalance.values.toList();
    final avgBalance = balances.reduce((a, b) => a + b) / balances.length;

    final variance =
        balances
            .map((b) => (b - avgBalance) * (b - avgBalance))
            .reduce((a, b) => a + b) /
        balances.length;
    final stdDev = variance > 0 ? Math.sqrt(variance).toDouble() : 0.0;

    final totalBalance = balances.reduce((a, b) => a + b);
    final weightTrend = totalBalance / 7700; // 7700 kcal = 1 kg

    // Consistência: % de dias com balanço próximo da meta (±500 kcal)
    final consistentDays = balances.where((b) => b.abs() <= 500).length;
    final consistency = (consistentDays / balances.length) * 100;

    return {
      'avgBalance': avgBalance,
      'stdDev': stdDev,
      'weightTrend': weightTrend,
      'consistency': consistency,
    };
  }

  List<Map<String, dynamic>> _calculateWeightProgression() {
    if (_records.isEmpty) return [];

    const initialWeight = 70.0; // Peso inicial padrão
    final progression = <Map<String, dynamic>>[];

    // Agrupar por dia
    final dailyBalance = <DateTime, double>{};
    for (var record in _records) {
      final dateKey = DateTime(
        record.data.year,
        record.data.month,
        record.data.day,
      );
      dailyBalance[dateKey] =
          (dailyBalance[dateKey] ?? 0) + record.caloriasLiquidas;
    }

    final sortedDates = dailyBalance.keys.toList()..sort();
    double cumulativeBalance = 0;

    for (var date in sortedDates) {
      cumulativeBalance += dailyBalance[date]!;
      final weightChange = cumulativeBalance / 7700;
      progression.add({'date': date, 'weight': initialWeight + weightChange});
    }

    return progression;
  }

  List<Map<String, dynamic>> _calculateCalorieDistribution() {
    final distribution = <String, double>{};

    for (var record in _records) {
      final category = record.categoria;
      distribution[category] =
          (distribution[category] ?? 0) + record.calorias.abs();
    }

    return distribution.entries
        .map((e) => {'category': e.key, 'calories': e.value})
        .toList()
      ..sort(
        (a, b) => (b['calories'] as double).compareTo(a['calories'] as double),
      );
  }

  List<double> _calculateMovingAverage(int window) {
    if (_records.isEmpty) return [];

    // Agrupar por dia
    final dailyBalance = <DateTime, double>{};
    for (var record in _records) {
      final dateKey = DateTime(
        record.data.year,
        record.data.month,
        record.data.day,
      );
      dailyBalance[dateKey] =
          (dailyBalance[dateKey] ?? 0) + record.caloriasLiquidas;
    }

    final sortedBalances = dailyBalance.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final movingAvg = <double>[];
    for (int i = 0; i < sortedBalances.length; i++) {
      final start = Math.max(0, i - window + 1);
      final windowData = sortedBalances.sublist(start, i + 1);
      final avg =
          windowData.map((e) => e.value).reduce((a, b) => a + b) /
          windowData.length;
      movingAvg.add(avg);
    }

    return movingAvg;
  }

  List<String> _generateInsights() {
    final stats = _calculateStatistics();
    final insights = <String>[];

    if (stats['avgBalance']! > 300) {
      insights.add(
        'Seu balanço calórico médio está positivo (+${stats['avgBalance']!.toStringAsFixed(0)} kcal/dia). Isso pode resultar em ganho de peso.',
      );
    } else if (stats['avgBalance']! < -300) {
      insights.add(
        'Seu balanço calórico médio está negativo (${stats['avgBalance']!.toStringAsFixed(0)} kcal/dia). Você está em déficit calórico.',
      );
    } else {
      insights.add(
        'Seu balanço calórico está equilibrado (${stats['avgBalance']!.toStringAsFixed(0)} kcal/dia). Ótimo para manutenção do peso!',
      );
    }

    if (stats['stdDev']! > 800) {
      insights.add(
        'Alta variabilidade no balanço calórico (σ = ${stats['stdDev']!.toStringAsFixed(0)}). Considere manter uma rotina mais consistente.',
      );
    } else {
      insights.add(
        'Baixa variabilidade no balanço calórico (σ = ${stats['stdDev']!.toStringAsFixed(0)}). Você mantém uma rotina consistente!',
      );
    }

    if (stats['weightTrend']!.abs() > 2) {
      insights.add(
        'Tendência de ${stats['weightTrend']! > 0 ? 'ganho' : 'perda'} de ${stats['weightTrend']!.abs().toStringAsFixed(1)} kg no período.',
      );
    }

    if (stats['consistency']! >= 70) {
      insights.add(
        'Alta consistência (${stats['consistency']!.toStringAsFixed(0)}% dos dias com balanço equilibrado). Continue assim!',
      );
    } else {
      insights.add(
        'Consistência moderada (${stats['consistency']!.toStringAsFixed(0)}%). Tente manter o balanço mais próximo da meta diária.',
      );
    }

    return insights;
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Café da Manhã':
        return Colors.orange;
      case 'Almoço':
        return Colors.red;
      case 'Jantar':
        return Colors.purple;
      case 'Lanche':
        return Colors.amber;
      case 'Corrida':
        return Colors.blue;
      case 'Caminhada':
        return Colors.green;
      case 'Musculação':
        return Colors.red.shade700;
      case 'Yoga':
        return Colors.purple.shade300;
      default:
        return Colors.grey;
    }
  }
}

// Extensão para calcular raiz quadrada
extension Math on double {
  static double sqrt(double value) => value < 0
      ? 0
      : value == 0
      ? 0
      : _sqrtImpl(value);

  static double _sqrtImpl(double x) {
    if (x == 0) return 0;
    double z = (x + 1) / 2;
    double y = x;
    while (z < y) {
      y = z;
      z = (x / z + z) / 2;
    }
    return y;
  }

  static int max(int a, int b) => a > b ? a : b;
}
