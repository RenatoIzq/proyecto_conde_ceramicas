import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:proyecto_conde_ceramicas/pages/bienvenida_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:proyecto_conde_ceramicas/utils/database_seeder.dart';

const supabaseUrl = 'https://xthybisjmbmlahdamtdu.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh0aHliaXNqbWJtbGFoZGFtdGR1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQwOTkxOTUsImV4cCI6MjA3OTY3NTE5NX0.YAlHQajh4PXZegFK6XqqPFiWqyQn14XWTrIsMw99wSE';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  await initializeDateFormatting('es_ES', null);
  //await seedDatabase(); //solo una vez
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conde Cerámicas',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('es', 'ES'), const Locale('en', 'US')],
      locale: const Locale('es', 'ES'),
      home: BienvenidaPage(),
    );
  }
}
