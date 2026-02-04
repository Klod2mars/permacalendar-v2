import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

Future<String> _loadLocalizedDoc(BuildContext context, String baseName) async {
  final locale = Localizations.localeOf(context);
  final codeFull = locale.toLanguageTag(); // ex "fr-FR"
  final code = locale.languageCode; // ex "fr"

  // Paths to test in order
  final candidates = [
    'assets/data/json_multilangue_doc/${baseName}_$codeFull.md',
    'assets/data/json_multilangue_doc/${baseName}_$code.md',
    'assets/data/json_multilangue_doc/${baseName}_en.md',
    'assets/data/json_multilangue_doc/${baseName}_fr.md',
  ];

  for (final path in candidates) {
    try {
      final s = await rootBundle.loadString(path);
      if (s.trim().isNotEmpty) return s;
    } catch (_) {
      // file not found -> next
    }
  }
  return 'Texte non disponible.';
}

class CreditContactScreen extends StatelessWidget {
  const CreditContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sobriety and readability theme
    final theme = Theme.of(context);
    final backgroundColor = const Color(0xFF101412); // Deep organic dark
    final textColor = const Color(0xFFE2E8F0);
    final accentColor = const Color(0xFFA7D1AB); // Soft plant green

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textColor.withOpacity(0.8)),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<String>(
        future: _loadLocalizedDoc(context, 'credit_contact'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data ?? 'Texte non disponible.';
          
          return SafeArea(
            child: Markdown(
              data: data,
              selectable: true,
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                p: GoogleFonts.inter(
                  fontSize: 15,
                  color: textColor.withOpacity(0.85),
                  height: 1.6,
                ),
                h1: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                h2: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: accentColor, 
                ),
                h3: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor.withOpacity(0.9),
                ),
                code: GoogleFonts.robotoMono(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: accentColor,
                  backgroundColor: Colors.transparent,
                ),
                blockSpacing: 24.0,
              ),
              onTapLink: (text, href, title) {
                // No external links expected for now, but ready for expansion
              },
            ),
          );
        },
      ),
    );
  }
}
