#!/usr/bin/env bash
# monitor_test.sh
set -euo pipefail
PROCESS_NAME="test"
MONITOR_URL="https://test.com/monitoring/test/api"
LOG_FILE="/var/log/monitoring.log"
STATE_DIR="/var/lib/monitor_test"
STATE_FILE="${STATE_DIR}/last_pid"
CURL_TIMEOUT=10
CURL_CONNECT_TIMEOUT=5
timestamp() { date +"%Y-%m-%d %H:%M:%S"; }
log() { echo "$(timestamp) $*" >> "${LOG_FILE}"; }
ensure_dirs_and_perms() { mkdir -p "${STATE_DIR}"; touch "${LOG_FILE}"; chown root:root "${STATE_DIR}" "${LOG_FILE}" || true; chmod 755 "${STATE_DIR}" || true; chmod 644 "${LOG_FILE}" || true; }
get_current_pids() { if command -v pgrep >/dev/null 2>&1; then pids=$(pgrep -x "${PROCESS_NAME}" || true); else pids=$(pidof "${PROCESS_NAME}" || true); fi; [ -z "${pids}" ] && echo "" && return 0; echo "${pids}" | tr ' ' '\n' | sort -n | paste -sd "," -; }
read_saved_pids() { [ -f "${STATE_FILE}" ] && cat "${STATE_FILE}" || echo ""; }
save_pids() { echo -n "$1" > "${STATE_FILE}.tmp" && mv "${STATE_FILE}.tmp" "${STATE_FILE}"; chmod 644 "${STATE_FILE}" 2>/dev/null || true; }
call_monitor() { if command -v curl >/dev/null 2>&1; then curl --silent --show-error --fail --connect-timeout "${CURL_CONNECT_TIMEOUT}" --max-time "${CURL_TIMEOUT}" "${MONITOR_URL}" >/dev/null 2>&1 || return 1; elif command -v wget >/dev/null 2>&1; then wget --quiet --tries=1 --timeout="${CURL_TIMEOUT}" --server-response --spider "${MONITOR_URL}" >/dev/null 2>&1 || return 1; else return 2; fi; return 0; }
main() { ensure_dirs_and_perms; current_pids=$(get_current_pids); [ -z "${current_pids}" ] && exit 0; saved_pids=$(read_saved_pids); [ -n "${saved_pids}" ] && [ "${saved_pids}" != "${current_pids}" ] && log "Process '${PROCESS_NAME}' restarted: previous PID(s)='${saved_pids}' current PID(s)='${current_pids}'"; save_pids "${current_pids}"; call_monitor || rc=$? && [ $rc -eq 1 ] && log "Monitoring server unreachable or returned error for ${MONITOR_URL}. Current PID(s)='${current_pids}'"; }
main "$@"
