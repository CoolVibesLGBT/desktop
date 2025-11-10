#!/bin/bash
set -e

APP_NAME="CoolVibes"
MAIN_GO="main.go"
OUTPUT_DIR="output"

mkdir -p "$OUTPUT_DIR"

echo "=== Building macOS executable ==="
GOOS=darwin GOARCH=arm64 CGO_ENABLED=1 go build -o "${OUTPUT_DIR}/${APP_NAME}" $MAIN_GO
echo "macOS executable created: ${OUTPUT_DIR}/${APP_NAME}"

echo "=== Creating macOS .app bundle ==="
APP_BUNDLE="${OUTPUT_DIR}/${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

rm -rf "$APP_BUNDLE"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"
cp "${OUTPUT_DIR}/${APP_NAME}" "$MACOS_DIR/"

# İcon dosyasını kopyala
if [ ! -f "${OUTPUT_DIR}/icon.icns" ]; then
  echo "ERROR: Icon file '${OUTPUT_DIR}/icon.icns' not found. Please put your icon.icns in the output folder."
  exit 1
fi
cp "${OUTPUT_DIR}/icon.icns" "$RESOURCES_DIR/"

cat > "${CONTENTS_DIR}/Info.plist" <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" 
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key>
  <string>$APP_NAME</string>
  <key>CFBundleDisplayName</key>
  <string>$APP_NAME</string>
  <key>CFBundleIdentifier</key>
  <string>com.yourcompany.$APP_NAME</string>
  <key>CFBundleVersion</key>
  <string>1.0.0</string>
  <key>CFBundleExecutable</key>
  <string>$APP_NAME</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleIconFile</key>
  <string>icon.icns</string>
  <key>LSUIElement</key>
  <true/>
</dict>
</plist>
EOL
echo "Info.plist created"

echo "=== Creating .dmg installer ==="
DMG_NAME="${OUTPUT_DIR}/${APP_NAME}.dmg"
hdiutil create -volname "$APP_NAME" -srcfolder "$APP_BUNDLE" -ov -format UDZO "$DMG_NAME"
echo "DMG created: $DMG_NAME"

echo "=== macOS Build finished ==="