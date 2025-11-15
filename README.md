# Network Traffic Security Lab: Offensive & Defensive Analysis

## Overview

This project details the creation of a two-Ubuntu-VM attacker/victim lab environment designed to analyze network traffic, exploit insecure services, and validate secure communication paths.

In this lab, over 1,500 packets were captured and analyzed across various protocols including **ARP, DNS, HTTP/HTTPS, SSH, and Telnet** using Wireshark and Nmap.

Several offensive tests were executed, including:
* TCP SYN/UDP scanning for service enumeration.
* Plaintext credential interception from an insecure Telnet session.
* Spoofed TCP RST session-kill attacks using `hping3`.
* A full Slowloris Denial of Service (DoS) attack that successfully exhausted all 150 Apache worker threads, reproducing a real-world denial-of-service condition.

This README documents the offensive findings, detection indicators, and the defensive validation of secure tunneling.

## Table of Contents
* [Lab Architecture](#lab-architecture)
* [Offensive Analysis & Findings](#offensive-analysis--findings)
    * [1. Service Enumeration (Nmap)](#1-service-enumeration-nmap)
    * [2. Plaintext Credential Interception (Telnet)](#2-plaintext-credential-interception-telnet)
    * [3. TCP Session Hijacking (RST Attack)](#3-tcp-session-hijacking-rst-attack)
    * [4. Denial of Service (Slowloris Attack)](#4-denial-of-service-slowloris-attack)
* [Defensive Analysis: Secure SSH Tunneling](#defensive-analysis-secure-ssh-tunneling)
* [Tools Used](#tools-used)
* [Key Takeaways](#key-takeaways)

---

## Lab Architecture

The lab consists of two primary Ubuntu VMs: an **Attacker (VM A: 44.65.10.54)** and a **Victim (VM B: 44.65.10.55)**.
* The **Attacker VM** was equipped with network analysis and penetration testing tools (Nmap, Wireshark, hping3, Slowloris).
* The **Victim VM** was intentionally configured with insecure services (Telnet, unhardened Apache) to serve as a target.

A secondary architecture was also configured for defensive analysis, as detailed in the [Defensive Analysis](#defensive-analysis-secure-ssh-tunneling) section.

---

## Offensive Analysis & Findings

### 1. Service Enumeration (Nmap)

The initial reconnaissance phase involved a TCP SYN scan (`-sS`) with OS detection (`-O`) against all ports (`-p-`) on the victim machine.

> `sudo nmap -sS -O -p- 44.65.10.55`

The scan immediately revealed several open ports, including dangerously insecure services like **Telnet (port 23)** and **HTTP (port 80)**, providing clear attack vectors.

![Nmap Scan Output](.assets/Nmap%20scan%20output%20(VMB).png)

### 2. Plaintext Credential Interception (Telnet)

Given that Telnet was open, a passive man-in-the-middle (MITM) attack was simulated using **Wireshark** to sniff traffic on port 23.

Since Telnet transmits all data in **plaintext**, the attacker was able to capture the login session and extract the username and password simply by following the TCP stream.

* **Username:** `aalliiccee`
* **Password:** `deeznutz`

This finding demonstrates the extreme risk of using legacy, unencrypted protocols.

![Telnet Credentials in Wireshark](.assets/Telnet%20credentials.png)

### 3. TCP Session Hijacking (RST Attack)

To demonstrate an active attack, a TCP reset (RST) packet was spoofed using `hping3` to forcibly terminate the active Telnet session between the attacker and the victim.

By sending a packet with the RST flag set, the victim's TCP stack was tricked into believing the session was no longer valid, immediately closing the connection. The **red packet (No. 2128)** in the Wireshark capture below is the spoofed RST packet that successfully killed the session.

![TCP RST Packet in Wireshark](.assets/TCP%20RST%20Packet.png)

### 4. Denial of Service (Slowloris Attack)

The most significant offensive test was a **Slowloris DoS attack** against the victim's Apache web server on port 80.

**How it works:** Slowloris works by opening many connections to the target web server and keeping them open for as long as possible. It does this by sending partial HTTP requests very slowly—but just fast enough to prevent the server's connection-timeout from kicking in.

#### Server-Side Impact: Thread Exhaustion

The attack was highly effective. The Apache server's connection pool was completely exhausted, with all **150 available worker threads** being consumed by the Slowloris tool. The `ps -elf` command on the victim server shows a massive list of `apache2` processes, all occupied by the attack, effectively locking out any legitimate users.

![Apache Worker Threads Exhausted by Slowloris](.assets/Apache%20Thread%20for%20Slowloirs%20attack%20(1).png)

#### Client-Side Impact: Site Unreachable

From a legitimate user's perspective, the server was completely inaccessible. Any attempt to access the website at `44.65.10.55` resulted in a connection timeout error, as the server had no available threads to respond to new requests.

![Browser error during Slowloris attack](.assets/Slowloris%20DoS%20%E2%80%9CSite%20Can%E2%80%99t%20Be%20Reached%E2%80%9D.png)

---

## Defensive Analysis: Secure SSH Tunneling

To contrast the insecure findings, a secure communication path was validated using an **SSH tunnel**. This architecture was designed to securely access a different target web server (`44.65.0.100`) that only serves plain HTTP.

The solution involves using PuTTY on a local machine to create an encrypted SSH tunnel through the bastion host (VM A, `44.65.10.54`).

**Traffic Flow:**
1.  The **User's Web Browser** connects to `http://localhost:7777`.
2.  **PuTTY**, configured for port forwarding, intercepts this local traffic.
3.  PuTTY encrypts the traffic and sends it through an **Encrypted SSH Tunnel** (Port 22) to VM A.
4.  **VM A (SSH Server)** decrypts the traffic and forwards it as a **Plain HTTP** (Port 80) request to the Target Web Server.

This method completely encrypts the traffic between the user's PC and the bastion host, protecting it from sniffing attacks like the Telnet interception demonstrated earlier.

![SSH Tunnel Architecture Diagram](.assets/Architecture%20Diagram.png)

---

## Tools Used

* **Nmap:** Network scanning and service enumeration.
* **Wireshark:** Packet capture and protocol analysis.
* **hping3:** Custom packet crafting and TCP RST attack.
* **Slowloris:** Layer 7 Denial of Service attack tool.
* **PuTTY:** SSH client and tunnel configuration.
* **Apache2:** Victim web server.
* **Ubuntu:** Operating system for all VMs.

---

## Key Takeaways

* **Insecure-by-Default:** Legacy protocols like Telnet offer no confidentiality and should never be exposed.
* **Recon is Key:** A simple Nmap scan revealed all necessary attack vectors.
* **DoS is Practical:** Application-layer DoS attacks like Slowloris are highly effective against web servers that are not properly hardened (e.g., without rate limiting or connection timeouts).
* **Defense in Depth:** SSH tunneling is a powerful and practical method for securing otherwise unencrypted traffic, protecting data in transit.
