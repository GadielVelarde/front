import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroine/heroine.dart';
import '../../../../core/routing/routes.dart';
import '../../../../shared/presentation/widgets/socio_list_item.dart';
import '../../../../shared/presentation/widgets/date_filter_button.dart';
import '../widgets/seguimientos_filter_sheet.dart';

/// Pantalla principal de seguimientos
/// Muestra una lista de socios con búsqueda y filtros
class SeguimientosListPage extends StatefulWidget {
  const SeguimientosListPage({super.key});

  @override
  State<SeguimientosListPage> createState() => _SeguimientosListPageState();
}

class _SeguimientosListPageState extends State<SeguimientosListPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedDate;
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedAsesor;
  String? _selectedArea;

  final List<Map<String, String>> _socios = [
    {'name': 'Juan Pérez', 'phone': '987654321', 'area': 'Área Norte'},
    {'name': 'María García', 'phone': '987654322', 'area': 'Área Sur'},
    {'name': 'Carlos López', 'phone': '987654323', 'area': 'Área Este'},
    {'name': 'Ana Martínez', 'phone': '987654324', 'area': 'Área Oeste'},
    {'name': 'Luis Rodríguez', 'phone': '987654325', 'area': 'Área Centro'},
    {'name': 'Sofia Fernández', 'phone': '987654326', 'area': 'Área Norte'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilters() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (final context) => SeguimientosFilterSheet(
        fromDate: _fromDate,
        toDate: _toDate,
        selectedAsesor: _selectedAsesor,
        selectedArea: _selectedArea,
        onApplyFilters: (final fromDate, final toDate, final asesor, final area) {
          setState(() {
            _fromDate = fromDate;
            _toDate = toDate;
            _selectedAsesor = asesor;
            _selectedArea = area;
          });
        },
      ),
    );
  }

  void _onSocioTap(final Map<String, String> socio) {
    context.push('${Routes.asesorMonitoring}/${socio['name']}');
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Color(0xFF6C7072),
                    ),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: const Color(0xFFC7C7C7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (final value) {
                    setState(() {});
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Date Filter and Filter Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Date Filter Button
                  Expanded(
                    child: DateFilterButton(
                      selectedDate: _selectedDate,
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate =
                                '${picked.day}/${picked.month}/${picked.year}';
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Filter Button
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB03138),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _showFilters,
                        borderRadius: BorderRadius.circular(8),
                        child: const Icon(
                          Icons.filter_list,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Socios List
            Expanded(
              child: ListView.separated(
                itemCount: _socios.length,
                separatorBuilder: (final context, final index) => const Divider(
                  height: 1,
                  color: Color(0xFFE5E5E5),
                ),
                itemBuilder: (final context, final index) {
                  final socio = _socios[index];
                  return Heroine(
                    tag: 'asesor-${socio['name']}',
                    child: SocioListItem(
                      name: socio['name']!,
                      phone: socio['phone']!,
                      area: socio['area']!,
                      onTap: () => _onSocioTap(socio),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
