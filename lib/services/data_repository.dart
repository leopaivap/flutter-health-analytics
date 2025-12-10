import 'dart:math';
import '../models/health_record_model.dart';

/// Repositório de dados com geração de registros nutricionais e predição de peso
/// Projeto NutriHealth Analytics - Leonardo Paiva e Salomão Ferreira
///
/// CIÊNCIA DE DADOS APLICADA:
/// - Geração de dados sintéticos realistas baseados em padrões nutricionais
/// - Algoritmo de predição de peso usando princípios termodinâmicos (7700 kcal ≈ 1kg)
/// - Análise de balanço calórico e projeção de tendências corporais
class DataRepository {
  static final Random _random = Random();
  static List<HealthRecordModel>? _cachedRecords;

  /// Gera dados mockados realistas dos últimos 6 meses
  /// Simula um adulto com TMB (Taxa Metabólica Basal) de ~1500-1800 kcal
  /// Ingestão diária: 1800-2500 kcal | Gasto exercícios: 300-600 kcal
  static List<HealthRecordModel> generateMockData() {
    if (_cachedRecords != null) {
      return _cachedRecords!;
    }

    List<HealthRecordModel> records = [];
    DateTime now = DateTime.now();

    // Gerar registros dos últimos 180 dias (6 meses)
    for (int daysAgo = 0; daysAgo < 180; daysAgo++) {
      DateTime recordDate = now.subtract(Duration(days: daysAgo));

      // Gerar 4-6 refeições por dia (realismo)
      int mealsPerDay = 4 + _random.nextInt(3);
      for (int meal = 0; meal < mealsPerDay; meal++) {
        records.add(
          _generateIngestaoRecord(id: 'ing_${daysAgo}_$meal', data: recordDate),
        );
      }

      // Gerar 1-3 atividades físicas por dia (nem todo dia)
      if (_random.nextDouble() < 0.7) {
        // 70% dos dias tem exercício
        int exercisesPerDay = 1 + _random.nextInt(3);
        for (int ex = 0; ex < exercisesPerDay; ex++) {
          records.add(
            _generateGastoRecord(id: 'gasto_${daysAgo}_$ex', data: recordDate),
          );
        }
      }
    }

    // Ordenar por data (mais recente primeiro)
    records.sort((a, b) => b.data.compareTo(a.data));

    _cachedRecords = records;
    return records;
  }

  /// Gera registro de ingestão calórica (comida/bebida)
  static HealthRecordModel _generateIngestaoRecord({
    required String id,
    required DateTime data,
  }) {
    List<String> categorias = HealthCategories.ingestaoCategories;
    String categoria = categorias[_random.nextInt(categorias.length)];

    double calorias;
    String titulo;

    switch (categoria) {
      case 'Café da Manhã':
        calorias = 250 + _random.nextDouble() * 350; // 250-600 kcal
        titulo = _getRandomBreakfast();
        break;
      case 'Almoço':
        calorias = 500 + _random.nextDouble() * 500; // 500-1000 kcal
        titulo = _getRandomLunch();
        break;
      case 'Jantar':
        calorias = 400 + _random.nextDouble() * 400; // 400-800 kcal
        titulo = _getRandomDinner();
        break;
      case 'Lanche':
        calorias = 100 + _random.nextDouble() * 250; // 100-350 kcal
        titulo = _getRandomSnack();
        break;
      case 'Suplemento':
        calorias = 80 + _random.nextDouble() * 220; // 80-300 kcal
        titulo = _getRandomSupplement();
        break;
      default:
        calorias = 200 + _random.nextDouble() * 300;
        titulo = 'Refeição não especificada';
    }

    return HealthRecordModel(
      id: id,
      titulo: titulo,
      calorias: double.parse(calorias.toStringAsFixed(1)),
      data: data,
      categoria: categoria,
      tipo: RecordType.ingestao,
    );
  }

  /// Gera registro de gasto calórico (exercício/atividade)
  static HealthRecordModel _generateGastoRecord({
    required String id,
    required DateTime data,
  }) {
    List<String> categorias = HealthCategories.gastoCategories;
    String categoria = categorias[_random.nextInt(categorias.length)];

    double calorias;
    String titulo;

    switch (categoria) {
      case 'Musculação':
        calorias = 200 + _random.nextDouble() * 300; // 200-500 kcal
        titulo = _getRandomWeightTraining();
        break;
      case 'Cardio':
        calorias = 300 + _random.nextDouble() * 400; // 300-700 kcal
        titulo = _getRandomCardio();
        break;
      case 'Esportes':
        calorias = 350 + _random.nextDouble() * 350; // 350-700 kcal
        titulo = _getRandomSport();
        break;
      case 'Caminhada':
        calorias = 100 + _random.nextDouble() * 200; // 100-300 kcal
        titulo = _getRandomWalk();
        break;
      case 'Basal':
        calorias = 1500 + _random.nextDouble() * 300; // 1500-1800 kcal/dia
        titulo = 'Taxa Metabólica Basal (TMB)';
        break;
      default:
        calorias = 150 + _random.nextDouble() * 200;
        titulo = 'Atividade física';
    }

    return HealthRecordModel(
      id: id,
      titulo: titulo,
      calorias: double.parse(calorias.toStringAsFixed(1)),
      data: data,
      categoria: categoria,
      tipo: RecordType.gasto,
    );
  }

