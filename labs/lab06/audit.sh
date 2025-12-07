set -euo pipefail

echo "Starting Docker CIS Benchmark Audit with docker-bench-security"
echo "================================================================="

if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: docker CLI not found. Install Docker before running this script"
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "ERROR: Docker daemon is not reachable. Start Docker service/Desktop first"
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

DEFAULT_BENCH_IMAGE="docker/docker-bench-security:latest"
BENCH_IMAGE="${DOCKER_BENCH_IMAGE:-$DEFAULT_BENCH_IMAGE}"

echo "Detected platform: ${PLATFORM}"
echo "Using image: ${BENCH_IMAGE}"
echo ""

# Проверка наличия образа и опциональный pull, без автопулла latest
if ! docker image inspect "${BENCH_IMAGE}" >/dev/null 2>&1; then
  echo "Bench image ${BENCH_IMAGE} not found locally."
  echo "Pulling it explicitly (controlled, not implicit latest)..."
  docker pull "${BENCH_IMAGE}"
  echo ""
fi

# Хук для предварительного сканирования образа, если есть trivy/grype
if command -v trivy >/dev/null 2>&1; then
  echo "Running Trivy scan for ${BENCH_IMAGE} (basic image vulnerability check)..."
  trivy image --quiet --severity HIGH,CRITICAL "${BENCH_IMAGE}" || true
  echo ""
fi

run_bench() {
  local mounts="$1"
  local extra_opts="$2"

  echo "Running Docker Bench Security container (audit-only, elevated profile)"
  echo "NOTE: --network host / --pid host / docker.sock:ro are used ONLY for host security audit."
  echo ""

  docker run --rm \
    --name "docker-bench-security-$(date +%s)" \
    --network host \
    --pid host \
    --userns host \
    --cap-add audit_control \
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
    echo "Linux host detected – configuring mounts for CIS Docker Benchmark coverage"
    echo ""

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
    echo "macOS detected – Docker Desktop (Apple Silicon) environment"
    echo "docker-bench-security is designed for native Linux hosts and is unstable/unsupported on Docker Desktop in this setup"
    echo ""
    echo "For this lab:"
    echo "- Create a small Linux VM (e.g., Ubuntu) or use WSL2 on Windows"
    echo "- Install Docker Engine there and run this script inside that Linux environment"
    echo ""
    echo "This ensures the CIS Docker Benchmark checks are executed against a real Linux host"
    echo "not the macOS Desktop abstraction layer"
    exit 0
    ;*

  Windows)
    echo "Windows / WSL environment detected"
    echo ""

    if grep -qi "microsoft" /proc/version 2>/dev/null; then
      echo "Docker appears to be running under WSL (Linux kernel)"
      echo "CIS checks will apply to this WSL Linux environment and Docker Engine inside it"
      echo ""

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
    echo "This script supports Linux hosts, macOS (as a wrapper that recommends Linux VM), and Windows via WSL2"
    exit 1
    ;;
esac

echo ""
echo "================================================================="
echo "Audit complete. Review findings above and compare with CIS Docker Benchmark guidance:"
echo "https://www.cisecurity.org/benchmark/docker"
echo ""
