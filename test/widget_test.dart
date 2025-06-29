// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:camper_blis/core/layout/main_navigation_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:camper_blis/main.dart';
import 'package:camper_blis/shared/constants/strings.dart';

void main() {
  group('CamperBlisApp', () {
    testWidgets('App initializes and displays main navigation', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderScope(child: CamperBlisApp()));

      // Wait for the app to settle
      await tester.pumpAndSettle();

      // Verify that bottom navigation bar is present
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Verify all navigation tabs are present
      expect(find.text(Strings.homeTab), findsOneWidget);
      expect(find.text(Strings.mapTab), findsOneWidget);
      expect(find.text(Strings.favoritesTab), findsOneWidget);
      expect(find.text(Strings.profileTab), findsOneWidget);

      // Verify navigation icons are present
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.map), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('Bottom navigation switches between pages correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: CamperBlisApp()));
      await tester.pumpAndSettle();

      // Start on home tab (index 0) - CampsiteListPage should be visible
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Tap on map tab
      await tester.tap(find.byIcon(Icons.map));
      await tester.pumpAndSettle();

      // Verify map tab is now selected
      final BottomNavigationBar bottomNav = tester.widget(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNav.currentIndex, 1);

      // Tap on favorites tab
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();

      // Verify favorites tab is now selected and placeholder is shown
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.text('Coming Soon!'), findsOneWidget);

      // Tap on profile tab
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Verify profile tab is now selected and placeholder is shown
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Coming Soon!'), findsOneWidget);
    });

    testWidgets('Placeholder pages display correct content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: CamperBlisApp()));
      await tester.pumpAndSettle();

      // Navigate to favorites tab
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();

      // Verify placeholder content
      expect(
        find.text('Favorites'),
        findsNWidgets(2),
      ); // AppBar title + main content
      expect(find.text('Coming Soon!'), findsOneWidget);
      expect(
        find.text('🚧 This feature will be implemented in future phases 🚧'),
        findsOneWidget,
      );
      expect(
        find.byIcon(Icons.favorite),
        findsNWidgets(2),
      ); // Bottom nav + placeholder icon

      // Navigate to profile tab
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Verify placeholder content
      expect(
        find.text('Profile'),
        findsNWidgets(2),
      ); // AppBar title + main content
      expect(find.text('Coming Soon!'), findsOneWidget);
      expect(
        find.text('🚧 This feature will be implemented in future phases 🚧'),
        findsOneWidget,
      );
      expect(
        find.byIcon(Icons.person),
        findsNWidgets(2),
      ); // Bottom nav + placeholder icon
    });

    testWidgets('App uses correct theme and title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: CamperBlisApp()));
      await tester.pumpAndSettle();

      // Get the MaterialApp widget
      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));

      // Verify app configuration
      expect(materialApp.title, Strings.appName);
      expect(materialApp.debugShowCheckedModeBanner, false);
      expect(materialApp.theme, isNotNull);
    });
  });
}
