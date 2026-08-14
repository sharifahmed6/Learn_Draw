import 'dart:async';

import 'package:app_links/app_links.dart';

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _subscription;

  Future<void> init({
    required void Function(Uri uri) onUri,
  }) async {
    _subscription = _appLinks.uriLinkStream.listen(
      onUri,
    );

    final initialUri = await _appLinks.getInitialLink();

    if (initialUri != null) {
      onUri(initialUri);
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
  }
}