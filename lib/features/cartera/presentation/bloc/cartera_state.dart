import 'package:equatable/equatable.dart';
import '../../domain/entities/cartera.dart';
abstract class CarteraState extends Equatable {
  const CarteraState();

  @override
  List<Object?> get props => [];
}
class CarteraInitial extends CarteraState {
  const CarteraInitial();
}
class CarteraLoading extends CarteraState {
  const CarteraLoading();
}
class CarteraLoaded extends CarteraState {
  final List<Cartera> carteras;

  const CarteraLoaded({required this.carteras});

  @override
  List<Object?> get props => [carteras];
}
class CarteraSingleLoaded extends CarteraState {
  final Cartera cartera;

  const CarteraSingleLoaded({required this.cartera});

  @override
  List<Object?> get props => [cartera];
}
class CarteraOperationSuccess extends CarteraState {
  final String message;
  final Cartera? cartera;

  const CarteraOperationSuccess({
    required this.message,
    this.cartera,
  });

  @override
  List<Object?> get props => [message, cartera];
}
class CarteraError extends CarteraState {
  final String message;

  const CarteraError({required this.message});

  @override
  List<Object?> get props => [message];
}
