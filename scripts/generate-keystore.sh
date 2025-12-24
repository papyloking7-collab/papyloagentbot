#!/usr/bin/env bash
set -euo pipefail

# Usage: KEYSTORE_PATH=android/keystore.jks KEYSTORE_PASSWORD=pass KEY_ALIAS=mykey KEY_PASSWORD=pass ./scripts/generate-keystore.sh

KEYSTORE_PATH=${KEYSTORE_PATH:-android/keystore.jks}
KEYSTORE_PASSWORD=${KEYSTORE_PASSWORD:-}
KEY_ALIAS=${KEY_ALIAS:-mykey}
KEY_PASSWORD=${KEY_PASSWORD:-}
DN=${DN:-"CN=Your Name, OU=Dev, O=Org, L=City, ST=State, C=US"}

if [ -f "$KEYSTORE_PATH" ]; then
  echo "Keystore already exists at $KEYSTORE_PATH"
  exit 0
fi

echo "Generating keystore at $KEYSTORE_PATH"
mkdir -p "$(dirname "$KEYSTORE_PATH")"

if [ -z "$KEYSTORE_PASSWORD" ]; then
  read -s -p "Enter keystore password: " KEYSTORE_PASSWORD
  echo
fi
if [ -z "$KEY_PASSWORD" ]; then
  read -s -p "Enter key password (can be same): " KEY_PASSWORD
  echo
fi

keytool -genkeypair \
  -v \
  -keystore "$KEYSTORE_PATH" \
  -alias "$KEY_ALIAS" \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storepass "$KEYSTORE_PASSWORD" \
  -keypass "$KEY_PASSWORD" \
  -dname "$DN"

echo "Keystore generated: $KEYSTORE_PATH"
