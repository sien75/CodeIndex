import { readdirSync, statSync, mkdirSync, writeFileSync, existsSync } from 'node:fs';
import { join, relative } from 'node:path';
import { fileHash, countLines } from './utils.mjs';

const IGNORE_DIRS = new Set(['node_modules', '.git', '.codeindex', '.gagcode', 'dist', '.next', '.cache']);
const IGNORE_EXTENSIONS = new Set(['.png', '.jpg', '.jpeg', '.gif', '.ico', '.woff', '.woff2', '.ttf', '.eot', '.mp3', '.mp4', '.zip', '.tar', '.gz']);

function walk(dir, root, files = []) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (entry.name.startsWith('.') && entry.isDirectory()) continue;
    if (IGNORE_DIRS.has(entry.name)) continue;

    const full = join(dir, entry.name);

    if (entry.isDirectory()) {
      walk(full, root, files);
    } else if (entry.isFile()) {
      const ext = entry.name.slice(entry.name.lastIndexOf('.'));
      if (IGNORE_EXTENSIONS.has(ext)) continue;
      files.push(relative(root, full));
    }
  }
  return files;
}

export function init(targetDir) {
  const resolved = targetDir || process.cwd();
  const codeindexDir = join(resolved, '.codeindex');

  if (!existsSync(codeindexDir)) mkdirSync(codeindexDir, { recursive: true });

  const filePaths = walk(resolved, resolved);
  const files = filePaths.map(rel => {
    const full = join(resolved, rel);
    return {
      path: rel,
      lines: countLines(full),
      hash: fileHash(full),
    };
  });

  writeFileSync(join(codeindexDir, 'files.json'), JSON.stringify({ files }, null, 2) + '\n');
  writeFileSync(join(codeindexDir, 'coverage.json'), JSON.stringify({ marks: [] }, null, 2) + '\n');

  console.log(`Initialized .codeindex/ with ${files.length} files`);
  console.log(`Total lines: ${files.reduce((s, f) => s + f.lines, 0)}`);
}
