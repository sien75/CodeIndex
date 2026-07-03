#!/bin/sh
set -e

INSTALL_DIR="${HOME}/.local/bin"
LIB_DIR="${INSTALL_DIR}/codeindex-verify-lib"

if [ -f "${INSTALL_DIR}/codeindex-verify" ]; then
  rm "${INSTALL_DIR}/codeindex-verify"
  echo "Removed ${INSTALL_DIR}/codeindex-verify"
else
  echo "codeindex-verify not found at ${INSTALL_DIR}/codeindex-verify"
fi

if [ -d "${LIB_DIR}" ]; then
  rm -r "${LIB_DIR}"
  echo "Removed ${LIB_DIR}"
fi

echo "Uninstalled codeindex-verify."