  /// ============================================================
  /// ALGORITMO DE PREDIÇÃO DE PESO (DATA SCIENCE)
  /// ============================================================
  /// FUNDAMENTO CIENTÍFICO:
  /// - 1kg de gordura corporal = ~7700 kcal de energia
  /// - Déficit calórico de 7700 kcal = perda de 1kg
  /// - Superávit de 7700 kcal = ganho de 1kg
  ///
  /// METODOLOGIA:
  /// 1. Calcular balanço calórico médio diário dos últimos 30 dias
  /// 2. Projetar acúmulo/déficit nos próximos 30 dias
  /// 3. Converter para kg usando a constante termodinâmica
  static Map<String, dynamic> calculateWeightProjection(
    List<HealthRecordModel> records,
  ) {
    DateTime now = DateTime.now();
    DateTime thirtyDaysAgo = now.subtract(const Duration(days: 30));

    // Filtrar registros dos últimos 30 dias
    List<HealthRecordModel> recentRecords = records
        .where((r) => r.data.isAfter(thirtyDaysAgo))
        .toList();

    if (recentRecords.isEmpty) {
      return {
        'projecao_kg': 0.0,
        'tendencia': 'neutro',
        'balanco_medio_diario': 0.0,
        'confianca': 'baixa',
      };
    }

    // Calcular balanço calórico total do período
    double totalIngestao = recentRecords
        .where((r) => r.tipo == RecordType.ingestao)
        .fold(0.0, (sum, r) => sum + r.calorias);

    double totalGasto = recentRecords
        .where((r) => r.tipo == RecordType.gasto)
        .fold(0.0, (sum, r) => sum + r.calorias);

    double balancoTotal = totalIngestao - totalGasto;
    double balancoMedioDiario = balancoTotal / 30;

    // PROJEÇÃO: Balanço médio diário × 30 dias futuros
    double balancoProjetado30Dias = balancoMedioDiario * 30;

    // CONVERSÃO: 7700 kcal = 1kg de gordura corporal
    const double kcalPorKg = 7700.0;
    double projecaoKg = balancoProjetado30Dias / kcalPorKg;

    // Determinar tendência
    String tendencia;
    if (projecaoKg > 0.5) {
      tendencia = 'ganho';
    } else if (projecaoKg < -0.5) {
      tendencia = 'perda';
    } else {
      tendencia = 'estável';
    }

    // Confiança baseada na quantidade de dados
    String confianca = recentRecords.length > 100
        ? 'alta'
        : recentRecords.length > 50
        ? 'média'
        : 'baixa';

    return {
      'projecao_kg': double.parse(projecaoKg.toStringAsFixed(2)),
      'tendencia': tendencia,
      'balanco_medio_diario': double.parse(
        balancoMedioDiario.toStringAsFixed(1),
      ),
      'confianca': confianca,
      'total_ingestao': totalIngestao,
      'total_gasto': totalGasto,
    };
  }

  /// Agrupa registros por categoria
  static Map<String, double> groupByCategory(List<HealthRecordModel> records) {
    Map<String, double> categoryTotals = {};

    for (var record in records) {
      categoryTotals[record.categoria] =
          (categoryTotals[record.categoria] ?? 0) + record.calorias;
    }

    return categoryTotals;
  }

  /// Agrupa balanço calórico por mês (últimos 6 meses)
  static Map<String, double> groupByMonth(List<HealthRecordModel> records) {
    DateTime now = DateTime.now();
    Map<String, double> monthlyBalance = {};

    // Inicializar os últimos 6 meses
    for (int i = 5; i >= 0; i--) {
      DateTime monthDate = DateTime(now.year, now.month - i, 1);
      String monthKey =
          '${monthDate.month.toString().padLeft(2, '0')}/${monthDate.year}';
      monthlyBalance[monthKey] = 0.0;
    }

    // Calcular balanço líquido mensal
    for (var record in records) {
      String monthKey =
          '${record.data.month.toString().padLeft(2, '0')}/${record.data.year}';
      if (monthlyBalance.containsKey(monthKey)) {
        monthlyBalance[monthKey] =
            monthlyBalance[monthKey]! + record.caloriasLiquidas;
      }
    }

    return monthlyBalance;
  }

