#!/usr/bin/env bash
set -euo pipefail

# Builds a runnable ClaudeUsageSystray.app without Xcode.
#
# `swift build` alone produces a bare executable with no bundle identifier,
# which makes UNUserNotificationCenter abort on launch. Wrapping the binary in
# a minimal .app bundle — reusing the same Info.plist the Xcode build uses —
# gives the process an identity, hides the Dock icon (LSUIElement), and lets
# notifications work. This is a dev/run convenience; signed, notarized release
# builds still come from the Xcode project.

cd "$(dirname "$0")"

CONFIG="${1:-release}"
EXE="ClaudeUsageSystray"
APP="$EXE.app"

swift build -c "$CONFIG"
BIN="$(swift build -c "$CONFIG" --show-bin-path)/$EXE"

rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
cp "$BIN" "$APP/Contents/MacOS/$EXE"

# Fill the Xcode build variables in Info.plist with concrete values.
sed -e 's/$(EXECUTABLE_NAME)/'"$EXE"'/g' \
    -e 's/$(PRODUCT_BUNDLE_IDENTIFIER)/com.claude.usage-systray/g' \
    -e 's/$(MACOSX_DEPLOYMENT_TARGET)/13.0/g' \
    Resources/Info.plist > "$APP/Contents/Info.plist"

echo "Built $APP"
echo "Run:  open $APP"
echo "Logs: ./$APP/Contents/MacOS/$EXE"
