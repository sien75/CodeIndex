#!/bin/sh
set -e

INSTALL_DIR="${HOME}/.local/bin"
LIB_DIR="${INSTALL_DIR}/ci-coverage-lib"

if [ -f "${INSTALL_DIR}/ci-coverage" ]; then
  rm "${INSTALL_DIR}/ci-coverage"
  echo "Removed ${INSTALL_DIR}/ci-coverage"
else
  echo "ci-coverage not found at ${INSTALL_DIR}/ci-coverage"
fi

if [ -d "${LIB_DIR}" ]; then
  rm -r "${LIB_DIR}"
  echo "Removed ${LIB_DIR}"
fi

echo "Uninstalled ci-coverage."
