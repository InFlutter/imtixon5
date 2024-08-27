import 'package:dars67/bloc/recip_bloc.dart';
import 'package:dars67/bloc/recip_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:dars67/views/screens/home_screen.dart';
void main() {
  testWidgets('Search functionality filters cars list', (WidgetTester tester) async {
    // Create a fake Firestore instance and populate it with test data
    final fakeFirestore = FakeFirebaseFirestore();
    await fakeFirestore.collection('recips').add({
      'recepName': 'Car 1',
      'recepDescription': '',
      'recepProducts': [],
      'imageUrl': 'url1',
    });
    await fakeFirestore.collection('recips').add({
      'recepName': 'Car 2',
      'recepDescription': '',
      'recepProducts': [],
      'imageUrl': 'url2',
    });
    await fakeFirestore.collection('recips').add({
      'recepName': 'Test Car',
      'recepDescription': '',
      'recepProducts': [],
      'imageUrl': 'url3',
    });

    // Create the BLoC and provide it to the widget tree
    final recipBloc = RecipBloc();

    await tester.pumpWidget(
      BlocProvider<RecipBloc>(
        create: (_) => recipBloc..add(LoadRecips()),
        child: MaterialApp(home: HomeScreen()),
      ),
    );

    // Verify initial state
    expect(find.text('Car 1'), findsOneWidget);
    expect(find.text('Car 2'), findsOneWidget);
    expect(find.text('Test Car'), findsOneWidget);

    // Enter text into the search field
    await tester.enterText(find.byType(TextField), 'Test');
    await tester.pump();

    // Verify search results
    expect(find.text('Car 1'), findsNothing);
    expect(find.text('Car 2'), findsNothing);
    expect(find.text('Test Car'), findsOneWidget);
  });
}
