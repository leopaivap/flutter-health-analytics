// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/health_record_model.dart';
import '../services/data_repository.dart';

/// Tela de Histórico com lista detalhada e filtros
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HealthRecordModel> records = [];
  List<HealthRecordModel> filteredRecords = [];
  bool isLoading = true;
  String selectedFilter = 'Todos';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecords();
    searchController.addListener(_filterRecords);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _loadRecords() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      records = DataRepository.generateMockData();
      // Ordenar por data (mais recentes primeiro)
      records.sort((a, b) => b.data.compareTo(a.data));
      _filterRecords();

      setState(() {
        isLoading = false;
      });
    });
  }

  void _filterRecords() {
    String searchTerm = searchController.text.toLowerCase();

    filteredRecords = records.where((record) {
      bool matchesSearch =
          record.titulo.toLowerCase().contains(searchTerm) ||
          record.categoria.toLowerCase().contains(searchTerm);

      bool matchesFilter;
      switch (selectedFilter) {
        case 'Ingestão':
          matchesFilter = record.tipo == RecordType.ingestao;
          break;
        case 'Gasto':
          matchesFilter = record.tipo == RecordType.gasto;
          break;
        case 'Todos':
        default:
          matchesFilter = true;
          break;
      }

      return matchesSearch && matchesFilter;
    }).toList();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Histórico'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Carregando histórico...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 Histórico Completo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadRecords),
        ],
      ),
      body: Column(
        children: [
          _buildFilterHeader(),
          Expanded(child: _buildRecordList()),
        ],
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Barra de pesquisa
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Pesquisar por título ou categoria...',
              prefixIcon: const Icon(Icons.search, color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 12),

          // Filtros por tipo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterChip('Todos'),
              _buildFilterChip('Ingestão'),
              _buildFilterChip('Gasto'),
            ],
          ),

          const SizedBox(height: 8),

          // Contador de resultados
          Text(
            '${filteredRecords.length} de ${records.length} registros',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    bool isSelected = selectedFilter == filter;
    return FilterChip(
      label: Text(filter),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          selectedFilter = filter;
          _filterRecords();
        });
      },
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue,
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildRecordList() {
    if (filteredRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Nenhum registro encontrado',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente ajustar os filtros ou a busca',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredRecords.length,
      itemBuilder: (context, index) {
        HealthRecordModel record = filteredRecords[index];
        return _buildRecordCard(record);
      },
    );
  }

  Widget _buildRecordCard(HealthRecordModel record) {
    bool isIngestao = record.tipo == RecordType.ingestao;
    Color color = isIngestao ? Colors.orange : Colors.red;
    IconData icon = isIngestao ? Icons.restaurant : Icons.local_fire_department;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          record.titulo,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.category, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  record.categoria,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(record.data),
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${record.calorias.toStringAsFixed(0)} kcal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isIngestao ? 'INGESTÃO' : 'GASTO',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showRecordDetails(record),
      ),
    );
  }

  void _showRecordDetails(HealthRecordModel record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Detalhes do Registro',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('ID', record.id),
            _buildDetailRow('Título', record.titulo),
            _buildDetailRow('Categoria', record.categoria),
            _buildDetailRow(
              'Calorias',
              '${record.calorias.toStringAsFixed(1)} kcal',
            ),
            _buildDetailRow(
              'Tipo',
              record.tipo == RecordType.ingestao
                  ? 'Ingestão Calórica'
                  : 'Gasto Calórico',
            ),
            _buildDetailRow('Data', _formatDate(record.data)),
            _buildDetailRow(
              'Balanço',
              '${record.caloriasLiquidas > 0 ? '+' : ''}${record.caloriasLiquidas.toStringAsFixed(1)} kcal',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Fechar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
