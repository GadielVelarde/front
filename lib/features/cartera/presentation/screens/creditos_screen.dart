
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:heroine/heroine.dart';

import '../../../../core/di/injection.dart';
import '../bloc/credito_bloc.dart';
import '../bloc/credito_event.dart';
import '../bloc/credito_state.dart';
import '../widgets/credito_list_item.dart';

class CreditosScreen extends StatefulWidget {
  final String? nombreSocio;
  final String socioId;
  
  const CreditosScreen({
    super.key, 
    this.nombreSocio,
    required this.socioId,
  });

  @override
  State<CreditosScreen> createState() => _CreditosScreenState();
}

class _CreditosScreenState extends State<CreditosScreen> {
  late final CreditoBloc _creditoBloc;

  @override
  void initState() {
    super.initState();
    _creditoBloc = sl<CreditoBloc>();
    final socioIdInt = int.parse(widget.socioId);
    _creditoBloc.add(GetCreditosBySocioEvent(socioIdInt));
  }

  @override
  void dispose() {
    _creditoBloc.close();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final nombreCompleto = widget.nombreSocio ?? 'Socio';
    final namelength = nombreCompleto.length;
    
    return BlocProvider.value(
      value: _creditoBloc,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black,),
            onPressed: () {
              context.pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      nombreCompleto,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Divider(
                      height: 1.0,
                      indent: 1.6 * namelength,
                      endIndent: 1.6 * namelength,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              const Center(
                child: Text(
                  'Creditos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<CreditoBloc, CreditoState>(
                  builder: (final context, final state) {
                    if (state is CreditoLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    
                    if (state is CreditoError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error al cargar créditos',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    
                    if (state is CreditosLoaded) {
                      if (state.creditos.isEmpty) {
                        return const Center(
                          child: Text('No hay créditos registrados'),
                        );
                      }
                      
                      return ListView.builder(
                        itemCount: state.creditos.length,
                        itemBuilder: (final context, final index) {
                          final credito = state.creditos[index];
                          return Heroine(
                            tag: 'credito-${credito.id}',
                            child: CreditoListItem(credito: credito),
                          );
                        },
                      );
                    }
                    
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
