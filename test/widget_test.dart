
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:seguimiento_norandino/features/auth/presentation/pages/login_page_bloc.dart';
import 'package:seguimiento_norandino/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:seguimiento_norandino/features/auth/presentation/bloc/auth_state.dart';
import 'package:seguimiento_norandino/features/auth/presentation/bloc/auth_event.dart';

@GenerateMocks([AuthBloc])
import 'widget_test.mocks.dart';

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(mockAuthBloc.state).thenReturn(const AuthInitial());
    when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthInitial()));
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc as AuthBloc,
        child: const LoginPageBloc(),
      ),
    );
  }

  group('LoginPageBloc Widget Tests', () {
    testWidgets('should render login page with all elements', (final WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Inicia Sesión'), findsOneWidget);
      expect(find.text('Bienvenido de vuelta!'), findsOneWidget);
      expect(find.text('Iniciar Sesión'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); // Email y Password
    });

    testWidgets('should show error when email is empty and submit is pressed', 
        (final WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Buscar el botón y hacer tap
      final button = find.widgetWithText(ElevatedButton, 'Iniciar Sesión');
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Verificar que se muestra el mensaje de error
      expect(find.text('Por favor ingresa tu email'), findsOneWidget);
    });

    testWidgets('should show error when email format is invalid', 
        (final WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Ingresar email inválido
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid-email');

      // Ingresar contraseña válida
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'password123');

      // Hacer tap en el botón
      final button = find.widgetWithText(ElevatedButton, 'Iniciar Sesión');
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Verificar que se muestra el mensaje de error
      expect(find.text('Por favor ingresa un email válido'), findsOneWidget);
    });

    testWidgets('should show error when password is empty', 
        (final WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Ingresar solo email
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');

      // Hacer tap en el botón
      final button = find.widgetWithText(ElevatedButton, 'Iniciar Sesión');
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Verificar que se muestra el mensaje de error
      expect(find.text('Por favor ingresa tu contraseña'), findsOneWidget);
    });

    testWidgets('should show error when password is too short', 
        (final WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Ingresar email válido
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');

      // Ingresar contraseña corta
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, '123');

      // Hacer tap en el botón
      final button = find.widgetWithText(ElevatedButton, 'Iniciar Sesión');
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Verificar que se muestra el mensaje de error
      expect(find.text('La contraseña debe tener al menos 6 caracteres'), findsOneWidget);
    });

    testWidgets('should trigger login event when form is valid', 
        (final WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Ingresar credenciales válidas
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');

      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'password123');

      // Hacer tap en el botón
      final button = find.widgetWithText(ElevatedButton, 'Iniciar Sesión');
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Verificar que se llamó al evento de login
      verify(mockAuthBloc.add(const LoginRequestedEvent(
        usuario: 'test@example.com',
        password: 'password123',
      ))).called(1);
    });

    testWidgets('should toggle password visibility when icon is tapped', 
        (final WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Ingresar contraseña
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Encontrar el botón de visibilidad
      final visibilityButton = find.byIcon(Icons.visibility);
      expect(visibilityButton, findsOneWidget);

      // Hacer tap para mostrar contraseña
      await tester.tap(visibilityButton);
      await tester.pump();

      // Verificar que cambió a visibility_off
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);
    });

    testWidgets('should show loading state with CircularProgressIndicator', 
        (final WidgetTester tester) async {
      // Cambiar el estado a loading
      when(mockAuthBloc.state).thenReturn(const AuthLoading());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthLoading()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Verificar que se muestra el indicador de carga y el texto
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Iniciando Sesión...'), findsOneWidget);
    });

    testWidgets('should disable form fields when loading', 
        (final WidgetTester tester) async {
      // Cambiar el estado a loading
      when(mockAuthBloc.state).thenReturn(const AuthLoading());
      when(mockAuthBloc.stream).thenAnswer((_) => Stream.value(const AuthLoading()));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Intentar ingresar texto en los campos
      final emailField = find.byType(TextFormField).first;
      final textField = tester.widget<TextFormField>(emailField);
      
      // Verificar que el campo está deshabilitado
      expect(textField.enabled, false);
    });
  });
}