  /// Calcula estatísticas básicas de saúde
  static Map<String, double> calculateStatistics(
    List<HealthRecordModel> records,
  ) {
    double totalIngestao = records
        .where((r) => r.tipo == RecordType.ingestao)
        .fold(0.0, (sum, r) => sum + r.calorias);

    double totalGasto = records
        .where((r) => r.tipo == RecordType.gasto)
        .fold(0.0, (sum, r) => sum + r.calorias);

    double balancoLiquido = totalIngestao - totalGasto;

    return {
      'totalIngestao': totalIngestao,
      'totalGasto': totalGasto,
      'balancoLiquido': balancoLiquido,
    };
  }

  /// Conta número de registros por categoria
  static Map<String, int> countByCategory(List<HealthRecordModel> records) {
    Map<String, int> categoryCount = {};

    for (var record in records) {
      categoryCount[record.categoria] =
          (categoryCount[record.categoria] ?? 0) + 1;
    }

    return categoryCount;
  }

  /// Limpa cache para regenerar dados
  static void clearCache() {
    _cachedRecords = null;
  }

  // ====== MÉTODOS AUXILIARES PARA GERAÇÃO DE DESCRIÇÕES REALISTAS ======

  static String _getRandomBreakfast() {
    List<String> items = [
      'Pão integral com ovo e café',
      'Tapioca com queijo branco',
      'Aveia com banana e mel',
      'Iogurte natural com granola',
      'Panqueca de proteína',
      'Omelete com legumes',
      'Smoothie de frutas vermelhas',
      'Mingau de aveia com whey',
    ];
    return items[_random.nextInt(items.length)];
  }

  static String _getRandomLunch() {
    List<String> items = [
      'Arroz, feijão, frango grelhado e salada',
      'Macarrão integral com molho de tomate',
      'Peixe assado com batata doce',
      'Carne magra com legumes no vapor',
      'Risoto de frango light',
      'Filé de tilápia com quinoa',
      'Strogonoff de carne com arroz integral',
      'Salada Caesar com peito de frango',
    ];
    return items[_random.nextInt(items.length)];
  }

  static String _getRandomDinner() {
    List<String> items = [
      'Sopa de legumes com frango',
      'Omelete de claras com salada',
      'Sanduíche natural de atum',
      'Wrap de frango com verduras',
      'Salmão grelhado com brócolis',
      'Peito de peru com purê de abóbora',
      'Salada de atum com grão de bico',
      'Frango desfiado com abobrinha',
    ];
    return items[_random.nextInt(items.length)];
  }

  static String _getRandomSnack() {
    List<String> items = [
      'Castanhas mix (30g)',
      'Barra de proteína',
      'Frutas variadas',
      'Iogurte grego natural',
      'Queijo cottage com tomate',
      'Pasta de amendoim com maçã',
      'Mix de nuts e frutas secas',
      'Shake proteico',
    ];
    return items[_random.nextInt(items.length)];
  }

  static String _getRandomSupplement() {
    List<String> items = [
      'Whey Protein (30g)',
      'BCAA 5g',
      'Creatina 5g',
      'Vitamina C 1000mg',
      'Ômega 3 (2 cápsulas)',
      'Multivitamínico',
      'Glutamina 5g',
      'Caseína 30g',
    ];
    return items[_random.nextInt(items.length)];
  }

  static String _getRandomWeightTraining() {
    List<String> items = [
      'Treino de peito e tríceps - 45min',
      'Treino de costas e bíceps - 50min',
      'Treino de pernas - 60min',
      'Treino de ombros e abdômen - 40min',
      'Treino full body - 55min',
      'Treino de superiores - 45min',
      'Treino de inferiores - 50min',
      'Treino de força - 60min',
    ];
    return items[_random.nextInt(items.length)];
  }

  static String _getRandomCardio() {
    List<String> items = [
      'Corrida 5km em 30min',
      'Bicicleta ergométrica 40min',
      'Elíptico 35min',
      'HIIT 20min',
      'Esteira inclinada 25min',
      'Spinning 45min',
      'Corrida intervalada 30min',
      'Jump rope 15min',
    ];
    return items[_random.nextInt(items.length)];
  }

  static String _getRandomSport() {
    List<String> items = [
      'Futebol - 60min',
      'Natação - 45min',
      'Vôlei - 50min',
      'Basquete - 55min',
      'Tênis - 60min',
      'Crossfit WOD - 40min',
      'Artes marciais - 50min',
      'Yoga - 60min',
    ];
    return items[_random.nextInt(items.length)];
  }

  static String _getRandomWalk() {
    List<String> items = [
      'Caminhada leve 30min',
      'Caminhada rápida 40min',
      'Caminhada ao ar livre 35min',
      'Caminhada na praia 45min',
      'Trekking leve 50min',
      'Caminhada no parque 25min',
      'Passeio com cachorro 30min',
      'Caminhada pós-refeição 20min',
    ];
    return items[_random.nextInt(items.length)];
  }
}
