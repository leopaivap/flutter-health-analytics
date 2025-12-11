// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/health_record_model.dart';
import '../services/data_repository.dart';
import 'dart:math' as math;

/// Tela de Recomendações Personalizadas
/// Sistema inteligente de recomendações baseado em análise de dados do usuário
class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({Key? key}) : super(key: key);

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  late List<HealthRecordModel> _records;
  bool _isLoading = true;
  Map<String, dynamic>? _userProfile;
  List<Map<String, dynamic>> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _loadDataAndGenerateRecommendations();
  }

  void _loadDataAndGenerateRecommendations() {
    setState(() {
      _isLoading = true;
    });

    _records = DataRepository.generateMockData();

    // Últimos 30 dias para análise
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
    _records = _records.where((r) => r.data.isAfter(cutoffDate)).toList();

    _userProfile = _analyzeUserProfile();
    _recommendations = _generateRecommendations();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recomendações Personalizadas'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDataAndGenerateRecommendations,
            tooltip: 'Atualizar Recomendações',
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
                  _buildHeaderCard(),
                  const SizedBox(height: 24),
                  _buildUserProfileSection(),
                  const SizedBox(height: 24),
                  _buildRecommendationsSection(),
                  const SizedBox(height: 24),
                  _buildGoalsSection(),
                  const SizedBox(height: 24),
                  _buildDisclaimerSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sistema de Recomendações Personalizadas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Baseado em Análise de Dados & Ciência de Dados',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_recommendations.length} recomendações personalizadas geradas',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection() {
    if (_userProfile == null) return const SizedBox();

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
              Icon(Icons.person, color: Colors.teal),
              SizedBox(width: 8),
              Text(
                'Seu Perfil Nutricional',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProfileMetric(
            'Ingestão Média Diária',
            '${_userProfile!['avgIntake'].toStringAsFixed(0)} kcal',
            Icons.restaurant,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildProfileMetric(
            'Gasto Médio Diário',
            '${_userProfile!['avgExpenditure'].toStringAsFixed(0)} kcal',
            Icons.fitness_center,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildProfileMetric(
            'Balanço Calórico',
            '${_userProfile!['balance'] >= 0 ? '+' : ''}${_userProfile!['balance'].toStringAsFixed(0)} kcal/dia',
            _userProfile!['balance'] >= 0
                ? Icons.trending_up
                : Icons.trending_down,
            _userProfile!['balance'] >= 0 ? Colors.red : Colors.green,
          ),
          const SizedBox(height: 12),
          _buildProfileMetric(
            'Categoria Dominante',
            _userProfile!['dominantCategory'],
            Icons.pie_chart,
            Colors.purple,
          ),
          const SizedBox(height: 12),
          _buildProfileMetric(
            'Consistência de Exercícios',
            '${(_userProfile!['exerciseFrequency'] * 100).toStringAsFixed(0)}% dos dias',
            Icons.event_available,
            Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMetric(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.tips_and_updates, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              'Recomendações Personalizadas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._recommendations.map((rec) => _buildRecommendationCard(rec)),
      ],
    );
  }

  Widget _buildRecommendationCard(Map<String, dynamic> recommendation) {
    final priority = recommendation['priority'] as String;
    final color = _getPriorityColor(priority);
    final icon = _getPriorityIcon(priority);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            priority.toUpperCase(),
                            style: TextStyle(
                              color: color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            recommendation['category'],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recommendation['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            recommendation['description'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          if (recommendation['scientificBasis'] != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.science, color: Colors.blue.shade700, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '📚 ${recommendation['scientificBasis']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (recommendation['actionItems'] != null) ...[
            const SizedBox(height: 12),
            ...((recommendation['actionItems'] as List).map(
              (action) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, color: color, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(action, style: const TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildGoalsSection() {
    final goals = _generateGoals();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade50, Colors.indigo.shade100],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag, color: Colors.indigo.shade700),
              const SizedBox(width: 8),
              Text(
                'Metas Sugeridas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...goals.map(
            (goal) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.radio_button_checked,
                    color: Colors.indigo.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal['title'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          goal['description'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.indigo.shade700,
                          ),
                        ),
                      ],
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

  Widget _buildDisclaimerSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Colors.grey.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'Aviso Importante',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Estas recomendações são geradas por algoritmos de ciência de dados e têm caráter educacional. Consulte um profissional de saúde ou nutricionista para orientações personalizadas e ajustadas às suas necessidades individuais.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _analyzeUserProfile() {
    if (_records.isEmpty) {
      return {
        'avgIntake': 0.0,
        'avgExpenditure': 0.0,
        'balance': 0.0,
        'dominantCategory': 'N/A',
        'exerciseFrequency': 0.0,
      };
    }

    // Agrupar por dia
    final dailyData = <DateTime, Map<String, double>>{};
    for (var record in _records) {
      final dateKey = DateTime(
        record.data.year,
        record.data.month,
        record.data.day,
      );
      dailyData[dateKey] =
          dailyData[dateKey] ?? {'intake': 0.0, 'expenditure': 0.0};

      if (record.tipo == RecordType.ingestao) {
        dailyData[dateKey]!['intake'] =
            dailyData[dateKey]!['intake']! + record.calorias;
      } else {
        dailyData[dateKey]!['expenditure'] =
            dailyData[dateKey]!['expenditure']! + record.calorias;
      }
    }

    final avgIntake =
        dailyData.values.map((d) => d['intake']!).reduce((a, b) => a + b) /
        dailyData.length;
    final avgExpenditure =
        dailyData.values.map((d) => d['expenditure']!).reduce((a, b) => a + b) /
        dailyData.length;
    final balance = avgIntake - avgExpenditure;

    // Categoria dominante
    final categoryCount = <String, int>{};
    for (var record in _records) {
      categoryCount[record.categoria] =
          (categoryCount[record.categoria] ?? 0) + 1;
    }
    final dominantCategory = categoryCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    // Frequência de exercícios
    final daysWithExercise = dailyData.values
        .where((d) => d['expenditure']! > 0)
        .length;
    final exerciseFrequency = daysWithExercise / dailyData.length;

    return {
      'avgIntake': avgIntake,
      'avgExpenditure': avgExpenditure,
      'balance': balance,
      'dominantCategory': dominantCategory,
      'exerciseFrequency': exerciseFrequency,
    };
  }

  List<Map<String, dynamic>> _generateRecommendations() {
    final recommendations = <Map<String, dynamic>>[];

    if (_userProfile == null) return recommendations;

    // Recomendação 1: Balanço Calórico
    if (_userProfile!['balance'] > 500) {
      recommendations.add({
        'priority': 'alta',
        'category': 'Nutrição',
        'title': 'Reduzir Excesso Calórico',
        'description':
            'Seu balanço calórico está muito positivo (+${_userProfile!['balance'].toStringAsFixed(0)} kcal/dia). Isso pode resultar em ganho de peso não desejado. Considere reduzir porções ou aumentar atividade física.',
        'scientificBasis':
            'Um excesso de ~500 kcal/dia pode resultar em ganho de ~0.5 kg/semana (3500 kcal ≈ 0.45 kg de gordura).',
        'actionItems': [
          'Reduzir porções em 20-30%',
          'Substituir alimentos calóricos por opções mais leves',
          'Aumentar frequência de exercícios',
        ],
      });
    } else if (_userProfile!['balance'] < -500) {
      recommendations.add({
        'priority': 'média',
        'category': 'Nutrição',
        'title': 'Déficit Calórico Acentuado',
        'description':
            'Você está em déficit calórico significativo (${_userProfile!['balance'].toStringAsFixed(0)} kcal/dia). Se o objetivo é perda de peso, ótimo! Caso contrário, aumente a ingestão.',
        'scientificBasis':
            'Déficits muito grandes (>1000 kcal) podem causar perda de massa muscular e metabolismo lento.',
        'actionItems': [
          'Monitore peso semanalmente',
          'Se perda > 1 kg/semana, aumente calorias',
          'Garanta proteína adequada (1.6-2g/kg)',
        ],
      });
    }

    // Recomendação 2: Exercício
    if (_userProfile!['exerciseFrequency'] < 0.5) {
      recommendations.add({
        'priority': 'alta',
        'category': 'Atividade Física',
        'title': 'Aumentar Frequência de Exercícios',
        'description':
            'Você se exercita em apenas ${(_userProfile!['exerciseFrequency'] * 100).toStringAsFixed(0)}% dos dias. A OMS recomenda pelo menos 150 min/semana de atividade moderada.',
        'scientificBasis':
            'Exercício regular reduz risco de doenças cardiovasculares, diabetes tipo 2 e melhora saúde mental (OMS, 2020).',
        'actionItems': [
          'Meta: 30 min de exercício, 5x/semana',
          'Iniciar com caminhadas leves',
          'Progressão gradual em intensidade',
        ],
      });
    }

    // Recomendação 3: Variedade Nutricional
    final categoryDiversity = _calculateCategoryDiversity();
    if (categoryDiversity < 0.6) {
      recommendations.add({
        'priority': 'média',
        'category': 'Nutrição',
        'title': 'Aumentar Variedade Alimentar',
        'description':
            'Sua dieta tem baixa diversidade (${(categoryDiversity * 100).toStringAsFixed(0)}% de variedade). Dietas variadas fornecem mais micronutrientes.',
        'scientificBasis':
            'Diversidade alimentar está associada a melhor ingestão de vitaminas e minerais (Ruel, 2003).',
        'actionItems': [
          'Incluir vegetais de cores diferentes',
          'Alternar fontes proteicas',
          'Experimentar novos alimentos semanalmente',
        ],
      });
    }

    // Recomendação 4: Consistência
    final consistency = _calculateConsistency();
    if (consistency < 0.7) {
      recommendations.add({
        'priority': 'baixa',
        'category': 'Comportamento',
        'title': 'Melhorar Consistência',
        'description':
            'Sua rotina nutricional varia muito dia a dia. Maior consistência facilita alcançar objetivos de longo prazo.',
        'scientificBasis':
            'Hábitos consistentes são preditores de sucesso em mudanças de comportamento (Gardner et al., 2012).',
        'actionItems': [
          'Estabelecer horários regulares para refeições',
          'Preparar refeições com antecedência',
          'Usar lembretes para manter rotina',
        ],
      });
    }

    // Recomendação 5: Hidratação (genérica)
    recommendations.add({
      'priority': 'baixa',
      'category': 'Saúde Geral',
      'title': 'Manter Hidratação Adequada',
      'description':
          'Lembre-se de manter hidratação adequada (2-3L água/dia). Desidratação afeta performance física e cognição.',
      'scientificBasis':
          'Desidratação de 2% do peso corporal reduz performance física em até 20% (Casa et al., 2000).',
      'actionItems': [
        'Beber água ao acordar',
        'Ter garrafa de água sempre acessível',
        'Monitorar cor da urina (deve ser clara)',
      ],
    });

    return recommendations;
  }

  List<Map<String, dynamic>> _generateGoals() {
    final goals = <Map<String, dynamic>>[];

    if (_userProfile!['balance'] > 0) {
      goals.add({
        'title': 'Manter Balanço Calórico Neutro',
        'description': 'Reduzir balanço para 0-200 kcal/dia em 2 semanas',
      });
    } else {
      goals.add({
        'title': 'Perder 0.5 kg/semana',
        'description': 'Manter déficit de ~500 kcal/dia de forma sustentável',
      });
    }

    if (_userProfile!['exerciseFrequency'] < 0.7) {
      goals.add({
        'title': 'Exercitar-se 5x/semana',
        'description': 'Alcançar 150 min/semana de atividade moderada',
      });
    }

    goals.add({
      'title': 'Aumentar Ingestão de Proteínas',
      'description': 'Meta: 1.6-2.0g proteína/kg peso corporal',
    });

    goals.add({
      'title': 'Reduzir Processados',
      'description': 'Preferir alimentos in natura e minimamente processados',
    });

    return goals;
  }

  double _calculateCategoryDiversity() {
    final categories = _records.map((r) => r.categoria).toSet();
    final totalCategories = HealthCategories.allCategories.length;
    return categories.length / totalCategories;
  }

  double _calculateConsistency() {
    // Calcula CV (coeficiente de variação) do balanço calórico diário
    final dailyBalance = <double>[];
    final dailyData = <DateTime, double>{};

    for (var record in _records) {
      final dateKey = DateTime(
        record.data.year,
        record.data.month,
        record.data.day,
      );
      dailyData[dateKey] = (dailyData[dateKey] ?? 0) + record.caloriasLiquidas;
    }

    dailyBalance.addAll(dailyData.values);

    if (dailyBalance.isEmpty) return 1.0;

    final mean = dailyBalance.reduce((a, b) => a + b) / dailyBalance.length;
    final variance =
        dailyBalance.map((b) => math.pow(b - mean, 2)).reduce((a, b) => a + b) /
        dailyBalance.length;
    final stdDev = math.sqrt(variance);

    // CV = stdDev / mean (quanto menor, mais consistente)
    // Normalizar: 1 - (CV / 2) para que 0 = inconsistente, 1 = muito consistente
    final cv = mean.abs() > 0 ? stdDev / mean.abs() : 0;
    return (1 - (cv / 2)).clamp(0, 1);
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'alta':
        return Colors.red;
      case 'média':
        return Colors.orange;
      case 'baixa':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case 'alta':
        return Icons.warning;
      case 'média':
        return Icons.info;
      case 'baixa':
        return Icons.lightbulb;
      default:
        return Icons.help;
    }
  }
}
