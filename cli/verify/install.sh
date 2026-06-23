#!/bin/sh
set -e

INSTALL_DIR="${HOME}/.local/bin"
LIB_DIR="${INSTALL_DIR}/ci-verify-lib"
mkdir -p "${LIB_DIR}/bin" "${LIB_DIR}/lib"

REPO_BASE="https://raw.githubusercontent.com/sien75/CodeIndex/refs/heads/main/cli/verify"

echo "Downloading ci-verify..."
curl -fsSL "${REPO_BASE}/bin/ci-verify.mjs" -o "${LIB_DIR}/bin/ci-verify.mjs"
curl -fsSL "${REPO_BASE}/lib/extract.mjs" -o "${LIB_DIR}/lib/extract.mjs"
curl -fsSL "${REPO_BASE}/lib/check-mermaid.mjs" -o "${LIB_DIR}/lib/check-mermaid.mjs"
curl -fsSL "${REPO_BASE}/lib/check-sourcemap.mjs" -o "${LIB_DIR}/lib/check-sourcemap.mjs"
curl -fsSL "${REPO_BASE}/package.json" -o "${LIB_DIR}/package.json"

echo "Installing dependencies..."
cd "${LIB_DIR}" && npm install --production --silent

cat > "${INSTALL_DIR}/ci-verify" << 'EOF'
#!/bin/sh
exec node "${HOME}/.local/bin/ci-verify-lib/bin/ci-verify.mjs" "$@"
EOF

chmod +x "${INSTALL_DIR}/ci-verify"

echo "Installed ci-verify to ${INSTALL_DIR}/ci-verify"
echo "Make sure ${INSTALL_DIR} is in your PATH."
echo "Test with: ci-verify help"
