## Scripts

### 1. concatenation_and_unique.py

Merges three text files, removes duplicate lines, sorts the result, and writes it to an output file.

Default file paths are defined in lines 3–6.  
You can modify them if needed.

### 2. recon.sh

Collecti7ng data and save report to file regards main servers information for system which hosts software based on Docker.

A simple CLI utility for quick Linux system inspection.
Designed for DevOps, SREs, and system engineers to collect essential host information for troubleshooting, audits, or incident response.

The script prints results to the terminal and saves a report file:
recon_<hostname>_<date>.txt

Features

Always included

System info (OS, kernel, uptime)

CPU and memory usage

Disk usage

Docker status (if installed)

Optional flags

--network   Interfaces, routes, listening ports
--users     Logged-in users and sudo group
--load      Top CPU-consuming processes
--services  Running systemd services
--full      Run all checks
--help      Show usage

The tool safely handles missing components (Docker, systemctl, etc.).

Usage
chmod +x recon.sh
./recon.sh --full

Lightweight, dependency-free, and useful for quick system diagnostics.

### 3. dockerout.sh

A small but powerful tool that helps L1 engineers quickly download a Docker image and export it as a compressed tar archive for sharing with clients or other teams.
Use `--help` to see usage instructions.
Make sure to provide the arguments in the correct order:
`<app> <version> <registry>`

Arguments:
  app        Image name (e.g. nginx)
  version    Image tag (e.g. 1.25)
  registry   Registry/repository prefix (e.g. docker.io/library)
  
### 4. subdomine-recon.sh

This script combines several utilities (crt.sh, assetfinder, Gobuster, httpx) to quickly collect subdomains for a bug bounty or penetration-testing target.
It automates multiple reconnaissance techniques and merges the results into a single list of discovered subdomains. The script then checks which domains are live and filters out inactive hosts.

You are free to use this script for bug bounty programs or penetration testing, but do not use it for illegal activities.

The script accepts two parameters:
`./subdomain-recon.sh <domain.com> <output_directory>`
Example:
`./subdomain-recon.sh example.com /home/username/Documents/example-com`
The first parameter is the target domain, and the second parameter is the directory where the results will be saved.

Requirements:
1. Your operating system must have the following utilities installed:
`   assetfinder
   gobuster
   httpx
   curl
   jq
   sed
   awk
   sort
   cat
   mv`

2. The script expects the following wordlist to exist:
`/usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt`
If this file is stored in a different location on your system, edit the path manually in the script (around line 29).
