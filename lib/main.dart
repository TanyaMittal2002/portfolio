import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://crjlbksyvqcdtrdnojmn.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNyamxia3N5dnFjZHRyZG5vam1uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQyMTgzMjMsImV4cCI6MjA3OTc5NDMyM30.lMMds1pExY78zJOK8odbR75ZnxYBwCmskBkzW9l0mvA',
  );

  runApp(const PortfolioApp());
}
