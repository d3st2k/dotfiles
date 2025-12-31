#!/usr/bin/env bash

# Colors
RED="\033[0;31m"
CYAN="\033[0;36m"
GRAY="\033[0;90m"
BOLD="\033[1m"
NORMAL="\033[0m"

# Default values
ARCH="$(uname -m | sed 's/x86_64/x64/;s/aarch64/aarch64/')"
OS="linux"
_SYS="$OS-$ARCH"
TOOL="java"
ARTIFACTORY="https://artifacts.rbi.tech/artifactory"
CURRENT_SHELL=$(ps -p $$ -o comm=)

# Find the rc file for SHELL
if [[ "$CURRENT_SHELL" == "zsh" ]]; then
    RC_FILE="$HOME/.zshrc"
elif [[ "$CURRENT_SHELL" == "bash" ]]; then
    RC_FILE="$HOME/.bashrc"
else
    RC_FILE="$HOME/.profile"
fi

# Get user input for tool version
_VER="${_VER:-${version:-21.0.7.6.1}}" # See https://artifacts.rbi.tech/ui/repos/tree/General/corretto-aws-raw-proxy/downloads/resources
if [[ -z "$_VER" ]]; then
	echo -ne "${CYAN}Enter ${TOOL} version (default: ${_VER}): ${NORMAL}"
	read -r USER_INPUT
	_VER="${USER_INPUT:-21.0.7.6.1}"
fi

# Tool directory setup
_PREFIX="${_PREFIX:-$HOME/packages/$TOOL}"
_DIR="${_DIR:-$_PREFIX/$_VER$_SYS}"
_CURRENT="$_PREFIX/current"
_BASE_URL="corretto-aws-raw-proxy/downloads/resources/${_VER}/-amazon-corretto-${_VER}-${_SYS}.tar.gz"

JAVA_HOME="${JAVA_HOME:-$_PREFIX/jvm/java_$VERSION_$SYSTEM}"

echo -e "\n${BOLD}🛠️ Installing ${CYAN}${BOLD}${TOOL}${NORMAL}"

# Install Java
# The value of ${CUSTOM_URL} needs to be replaced with the correct one for your JAVA version 
mkdir -p "${JAVA_HOME}" >/dev/null 2>&1
curl -sL --compressed 
	"${ARTIFACTORY}/${JAVA_BASE_URL}/${CUSTOM_URL}" | \
    tar xz --no-same-owner --strip-components=1 -C "${JAVA_HOME}"
EXITCODE=$?
if [ $EXITCODE -eq 0 ]; then
  echo -e "${GRAY}${TOOL} v${VERSION} installed in ${JAVA_HOME}${NORMAL}"
else
  echo -e "${RED}${TOOL} v${VERSION} could not be installed${NORMAL}"
  [[ "${BASH_SOURCE[0]}" == "${0}" ]] && exit 1 || return 1
fi

# Add to shell rc files if not already present
RC_FILE="$HOME/.bashrc"
[ -f "$RC_FILE" ] && grep -qF "$ENV_FILE" "$RC_FILE" || echo ". $ENV_FILE" >> "$RC_FILE"

RC_FILE="$HOME/.zshrc"
[ -f "$RC_FILE" ] && grep -qF "$ENV_FILE" "$RC_FILE" || echo ". $ENV_FILE" >> "$RC_FILE"

echo -e "${GRAY}${TOOL} shell integration added${NORMAL}"

# Source env file for current shell
. "$ENV_FILE"

echo -e "✅ Setup complete.\n"

### Examples:
#     ./java.sh
#     JAVA_HOME=~/.java VERSION=22 source /workspace/apex-coder/scripts/java.sh
