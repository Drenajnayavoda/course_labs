#!/usr/bin/env bash
set -euo pipefail

echo "Starting Docker CIS Benchmark Audit with docker-bench-security"
echo "================================================================="

if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: docker CLI not found. Install Docker before running this script."
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "ERROR: Docker daemon is not reachable. Start Docker service/Desktop first."
  exit 1
fi

OS_TYPE="$(uname -s || echo unknown)"
if [[ "$OS_TYPE" == "Linux" && "$(uname -r || true)" == *"Microsoft"* ]] || \
   [[ "${OS:-}" == "Windows_NT" ]]; then
  PLATFORM="Windows"
else
  case "$OS_TYPE" in
    Linux)  PLATFORM="Linux" ;;
    Darwin) PLATFORM="macOS" ;;
    *)      PLATFORM="Unknown" ;;
  esac
fi

BENCH_IMAGE="${DOCKER_BENCH_IMAGE:-docker/docker-bench-security:latest}"

echo "Detected platform: ${PLATFORM}"
echo "Using image: ${BENCH_IMAGE}"
echo ""

run_bench() {
  local mounts="$1"
  local extra_opts="$2"

  echo "Running Docker Bench Security container..."
  echo ""

  docker run --rm \
    --name "docker-bench-security-$(date +%s)" \
    --network host \
    --pid host \
    --userns host \
    --cap-add audit_control \
    --read-only \
    --security-opt no-new-privileges \
    ${extra_opts} \
    -e DOCKER_CONTENT_TRUST="${DOCKER_CONTENT_TRUST:-0}" \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    ${mounts} \
    --label docker_bench_security \
    "${BENCH_IMAGE}"
}

case "${PLATFORM}" in
  Linux)
    echo "Linux host detected – configuring mounts for full CIS coverage where possible"
    echo ""

    # Базовые директории, которые CIS использует для проверки конфигурации Docker и хоста
    MOUNTS="-v /etc:/etc:ro \
            -v /var/lib:/var/lib:ro \
            -v /usr/bin:/usr/bin:ro"

    if [ -f "/usr/bin/containerd" ] && [ ! -d "/usr/bin/containerd" ]; then
      MOUNTS="${MOUNTS} -v /usr/bin/containerd:/usr/bin/containerd:ro"
      echo "Mounting /usr/bin/containerd"
    fi

    if [ -f "/usr/bin/runc" ] && [ ! -d "/usr/bin/runc" ]; then
      MOUNTS="${MOUNTS} -v /usr/bin/runc:/usr/bin/runc:ro"
      echo "Mounting /usr/bin/runc"
    fi

    if [ -d "/usr/lib/systemd" ]; then
      MOUNTS="${MOUNTS} -v /usr/lib/systemd:/usr/lib/systemd:ro"
      echo "Mounting /usr/lib/systemd"
    elif [ -d "/lib/systemd" ]; then
      MOUNTS="${MOUNTS} -v /lib/systemd:/lib/systemd:ro"
      echo "Mounting /lib/systemd"
    fi

    # Docker daemon config
    if [ -d "/etc/docker" ]; then
      MOUNTS="${MOUNTS} -v /etc/docker:/etc/docker:ro"
      echo "Mounting /etc/docker"
    fi

    if [ -d "/var/log" ]; then
      MOUNTS="${MOUNTS} -v /var/log:/var/log:ro"
      echo "Mounting /var/log"
    fi

    run_bench "${MOUNTS}" ""
    ;;

  macOS)
    echo "macOS detected – Docker Desktop environment"
    echo "CIS checks will apply to the Linux VM used by Docker Desktop, not the macOS host kernel."
    echo ""

    MAC_MOUNTS=""
    # audit будет ограничен конфигурацией Docker Engine внутри VM через docker.sock
    if [ -d "/etc" ]; then
      MAC_MOUNTS="${MAC_MOUNTS} -v /etc:/etc:ro"
    fi

    run_bench "${MAC_MOUNTS}" ""

    echo ""
    echo "Note:"
    echo "- Some host-kernel and systemd-related CIS checks are not applicable on macOS."
    echo "- Treat results as audit of the Docker Linux VM configuration, not of macOS itself."
    ;;

  Windows)
    echo "Windows / WSL environment detected."
    echo ""

    # Определяем, работает ли Docker через WSL2
    if grep -qi "microsoft" /proc/version 2>/dev/null; then
      echo "Docker appears to be running under WSL (Linux kernel)."
      echo "CIS checks will apply to this WSL Linux environment and Docker Engine inside it."
      echo ""
      # Внутри WSL действуем как на обычном Linux
      MOUNTS="-v /etc:/etc:ro \
              -v /var/lib:/var/lib:ro \
              -v /usr/bin:/usr/bin:ro"

      if [ -f "/usr/bin/containerd" ] && [ ! -d "/usr/bin/containerd" ]; then
        MOUNTS="${MOUNTS} -v /usr/bin/containerd:/usr/bin/containerd:ro"
        echo "Mounting /usr/bin/containerd"
      fi

      if [ -f "/usr/bin/runc" ] && [ ! -d "/usr/bin/runc" ]; then
        MOUNTS="${MOUNTS} -v /usr/bin/runc:/usr/bin/runc:ro"
        echo "Mounting /usr/bin/runc"
      fi

      if [ -d "/etc/docker" ]; then
        MOUNTS="${MOUNTS} -v /etc/docker:/etc/docker:ro"
        echo "Mounting /etc/docker"
      fi

      if [ -d "/var/log" ]; then
        MOUNTS="${MOUNTS} -v /var/log:/var/log:ro"
        echo "Mounting /var/log"
      fi

      run_bench "${MOUNTS}" ""
    else
      echo "Docker Desktop on native Windows without WSL Linux context is not fully supported by docker-bench-security."
      echo "For full CIS Docker Benchmark coverage, run this script inside a Linux or WSL2 environment where Docker Engine is available."
      echo ""
    fi
    ;;

  *)
    echo "Unsupported or unknown platform: ${PLATFORM} (${OS_TYPE})"
    echo "This script supports Linux hosts, macOS (Docker Desktop) and Windows via WSL2."
    exit 1
    ;;
esac

echo ""
echo "================================================================="
echo "Audit complete. Review findings above and compare with CIS Docker Benchmark guidance:"
echo "https://www.cisecurity.org/benchmark/docker"
echo ""
