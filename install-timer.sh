#!/bin/bash
# Install systemd timer for automated updates

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing fullupdate systemd service and timer..."

# Create service file with correct path
sudo tee /etc/systemd/system/fullupdate.service > /dev/null <<EOF
[Unit]
Description=System Update via fullupdate script
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=${SCRIPT_DIR}/fullupdate
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Copy timer file
sudo cp "${SCRIPT_DIR}/fullupdate.timer" /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload

# Enable and start timer
sudo systemctl enable fullupdate.timer
sudo systemctl start fullupdate.timer

echo "Installation complete!"
echo ""
echo "Timer status:"
sudo systemctl status fullupdate.timer --no-pager
echo ""
echo "Next scheduled run:"
sudo systemctl list-timers fullupdate.timer --no-pager
echo ""
echo "To run manually: sudo systemctl start fullupdate.service"
echo "To disable timer: sudo systemctl disable --now fullupdate.timer"
