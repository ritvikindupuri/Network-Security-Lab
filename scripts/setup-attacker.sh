#!/bin/bash
#
# SCRIPT TO CONFIGURE THE ATTACKER VM
# This installs all the tools used for the offensive analysis.
#

echo "[+] Updating package lists..."
sudo apt-get update

echo "[+] Installing Nmap, hping3, Git, and Python..."
# Installs the tools used for Nmap scans [cite: 874], hping3 attacks[cite: 2187],
# and running the Slowloris script [cite: 2633, 2635]
sudo apt-get install nmap hping3 git python3-pip telnet -y

echo "[+] Cloning Slowloris attack tool..."
# Clones the Python script used for the DoS attack 
git clone https://github.com/gkbrk/slowloris.git

echo "[!] Attacker VM setup complete."
echo "[!] Remember to 'cd slowloris' and 'sudo pip install -r requirements.txt' if needed."
