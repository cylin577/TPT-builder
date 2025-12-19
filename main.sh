#!/bin/bash
set -e  # Exit on any error

LOGFILE="$HOME/tptbuild.log"
exec > >(tee "$LOGFILE") 2>&1  # Log stdout and stderr to a file

CURRENT_STEP="starting the script"

# Error handler
trap 'echo -e "\n❌ Oops, an error occurred while we were trying to: $CURRENT_STEP"; echo "Check the log at $LOGFILE"; read -p "Do you want to retry this step? (y/n): " choice; [[ $choice == "y" ]] && exec "$0"; exit 1' ERR

clear
echo "📦 This script will build The Powder Toy in 3 seconds."
sleep 3

# Go to the home directory
CURRENT_STEP="change to the home directory"
cd ~

# Update the package list
CURRENT_STEP="update the package list"
echo "📥 Updating the package list..."
sleep 0.2
sudo apt update
echo "✅ Done."

# Install the dependencies
CURRENT_STEP="install the dependencies"
echo "📦 Installing the dependencies..."
sleep 0.2
sudo apt install -y \
  git g++ python3 python-is-python3 meson ninja-build ccache pkg-config \
  libluajit-5.1-dev libcurl4-openssl-dev libssl-dev libfftw3-dev \
  zlib1g-dev libsdl2-dev libbz2-dev libjsoncpp-dev libpng-dev
echo "✅ Done."

# Download the source
CURRENT_STEP="clone the source code from GitHub"
echo "🌐 Downloading the source code..."
sleep 0.2
git clone https://github.com/The-Powder-Toy/The-Powder-Toy
echo "✅ Done."

# Build the optimized version
CURRENT_STEP="build the optimized version of the game"
echo "🔧 Building..."
sleep 0.2
cd ~/The-Powder-Toy
meson setup -Dbuildtype=debugoptimized build-optimized
cd build-optimized
meson compile -j $(nproc)

trap - ERR  # Clear the error trap
echo -e "\n🎉 Build complete! To run the game, type \"./powder\" in the terminal."
echo "📄 Build log saved to: $LOGFILE"
cd ~/The-Powder-Toy/build-optimized
