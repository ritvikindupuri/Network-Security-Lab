#This script automates the setup of the "victim" machine, installing the web server and the vulnerable Telnet service.




#!/bin/bash
#
# SCRIPT TO CONFIGURE THE VICTIM VM
# This installs the services you targeted in your lab.
# WARNING: This is intentionally insecure and for lab use only.
#

echo "[+] Updating package lists..."
sudo apt-get update

echo "[+] Installing Apache2 web server..."
# Installs Apache, which was the target for the Slowloris attack
sudo apt-get install apache2 -y

echo "[+] Installing insecure Telnet server..."
# Installs the telnet server for the credential-sniffing portion of the lab
sudo apt-get install telnetd -y

echo "[+] Victim VM setup complete. The following insecure services are active:"
echo "  - Apache2 (Port 80)"
echo "  - Telnet (Port 23)"
