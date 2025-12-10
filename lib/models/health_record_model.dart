/// Modelo de dados para registros nutricionais e de saúde
/// Projeto NutriHealth Analytics - Leonardo Paiva e Salomão Ferreira
class HealthRecordModel {
  final String id;
  final String titulo;
  final double calorias; // kcal
  final DateTime data;
  final String categoria;
  final RecordType tipo;

  HealthRecordModel({
    required this.id,
    required this.titulo,
    required this.calorias,
    required this.data,
    required this.categoria,
    required this.tipo,
  });

  /// Converte para Map para exportação
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'calorias': calorias,
      'data': data.toIso8601String(),
      'categoria': categoria,
      'tipo': tipo.toString(),
    };
  }

  /// Formatação para CSV
  List<dynamic> toCsvRow() {
    return [
      data.toIso8601String().split('T')[0],
      tipo == RecordType.ingestao ? 'Ingestão' : 'Gasto',
      categoria,
      calorias,
      titulo,
    ];
  }

  /// Calorias líquidas (positivo para ingestão, negativo para gasto)
  double get caloriasLiquidas =>
      tipo == RecordType.ingestao ? calorias : -calorias;

  @override
  String toString() {
    return 'HealthRecordModel(id: $id, titulo: $titulo, calorias: $calorias, categoria: $categoria, tipo: $tipo)';
  }
}

enum RecordType { ingestao, gasto }

/// Categorias nutricionais predefinidas
class HealthCategories {
  static const Map<String, List<String>> categoriesByType = {
    'ingestao': ['Café da Manhã', 'Almoço', 'Jantar', 'Lanche', 'Suplemento'],
    'gasto': ['Musculação', 'Cardio', 'Esportes', 'Caminhada', 'Basal'],
  };

  static List<String> get allCategories {
    return [...categoriesByType['ingestao']!, ...categoriesByType['gasto']!];
  }

  static List<String> get ingestaoCategories => categoriesByType['ingestao']!;
  static List<String> get gastoCategories => categoriesByType['gasto']!;
}
