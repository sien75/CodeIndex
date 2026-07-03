#!/bin/sh
set -e

INSTALL_DIR="${HOME}/.local/bin"
LIB_DIR="${INSTALL_DIR}/codeindex-coverage-lib"

if [ -f "${INSTALL_DIR}/codeindex-coverage" ]; then
  rm "${INSTALL_DIR}/codeindex-coverage"
  echo "Removed ${INSTALL_DIR}/codeindex-coverage"
else
  echo "codeindex-coverage not found at ${INSTALL_DIR}/codeindex-coverage"
fi

if [ -d "${LIB_DIR}" ]; then
  rm -r "${LIB_DIR}"
  echo "Removed ${LIB_DIR}"
fi

echo "Uninstalled codeindex-coverage."
