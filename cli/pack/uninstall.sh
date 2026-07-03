#!/bin/sh
set -e

INSTALL_DIR="${HOME}/.local/bin"
LIB_DIR="${INSTALL_DIR}/codeindex-pack-lib"

if [ -f "${INSTALL_DIR}/codeindex-pack" ]; then
  rm "${INSTALL_DIR}/codeindex-pack"
  echo "Removed ${INSTALL_DIR}/codeindex-pack"
else
  echo "codeindex-pack not found at ${INSTALL_DIR}/codeindex-pack"
fi

if [ -d "${LIB_DIR}" ]; then
  rm -r "${LIB_DIR}"
  echo "Removed ${LIB_DIR}"
fi

echo "Uninstalled codeindex-pack."
