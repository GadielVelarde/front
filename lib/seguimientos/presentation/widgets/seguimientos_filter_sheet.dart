import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Bottom sheet con filtros para seguimientos
/// Incluye filtros de fecha, asesor y área
class SeguimientosFilterSheet extends StatefulWidget {
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? selectedAsesor;
  final String? selectedArea;
  final void Function(DateTime?, DateTime?, String?, String?)? onApplyFilters;

  const SeguimientosFilterSheet({
    super.key,
    this.fromDate,
    this.toDate,
    this.selectedAsesor,
    this.selectedArea,
    this.onApplyFilters,
  });

  @override
  State<SeguimientosFilterSheet> createState() =>
      _SeguimientosFilterSheetState();
}

class _SeguimientosFilterSheetState extends State<SeguimientosFilterSheet> {
  DateTime? _fromDate;
  DateTime? _toDate;
  String? _selectedAsesor;
  String? _selectedArea;

  final List<String> _asesores = ['Jose Perez', 'Maria Garcia', 'Juan Lopez'];
  final List<String> _areas = ['Area 1', 'Area 2', 'Area 3'];

  @override
  void initState() {
    super.initState();
    _fromDate = widget.fromDate;
    _toDate = widget.toDate;
    _selectedAsesor = widget.selectedAsesor;
    _selectedArea = widget.selectedArea;
  }

  void _selectQuickFilter(final String filter) {
    setState(() {
      final now = DateTime.now();
      switch (filter) {
        case 'Today':
          _fromDate = DateTime(now.year, now.month, now.day);
          _toDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
          break;
        case 'This Week':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          _fromDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
          _toDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
          break;
        case 'This Month':
          _fromDate = DateTime(now.year, now.month, 1);
          _toDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
          break;
      }
    });
  }

  Future<void> _pickDate(final bool isFrom) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom
          ? (_fromDate ?? DateTime.now())
          : (_toDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  void _resetAllFilters() {
    setState(() {
      _fromDate = null;
      _toDate = null;
      _selectedAsesor = null;
      _selectedArea = null;
    });
  }

  void _applyFilters() {
    widget.onApplyFilters?.call(
      _fromDate,
      _toDate,
      _selectedAsesor,
      _selectedArea,
    );
    Navigator.of(context).pop();
  }

  int get _activeFiltersCount {
    int count = 0;
    if (_fromDate != null || _toDate != null) count++;
    if (_selectedAsesor != null) count++;
    if (_selectedArea != null) count++;
    return count;
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),

          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Filter by:',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF191C1F),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rango de Fechas Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rango de Fechas',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191C1F),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _fromDate = null;
                            _toDate = null;
                          });
                        },
                        child: const Text(
                          'Reiniciar',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Color(0xFFB03138),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Date Pickers
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'From',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(0xFF858587),
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _pickDate(true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F4F5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _fromDate != null
                                          ? DateFormat('dd-MM-yyyy')
                                              .format(_fromDate!)
                                          : '09-10-2025',
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        color: Color(0xFF191C1F),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Color(0xFF858587),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'To',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(0xFF858587),
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => _pickDate(false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F4F5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _toDate != null
                                          ? DateFormat('dd-MM-yyyy')
                                              .format(_toDate!)
                                          : '09-11-2025',
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        color: Color(0xFF191C1F),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Color(0xFF858587),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Quick Filter Buttons
                  Row(
                    children: [
                      _buildQuickFilterButton('Today'),
                      const SizedBox(width: 8),
                      _buildQuickFilterButton('This Week'),
                      const SizedBox(width: 8),
                      _buildQuickFilterButton('This Month'),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFE5E5E5)),
                  const SizedBox(height: 24),

                  // Asesor Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Asesor',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191C1F),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedAsesor = null;
                          });
                        },
                        child: const Text(
                          'Reiniciar',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Color(0xFFB03138),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Asesor Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedAsesor,
                      hint: const Text('Jose Perez'),
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _asesores.map((final String asesor) {
                        return DropdownMenuItem<String>(
                          value: asesor,
                          child: Text(asesor),
                        );
                      }).toList(),
                      onChanged: (final String? newValue) {
                        setState(() {
                          _selectedAsesor = newValue;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFE5E5E5)),
                  const SizedBox(height: 24),

                  // Area Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Area',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF191C1F),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedArea = null;
                          });
                        },
                        child: const Text(
                          'Reiniciar',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Color(0xFFB03138),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Area Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedArea,
                      hint: const Text('Area 1'),
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _areas.map((final String area) {
                        return DropdownMenuItem<String>(
                          value: area,
                          child: Text(area),
                        );
                      }).toList(),
                      onChanged: (final String? newValue) {
                        setState(() {
                          _selectedArea = newValue;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _resetAllFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C7278),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Reiniciar todo',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB03138),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Aplicar filtros($_activeFiltersCount)',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
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

  Widget _buildQuickFilterButton(final String label) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => _selectQuickFilter(label),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE5E5E5)),
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: Color(0xFF191C1F),
          ),
        ),
      ),
    );
  }
}
