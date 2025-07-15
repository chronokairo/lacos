import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lacos/screens/login/cadastro_page.dart';

void main() {
  testWidgets('Formulário de cadastro aparece e aceita entrada', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

    // O título correto é 'Cadastro Laços'
    expect(find.text('Cadastro Laços'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));

    await tester.enterText(find.byType(TextFormField).at(0), 'Usuário Teste');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'teste@exemplo.com',
    );
    await tester.enterText(find.byType(TextFormField).at(2), '1234');

    expect(find.text('Usuário Teste'), findsOneWidget);
    expect(find.text('teste@exemplo.com'), findsOneWidget);
    expect(find.text('1234'), findsOneWidget);
  });
}
