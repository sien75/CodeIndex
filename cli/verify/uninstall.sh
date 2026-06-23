#!/bin/sh
set -e

INSTALL_DIR="${HOME}/.local/bin"
LIB_DIR="${INSTALL_DIR}/ci-verify-lib"

if [ -f "${INSTALL_DIR}/ci-verify" ]; then
  rm "${INSTALL_DIR}/ci-verify"
  echo "Removed ${INSTALL_DIR}/ci-verify"
else
  echo "ci-verify not found at ${INSTALL_DIR}/ci-verify"
fi

if [ -d "${LIB_DIR}" ]; then
  rm -r "${LIB_DIR}"
  echo "Removed ${LIB_DIR}"
fi

echo "Uninstalled ci-verify."
