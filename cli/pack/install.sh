#!/bin/sh
set -e

INSTALL_DIR="${HOME}/.local/bin"
LIB_DIR="${INSTALL_DIR}/codeindex-pack-lib"
mkdir -p "${LIB_DIR}/bin" "${LIB_DIR}/lib"

REPO_BASE="https://raw.githubusercontent.com/sien75/CodeIndex/refs/heads/main/cli/pack"

echo "Downloading codeindex-pack..."
curl -fsSL "${REPO_BASE}/bin/codeindex-pack.mjs" -o "${LIB_DIR}/bin/codeindex-pack.mjs"
curl -fsSL "${REPO_BASE}/lib/pack.mjs" -o "${LIB_DIR}/lib/pack.mjs"

cat > "${INSTALL_DIR}/codeindex-pack" << 'EOF'
#!/bin/sh
exec node "${HOME}/.local/bin/codeindex-pack-lib/bin/codeindex-pack.mjs" "$@"
EOF

chmod +x "${INSTALL_DIR}/codeindex-pack"

echo "Installed codeindex-pack to ${INSTALL_DIR}/codeindex-pack"
echo "Make sure ${INSTALL_DIR} is in your PATH."
echo "Test with: codeindex-pack help"
