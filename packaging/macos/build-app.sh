#!/bin/sh
set -eu

project_dir=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
app_dir="$project_dir/dist/LacType.app"
icon_source="$project_dir/assets/lactype-icon.png"
iconset_dir="$project_dir/target/LacType.iconset"

cd "$project_dir"
cargo build --release --package lactype

rm -rf "$app_dir" "$iconset_dir"
mkdir -p "$app_dir/Contents/MacOS" "$app_dir/Contents/Resources" "$iconset_dir"
cp target/release/lactype "$app_dir/Contents/MacOS/lactype"
cp packaging/macos/Info.plist "$app_dir/Contents/Info.plist"

for spec in "16 icon_16x16.png" "32 icon_16x16@2x.png" \
  "32 icon_32x32.png" "64 icon_32x32@2x.png" \
  "128 icon_128x128.png" "256 icon_128x128@2x.png" \
  "256 icon_256x256.png" "512 icon_256x256@2x.png" \
  "512 icon_512x512.png" "1024 icon_512x512@2x.png"; do
  size=${spec%% *}
  name=${spec#* }
  sips -z "$size" "$size" "$icon_source" --out "$iconset_dir/$name" >/dev/null
done

iconutil -c icns "$iconset_dir" -o "$app_dir/Contents/Resources/AppIcon.icns"
codesign --force --deep --sign - "$app_dir"
codesign --verify --deep --strict --verbose=2 "$app_dir"
echo "$app_dir"
