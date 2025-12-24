#!/usr/bin/env bash
set -euo pipefail

# Usage:
# ANDROID_SDK_ROOT=$HOME/Android/Sdk \
# KEYSTORE_PATH=android/keystore.jks KEYSTORE_PASSWORD=... KEY_ALIAS=alias KEY_PASSWORD=... \
# ./scripts/sign-and-align.sh android/app/build/outputs/apk/release/app-release-unsigned.apk

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <unsigned-apk-path> [output-apk-path]"
  exit 1
fi

UNSIGNED_APK=$1
OUT_APK=${2:-$(dirname "$UNSIGNED_APK")/app-release-signed.apk}

KEYSTORE_PATH=${KEYSTORE_PATH:-android/keystore.jks}
KEYSTORE_PASSWORD=${KEYSTORE_PASSWORD:-}
KEY_ALIAS=${KEY_ALIAS:-mykey}
KEY_PASSWORD=${KEY_PASSWORD:-}
ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}

if [ ! -f "$UNSIGNED_APK" ]; then
  echo "Unsigned APK not found: $UNSIGNED_APK"
  exit 2
fi
if [ ! -f "$KEYSTORE_PATH" ]; then
  echo "Keystore not found: $KEYSTORE_PATH"
  exit 3
fi

if [ -z "$KEYSTORE_PASSWORD" ]; then
  read -s -p "Enter keystore password: " KEYSTORE_PASSWORD
  echo
fi
if [ -z "$KEY_PASSWORD" ]; then
  read -s -p "Enter key password (if different): " KEY_PASSWORD
  echo
fi

echo "Signing APK..."
jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
  -keystore "$KEYSTORE_PATH" \
  -storepass "$KEYSTORE_PASSWORD" \
  -keypass "$KEY_PASSWORD" \
  "$UNSIGNED_APK" "$KEY_ALIAS"

echo "Locating zipalign..."
ZIPALIGN=""
if [ -n "${ANDROID_SDK_ROOT:-}" ]; then
  # choose latest build-tools folder containing zipalign
  if [ -d "$ANDROID_SDK_ROOT/build-tools" ]; then
    ZIPALIGN=$(ls -d "$ANDROID_SDK_ROOT"/build-tools/*/zipalign 2>/dev/null | tail -n1 || true)
  fi
fi
if [ -z "$ZIPALIGN" ]; then
  echo "zipalign not found. Make sure Android SDK build-tools are installed and ANDROID_SDK_ROOT is set." >&2
  exit 4
fi

echo "Aligning APK..."
mkdir -p "$(dirname "$OUT_APK")"
"$ZIPALIGN" -v 4 "$UNSIGNED_APK" "$OUT_APK"

echo "Signed and aligned APK created at: $OUT_APK"
