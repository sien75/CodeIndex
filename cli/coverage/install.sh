#!/bin/sh
set -e

INSTALL_DIR="${HOME}/.local/bin"
LIB_DIR="${INSTALL_DIR}/codeindex-coverage-lib"
mkdir -p "${LIB_DIR}/bin" "${LIB_DIR}/lib"

REPO_BASE="https://raw.githubusercontent.com/sien75/CodeIndex/refs/heads/main/cli/coverage"

echo "Downloading codeindex-coverage..."
curl -fsSL "${REPO_BASE}/bin/codeindex-coverage.mjs" -o "${LIB_DIR}/bin/codeindex-coverage.mjs"
curl -fsSL "${REPO_BASE}/lib/utils.mjs" -o "${LIB_DIR}/lib/utils.mjs"
curl -fsSL "${REPO_BASE}/lib/init.mjs" -o "${LIB_DIR}/lib/init.mjs"
curl -fsSL "${REPO_BASE}/lib/mark.mjs" -o "${LIB_DIR}/lib/mark.mjs"
curl -fsSL "${REPO_BASE}/lib/status.mjs" -o "${LIB_DIR}/lib/status.mjs"

cat > "${INSTALL_DIR}/codeindex-coverage" << 'EOF'
#!/bin/sh
exec node "${HOME}/.local/bin/codeindex-coverage-lib/bin/codeindex-coverage.mjs" "$@"
EOF

chmod +x "${INSTALL_DIR}/codeindex-coverage"

echo "Installed codeindex-coverage to ${INSTALL_DIR}/codeindex-coverage"
echo "Make sure ${INSTALL_DIR} is in your PATH."
echo "Test with: codeindex-coverage help"
