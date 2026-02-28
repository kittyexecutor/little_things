#!/bin/bash

REPORT="recon_$(hostname)_$(date +%F_%H-%M).txt"
SHOW_NETWORK=false
SHOW_USERS=false
SHOW_LOAD=false
SHOW_SERVICES=false
FULL=false

usage() {
	cat <<EOF
Usege: $0 [OPTIPNS]

      Opitons:
         --services   Show running services (systemd)
         --users      Show logged-in users and sudo group
         --load       Show top CPU processes
         --network    Show interfaces and listening ports
         --full       Run all sections
         --help       Show this help
EOF
          } 

for arg in "$@"
do
    case "$arg" in
        --services) SHOW_SERVICES=true ;;
	--users) SHOW_USERS=true ;;
	--load) SHOW_LOAD=true ;;
        --network) SHOW_NETWORK=true ;;
        --full) FULL=true ;;
	--help) usage; exit 0 ;;
	*) echo "Unknown option: $arg" >&2; usage; exit 1 ;;
    esac
done

if $FULL; then
	SHOW_NETWORK=true
        SHOW_USERS=true
        SHOW_LOAD=true
        SHOW_SERVICES=true
fi

echo "Linux Recon Report" | tee "$REPORT"
echo "Hostname: $(hostname)" | tee -a "$REPORT"
echo "Date: $(date)" | tee -a "$REPORT"
echo "----------------------------------" | tee -a "$REPORT"

echo -e "\n[System]" | tee -a "$REPORT"
uname -a | tee -a "$REPORT"
uptime | tee -a "$REPORT"
cat /etc/os-release | grep PRETTY_NAME | tee -a "$REPORT"

echo -e "\n[CPU / Memory]" | tee -a "$REPORT"
lscpu | grep 'Model name' | tee -a "$REPORT"
free -h | tee -a "$REPORT"

echo -e "\n[Disk]" | tee -a "$REPORT"
df -h | tee -a "$REPORT"

echo -e "\n[Docker]" | tee -a "$REPORT"
if command -v docker >/dev/null 2>&1; then
   docker ps -a | tee -a "$REPORT"
   docker --version | tee -a "$REPORT"
   docker compose version | tee -a "$REPORT"
else
echo "Docker or Docker Compose is not found" | tee -a "$REPORT"
fi

if $SHOW_NETWORK; then
   echo -e "\n[Network]" | tee -a "$REPORT"
   ip -br a | tee -a "$REPORT"
   ip route | tee -a "$REPORT"
   ss -tuln | tee -a "$REPORT"
fi

if $SHOW_USERS; then
   echo -e "\n[Users]" | tee -a "$REPORT"
   who | tee -a "$REPORT"
   grep '^sudo:' /etc/group 2>/dev/null | tee -a "$REPORT" || echo "sudo group not found"
fi

if $SHOW_LOAD; then
   echo -e "\n[Top Processes]" | tee -a "$REPORT"
   ps aux --sort=-%cpu | head -n 10 | tee -a "$REPORT"
fi

if $SHOW_SERVICES; then
   echo -e "\n[Services]" | tee -a "$REPORT"
   if command -v systemctl >/dev/null 2>&1; then
     systemctl list-units --type=service --state=running | tee -a "$REPORT"
   else
   echo "systemctl not found" | tee -a "$REPORT"
   fi
fi

echo -e "\nReport saved to "$REPORT""
