// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:universal_html/html.dart' as html;
import '../models/health_record_model.dart';

/// Serviço de exportação com geração de arquivos CSV e PDF (HTML)
class ExportService {
  /// Exporta registros nutricionais para arquivo CSV
  static Future<bool> exportToCSV(List<HealthRecordModel> records) async {
    try {
      // Preparar dados CSV
      List<List<dynamic>> csvData = [
        ['ID', 'Título', 'Categoria', 'Calorias (kcal)', 'Tipo', 'Data'],
      ];

      for (var record in records) {
        csvData.add([
          record.id,
          record.titulo,
          record.categoria,
          record.calorias.toStringAsFixed(1),
          record.tipo == RecordType.ingestao ? 'Ingestão' : 'Gasto',
          '${record.data.day.toString().padLeft(2, '0')}/${record.data.month.toString().padLeft(2, '0')}/${record.data.year}',
        ]);
      }

      // Converter para CSV
      String csv = const ListToCsvConverter().convert(csvData);

      // Criar arquivo e download
      try {
        final bytes = utf8.encode(csv);
        final blob = html.Blob([bytes], 'text/csv;charset=utf-8');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download =
              'NutriHealth_${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}.csv';
        html.document.body?.children.add(anchor);
        anchor.click();
        await Future.delayed(const Duration(milliseconds: 100));
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      } catch (downloadError) {
        rethrow;
      }

      String filename =
          'NutriHealth_${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}.csv';

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Exporta registros para arquivo PDF/HTML com predição de peso
  static Future<bool> exportToPDF(
    List<HealthRecordModel> records,
    Map<String, dynamic> weightProjection,
  ) async {
    try {
      // Calcular estatísticas
      double totalIngestao = 0;
      double totalGasto = 0;
      Map<String, double> categorias = {};

      for (var record in records) {
        if (record.tipo == RecordType.ingestao) {
          totalIngestao += record.calorias;
          categorias[record.categoria] =
              (categorias[record.categoria] ?? 0) + record.calorias;
        } else {
          totalGasto += record.calorias;
        }
      }

      double balancoLiquido = totalIngestao - totalGasto;
      var sortedCategorias = categorias.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      double projecaoKg = weightProjection['projecao_kg'] ?? 0.0;
      String tendencia = weightProjection['tendencia'] ?? 'neutro';
      double balancoMedio = weightProjection['balanco_medio_diario'] ?? 0.0;

      // Criar conteúdo HTML
      String htmlContent =
          '''<!DOCTYPE html>
<html>
<head>
    <title>NutriHealth Analytics - Relatório Nutricional</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; line-height: 1.6; }
        .header { text-align: center; color: #4CAF50; margin-bottom: 30px; }
        .section { margin: 20px 0; }
        .summary { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin: 20px 0; }
        .summary-card { padding: 15px; background: #f5f5f5; border-radius: 8px; text-align: center; }
        .summary-card strong { display: block; margin-bottom: 5px; font-size: 18px; }
        .prediction-box { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 12px; margin: 20px 0; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        .ingestao { color: orange; font-weight: bold; }
        .gasto { color: red; font-weight: bold; }
        .footer { text-align: center; margin-top: 30px; font-size: 12px; color: #666; }
        ul li { margin: 8px 0; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🥗 NutriHealth Analytics</h1>
        <h2>📊 Relatório Nutricional Completo</h2>
        <p>📅 Gerado em ${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}</p>
    </div>
    
    <div class="prediction-box">
        <h3>🤖 Predição de Peso (Inteligência Artificial)</h3>
        <h2 style="font-size: 36px; margin: 10px 0;">${projecaoKg > 0 ? '+' : ''}${projecaoKg.toStringAsFixed(2)} kg</h2>
        <p>Tendência: <strong>${tendencia == 'ganho'
              ? '📈 Ganho de Peso'
              : tendencia == 'perda'
              ? '📉 Emagrecimento'
              : '⚖️ Peso Estável'}</strong></p>
        <p>Balanço médio diário: ${balancoMedio > 0 ? '+' : ''}${balancoMedio.toStringAsFixed(0)} kcal</p>
        <p style="font-size: 12px; opacity: 0.8;">Baseado na fórmula científica: 7700 kcal ≈ 1kg de gordura corporal</p>
    </div>
    
    <div class="section">
        <h3>💼 Resumo Nutricional</h3>
        <div class="summary">
            <div class="summary-card">
                <strong>🍽️ Total Ingestão</strong>
                <span>${totalIngestao.toStringAsFixed(0)} kcal</span>
            </div>
            <div class="summary-card">
                <strong>🔥 Total Queima</strong>
                <span>${totalGasto.toStringAsFixed(0)} kcal</span>
            </div>
            <div class="summary-card">
                <strong>⚖️ Balanço Líquido</strong>
                <span>${balancoLiquido.toStringAsFixed(0)} kcal</span>
            </div>
            <div class="summary-card">
                <strong>📊 Registros</strong>
                <span>${records.length} entradas</span>
            </div>
        </div>
    </div>
    
    <div class="section">
        <h3>🏆 Top Categorias de Ingestão</h3>
        <ul>''';

      // Adicionar categorias
      for (int i = 0; i < 5 && i < sortedCategorias.length; i++) {
        var entry = sortedCategorias[i];
        double percent = totalIngestao > 0
            ? (entry.value / totalIngestao) * 100
            : 0;
        htmlContent += '''
            <li><strong>${entry.key}:</strong> ${entry.value.toStringAsFixed(0)} kcal (${percent.toStringAsFixed(1)}%)</li>''';
      }

      htmlContent += '''
        </ul>
    </div>
    
    <div class="section">
        <h3>📋 Histórico de Registros (Últimos 20)</h3>
        <table>
            <tr>
                <th>📅 Data</th>
                <th>📝 Título</th>
                <th>🏷️ Categoria</th>
                <th>🔥 Calorias</th>
                <th>📊 Tipo</th>
            </tr>''';

      // Adicionar registros
      for (int i = 0; i < 20 && i < records.length; i++) {
        var record = records[i];
        String cssClass = record.tipo == RecordType.ingestao
            ? 'ingestao'
            : 'gasto';
        String tipo = record.tipo == RecordType.ingestao
            ? '🍽️ Ingestão'
            : '🔥 Gasto';

        htmlContent +=
            '''
            <tr>
                <td>${record.data.day.toString().padLeft(2, '0')}/${record.data.month.toString().padLeft(2, '0')}/${record.data.year}</td>
                <td>${record.titulo}</td>
                <td>${record.categoria}</td>
                <td class="$cssClass">${record.calorias.toStringAsFixed(1)} kcal</td>
                <td>$tipo</td>
            </tr>''';
      }

      htmlContent += '''
        </table>
    </div>
    
    <div class="footer">
        <p>📄 Relatório gerado pelo NutriHealth Analytics</p>
        <p>👨‍💻 Gustavo Alves, Leonardo Paiva e Salomão Ferreira</p>
        <p>💡 <strong>Dica:</strong> Use Ctrl+P para salvar como PDF</p>
    </div>
</body>
</html>''';

      // Criar e baixar arquivo HTML
      try {
        final bytes = utf8.encode(htmlContent);
        final blob = html.Blob([bytes], 'text/html;charset=utf-8');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download =
              'NutriHealth_Report_${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}.html';
        html.document.body?.children.add(anchor);
        anchor.click();
        await Future.delayed(const Duration(milliseconds: 100));
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      } catch (downloadError) {
        rethrow;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
