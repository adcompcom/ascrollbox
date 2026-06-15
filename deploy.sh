#!/bin/bash
# Build y despliega el APK al dispositivo via adb push + auto-instala
set -e

DEVICE="adb-781ad5d9-4n2NOP._adb-tls-connect._tcp"
APK="build/app/outputs/flutter-apk/app-debug.apk"

echo "🔨 Compilando..."
flutter build apk --debug --quiet

echo "📦 Copiando al dispositivo..."
adb -s "$DEVICE" push "$APK" /data/local/tmp/ascrollbox.apk

echo "📲 Instalando..."
adb -s "$DEVICE" shell pm install -t -r /data/local/tmp/ascrollbox.apk

echo "🚀 Lanzando..."
adb -s "$DEVICE" shell am start -n com.ascrollbox.ascrollbox/.MainActivity

echo "✅ Listo"
