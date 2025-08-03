#!/usr/bin/env bash
set -e

# === CONFIG ===
WORKDIR="$HOME/Downloads/displaylink_tmp"
DL_URL="https://www.synaptics.com/sites/default/files/exe_files/2025-04/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.1.1-EXE.zip"
DL_ZIP="DisplayLink_USB_Graphics_Software.zip"

echo "[1/8] Creating working directory at $WORKDIR..."
mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo "[2/8] Downloading DisplayLink driver..."
wget -O "$DL_ZIP" "$DL_URL"

echo "[3/8] Unzipping archive..."
unzip -o "$DL_ZIP"

echo "[4/8] Extracting .run archive manually..."
# sudo ./displaylink-driver-6.1.1-17.run --noexec --keep
sudo bash ./displaylink-driver-6.1.1-17.run --noexec --keep

echo "[5/8] Fixing ownership and permissions..."
sudo chown -R "$USER:$USER" displaylink-driver-6.1.1/
sudo chmod -R u+rwX displaylink-driver-6.1.1/
cd displaylink-driver-6.1.1/

echo "[6/8] Placing old evdi driver packages..."
rm evdi.tar.gz
curl -L https://github.com/DisplayLink/evdi/archive/refs/tags/v1.14.2.tar.gz -o evdi.tar.gz


echo "[7/8] Installing/check required packages..."
sudo apt update
sudo apt install -y dkms gcc-12 g++-12 make linux-headers-$(uname -r) unzip curl

echo "[8/8] Patching installer..."
sed -i 's/tar xf "\$TARGZ" -C "\$EVDI"/tar xf "\$TARGZ" -C "\$EVDI" --strip-components=1/' displaylink-installer.sh

echo "[🚀 Installing DisplayLink driver...]"
sudo bash ./displaylink-installer.sh install

echo "[✅ Done] Driver installed. Reboot if prompted."
