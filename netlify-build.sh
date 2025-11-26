#!/usr/bin/env bash
set -euo pipefail

# Install Flutter (cached between builds) and build the web bundle.
FLUTTER_VERSION="${FLUTTER_VERSION:-stable}"
FLUTTER_DIR="$HOME/.flutter-sdk-$FLUTTER_VERSION"

if [ ! -d "$FLUTTER_DIR" ]; then
  git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

flutter config --enable-web
flutter --version
flutter pub get
flutter build web --release

# Ensure SPA routing works on Netlify.
if [ -f "web/_redirects" ]; then
  mkdir -p build/web
  cp web/_redirects build/web/_redirects
fi
