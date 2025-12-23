import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/history_service.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _records = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    final historyService = Provider.of<HistoryService>(context, listen: false);
    setState(() {
      _records = historyService.getAllRecords().reversed.toList();
    });
  }

  void _deleteRecord(int index) {
    final historyService = Provider.of<HistoryService>(context, listen: false);
    historyService.deleteRecord(_records[index]['key'] ?? index);
    _loadHistory();
  }

  void _clearAll() {
    final historyService = Provider.of<HistoryService>(context, listen: false);
    historyService.clearAll();
    _loadHistory();
  }

  Future<void> _exportCSV() async {
    final historyService = Provider.of<HistoryService>(context, listen: false);
    final file = await historyService.exportCSV();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('CSV exported to ${file.path}'),
    ));
  }

  Future<void> _exportJSON() async {
    final historyService = Provider.of<HistoryService>(context, listen: false);
    final file = await historyService.exportJSON();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('JSON exported to ${file.path}'),
    ));
  }

  Future<void> _importJSON() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.first.path!);
      final historyService = Provider.of<HistoryService>(context, listen: false);
      await historyService.importJSON(file);
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _clearAll,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Export CSV':
                  _exportCSV();
                  break;
                case 'Export JSON':
                  _exportJSON();
                  break;
                case 'Import JSON':
                  _importJSON();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Export CSV', child: Text('Export CSV')),
              const PopupMenuItem(value: 'Export JSON', child: Text('Export JSON')),
              const PopupMenuItem(value: 'Import JSON', child: Text('Import JSON')),
            ],
          )
        ],
      ),
      body: _records.isEmpty
          ? const Center(child: Text('No history yet'))
          : ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                return ListTile(
                  title: Text('${record['input']} ${record['from']} → ${record['result']} ${record['to']}'),
                  subtitle: Text('${record['category']} | ${record['date'].substring(0, 10)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteRecord(index),
                  ),
                );
              },
            ),
    );
  }
}