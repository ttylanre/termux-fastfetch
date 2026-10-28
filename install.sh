#!/bin/bash

echo "🚀 Installing dependencies..."
pkg install -y fastfetch chafa termux-api jq gh

echo "📂 Creating configuration directories..."
mkdir -p ~/.config/fastfetch/scripts
mkdir -p ~/.config/fastfetch/images
mkdir -p ~/.local/bin

echo "⚙️ Copying fastfetch setup..."
cp -r config/fastfetch/* ~/.config/fastfetch/
cp bin/ff ~/.local/bin/ff
chmod +x ~/.config/fastfetch/scripts/*.sh
chmod +x ~/.local/bin/ff

echo "✅ Installation complete!"
echo "Make sure ~/.local/bin is in your PATH, then run 'ff'."
