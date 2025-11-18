import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/presentation/widgets/seguimiento_field.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/rutas_bloc.dart';
import '../bloc/rutas_event.dart';
import '../bloc/rutas_state.dart';
import 'input_bottom_sheet.dart';

class CrearRutaScreen extends StatefulWidget {
  const CrearRutaScreen({super.key});

  @override
  State<CrearRutaScreen> createState() => _CrearRutaScreenState();
}

class _CrearRutaScreenState extends State<CrearRutaScreen> {
  String _nombreRuta = '';
  String _sociosAsociados = '';
  String _jefeAsociado = '';
  String _tipoRuta = '';
  bool _isLoading = false;
  
  // Lista de socios seleccionados
  final List<String> _sociosSeleccionados = [];

  bool get _isFormValid {
    return _nombreRuta.isNotEmpty &&
        _sociosAsociados.isNotEmpty &&
        _jefeAsociado.isNotEmpty &&
        _tipoRuta.isNotEmpty;
  }

  void _crearRuta() {
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor complete todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authState = context.read<AuthBloc>().state;
    String? zona;
    String? agencia;
    String? asesorId;

    if (authState is AuthAuthenticated) {
      zona = authState.user.zona;
      agencia = authState.user.agencia;
      asesorId = authState.user.id;
    }

    if (zona == null || agencia == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo obtener la zona o agencia del usuario'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Activar loading antes de disparar el evento
    setState(() {
      _isLoading = true;
    });

    // Disparar evento para crear ruta
    context.read<RutasBloc>().add(
      CreateRutaEvent(
        nombre: _nombreRuta,
        descripcion: 'Ruta creada desde la app móvil',
        zona: zona,
        agencia: agencia,
        asesorAsignado: asesorId,
        tipoRuta: _tipoRuta,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocListener<RutasBloc, RutasState>(
      listenWhen: (final previous, final current) {
        // Solo escuchar estados después de que se haya disparado CreateRutaEvent
        // No reaccionar a RutasLoading de otros eventos
        return current is RutaOperationSuccess || 
               (current is RutasError && previous is! RutasLoaded);
      },
      listener: (final context, final state) {
        if (state is RutaOperationSuccess) {
          setState(() {
            _isLoading = false;
          });
          
          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ruta creada exitosamente'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          
          // Recargar las rutas y volver a la lista
          context.read<RutasBloc>().add(const GetRutasEvent());
          context.pop();
        } else if (state is RutasError) {
          setState(() {
            _isLoading = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (!_isLoading) context.pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Crea tu Ruta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Icon(
                Icons.map,
                size: 80,
                color: Color(0xFFB03138),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: IgnorePointer(
                    ignoring: _isLoading,
                    child: Opacity(
                      opacity: _isLoading ? 0.5 : 1.0,
                      child: Column(
                        children: [
                          SeguimientoField(
                            context: context,
                            labelText: 'Nombre de la ruta',
                            valueText: _nombreRuta.isEmpty
                                ? 'Ingrese el nombre de la ruta'
                                : _nombreRuta,
                            suffixIcon: const Icon(Icons.edit),
                            bottomSheet: _buildNombreBottomSheet(),
                          ),
                          SeguimientoField(
                            context: context,
                            labelText: 'Socios Asociados a la ruta',
                            valueText: _sociosAsociados.isEmpty
                                ? 'Seleccione los socios'
                                : _sociosAsociados,
                            suffixIcon: const Icon(Icons.person),
                            bottomSheet: _buildSociosBottomSheet(),
                          ),
                          SeguimientoField(
                            context: context,
                            labelText: 'Jefe Asociado',
                            valueText: _jefeAsociado.isEmpty
                              ? 'Seleccione el jefe'
                              : _jefeAsociado,
                            suffixIcon: const Icon(Icons.person_outline),
                            bottomSheet: _buildJefeBottomSheet(),
                          ),
                          SeguimientoField(
                            context: context,
                            labelText: 'Tipo de ruta',
                            valueText: _tipoRuta.isEmpty
                                ? 'Seleccione el tipo'
                                : _tipoRuta,
                            suffixIcon: const Icon(Icons.arrow_drop_down),
                            bottomSheet: _buildTipoRutaBottomSheet(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _crearRuta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid && !_isLoading
                        ? const Color(0xFFB03138)
                        : Colors.grey[400],
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Crear ruta',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNombreBottomSheet() {
    final controller = TextEditingController(text: _nombreRuta);
    return InputBottomSheet(context: context, title: 'Nombre de la ruta', controller: controller, onSave: (final value) {
        setState(() {
          _nombreRuta = value;
        });
      });
  }

  Widget _buildSociosBottomSheet() {
    // Lista temporal de socios disponibles (TODO: obtener del API)
    final sociosDisponibles = [
      'Juan Pérez - DNI: 12345678',
      'María García - DNI: 87654321',
      'Carlos López - DNI: 11223344',
      'Ana Martínez - DNI: 44332211',
      'Pedro Sánchez - DNI: 55667788',
      'Laura Torres - DNI: 88776655',
      'Miguel Rojas - DNI: 99887766',
      'Carmen Flores - DNI: 66778899',
    ];
    
    // Crear una lista temporal local para manejar las selecciones
    final selectedSocios = List<String>.from(_sociosSeleccionados);
    
    return StatefulBuilder(
      builder: (final BuildContext context, final StateSetter setModalState) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Seleccionar Socios',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (selectedSocios.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB03138),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${selectedSocios.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sociosDisponibles.length,
                  itemBuilder: (final context, final index) {
                    final socio = sociosDisponibles[index];
                    final isSelected = selectedSocios.contains(socio);
                    
                    return CheckboxListTile(
                      title: Text(socio),
                      value: isSelected,
                      activeColor: const Color(0xFFB03138),
                      onChanged: (final bool? value) {
                        setModalState(() {
                          if (value == true) {
                            selectedSocios.add(socio);
                          } else {
                            selectedSocios.remove(socio);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _sociosSeleccionados.clear();
                    _sociosSeleccionados.addAll(selectedSocios);
                    _sociosAsociados = '${selectedSocios.length} socio(s) seleccionado(s)';
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB03138),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Confirmar Selección',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJefeBottomSheet() {
    final jefes = ['Jefe 1', 'Jefe 2', 'Jefe 3'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Seleccionar Jefe',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...jefes.map((final jefe) => ListTile(
                title: Text(jefe),
                trailing: _jefeAsociado == jefe
                    ? const Icon(Icons.check, color: Color(0xFFB03138))
                    : null,
                onTap: () {
                  setState(() {
                    _jefeAsociado = jefe;
                  });
                  Navigator.of(context).pop();
                },
              )),
        ],
      ),
    );
  }

  Widget _buildTipoRutaBottomSheet() {
    final tipos = ['Cobro', 'Evaluación', 'Seguimiento'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Tipo de Ruta',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...tipos.map((final tipo) => ListTile(
                title: Text(tipo),
                trailing: _tipoRuta == tipo
                    ? const Icon(Icons.check, color: Color(0xFFB03138))
                    : null,
                onTap: () {
                  setState(() {
                    _tipoRuta = tipo;
                  });
                  Navigator.of(context).pop();
                },
              )),
        ],
      ),
    );
  }
}
