# Network Traffic Security Lab – Offensive & Defensive Analysis
Hands-on offensive and defensive security project performed using two Ubuntu VMs in an isolated attacker → victim network environment.  
This lab simulates real-world scenarios including packet analysis, insecure protocol exploitation, DoS attacks, tunneling, and raw packet injection.

---

## 🚀 Overview
This project demonstrates:
- Network traffic capture & protocol analysis (ARP, DNS, HTTP/HTTPS, SSH, Telnet)
- Offensive security techniques (credential interception, TCP RST session resets, DoS)
- Server-side behavior under stress (Apache worker exhaustion)
- Secure tunneling using SSH (local port forwarding)
- VM-based lab architecture suitable for security engineering practice

---

## 🧩 Lab Architecture

![Architecture Diagram](.assets/Architecture Diagram.png)

Two Ubuntu VMs were configured:
- **Attacker VM**: Wireshark, Nmap, hping3, Slowloris script  
- **Victim VM**: Ubuntu server running SSH, Telnet, Apache HTTPD  

---

## 📊 1. Nmap Reconnaissance & Enumeration

Performed full TCP SYN scan + OS detection:
