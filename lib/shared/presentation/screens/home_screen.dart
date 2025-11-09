// --- Début temporaire : diagnostic plein écran (à retirer ensuite) ---
return Scaffold(
  appBar: CustomAppBar(title: 'Diagnostic Dashboard (temp)', actions: []),
  body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: FutureBuilder<ByteData>(
      future: rootBundle.load('assets/images/backgrounds/dashboard_organic_final.png'),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text('Lecture de l\'asset en cours...'),
            ],
          ));
        }
        if (snap.hasError) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 12),
                Text('Échec lecture asset', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.error)),
                const SizedBox(height: 8),
                Text('${snap.error}', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Text('Vérifier pubspec.yaml, le chemin et la casse du fichier.', textAlign: TextAlign.center),
              ],
            ),
          );
        }
        // success
        final data = snap.data!;
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 420,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset('assets/images/backgrounds/dashboard_organic_final.png', fit: BoxFit.cover),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Asset OK', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Path: assets/images/backgrounds/dashboard_organic_final.png', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text('Size: ${data.lengthInBytes} bytes', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Si l\'image ci-dessus est visible → l’asset est packagé et lisible.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text('Si elle est absente mais "Asset OK", alors problème d\'affichage (overlay/contraintes).', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        );
      },
    ),
  ),
);
// --- Fin temporaire ---
