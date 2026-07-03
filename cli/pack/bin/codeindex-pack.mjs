#!/usr/bin/env node

import { pack } from '../lib/pack.mjs';

const args = process.argv.slice(2);
const command = args[0];

if (command === 'help' || command === '--help') {
  console.log(`codeindex-pack — Pack source files into a standalone runtime for static deployment

Usage:
  codeindex-pack [projectDir]    Pack referenced source files into codeindex-runtime.js
  codeindex-pack help             Show this help

Packs all source files referenced in window.__sourceMap across all HTML files
in .codeindex/views/ into a single codeindex-runtime.js file. After packing,
the report works on any static hosting without local files or the File System
Access API.`);
  process.exit(0);
}

const projectDir = command || process.cwd();
pack(projectDir);
