#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
scan_hive.py
Parcourt le repo Dart/Flutter pour :
 - trouver les noms de Hive.box/openBox/openLazyBox(...)
 - trouver les constantes String susceptibles d'être des noms de box
 - trouver les Hive.registerAdapter(...) et les classes TypeAdapter avec leur typeId
 - trouver les @HiveType(typeId: N) sur les classes modèles

Résultats :
 - docs/hive_inventory.md (rapport lisible)
 - docs/hive_inventory.json (structure exploitable)

Usage:
  python3 scripts/scan_hive.py
  python3 scripts/scan_hive.py -o docs/hive_inventory.md -j docs/hive_inventory.json
"""

import re
import json
import argparse
from pathlib import Path
from collections import defaultdict

BOX_CALL_RE = re.compile(
    r"Hive\.(?:openBox|box|openLazyBox)\s*(?:<[^>]+>)?\s*\(\s*(['\"])([^'\"]+)\1\s*\)",
    re.MULTILINE
)
BOX_CALL_VAR_RE = re.compile(
    r"Hive\.(?:openBox|box|openLazyBox)\s*(?:<[^>]+>)?\s*\(\s*([A-Za-z_][A-Za-z0-9_]*)\s*\)",
    re.MULTILINE
)
CONST_STR_RE = re.compile(
    r"(?:const|final)\s+String\s+([A-Za-z_][A-Za-z0-9_]*)\s*=\s*['\"]([^'\"]+)['\"]",
    re.MULTILINE
)
REGISTER_ADAPTER_RE = re.compile(
    r"Hive\.registerAdapter\s*\(\s*([A-Za-z_][A-Za-z0-9_]*)\s*\(",
    re.MULTILINE
)
CLASS_ADAPTER_RE = re.compile(
    r"class\s+([A-Za-z_][A-Za-z0-9_]*)\s+extends\s+TypeAdapter(?:<([^>]+)>)?",
    re.MULTILINE
)
TYPEID_PATTERNS = [
    re.compile(r"@override\s+final\s+int\s+typeId\s*=\s*(\d+)\s*;", re.MULTILINE),
    re.compile(r"@override\s+int\s+get\s+typeId\s*=>\s*(\d+)\s*;", re.MULTILINE),
    re.compile(r"final\s+int\s+typeId\s*=\s*(\d+)\s*;", re.MULTILINE),
    re.compile(r"int\s+get\s+typeId\s*=>\s*(\d+)\s*;", re.MULTILINE),
]
HIVETYPE_RE = re.compile(
    r"@HiveType\s*\(\s*typeId\s*:\s*(\d+)\s*\)\s*(?:class|abstract\s+class)\s+([A-Za-z_][A-Za-z0-9_]*)",
    re.MULTILINE
)

def find_line_of_pos(text, pos):
    return text[:pos].count("\n") + 1

def scan_repo(root: Path):
    boxes = defaultdict(list)            # box_name -> list of (file, line)
    box_vars = defaultdict(list)        # varName -> list of (file, line)
    const_strings = defaultdict(list)   # constName -> list of (value, file, line)
    adapters_registered = defaultdict(list)  # adapterClass -> list of (file, line, snippet)
    adapters_defined = {}               # adapterClass -> {file, model, typeId or None, line}
    hive_types = []                     # list of {modelClass, typeId, file, line}

    dart_files = list(root.rglob("*.dart"))

    for f in dart_files:
        try:
            text = f.read_text(encoding="utf-8")
        except Exception:
            # try latin-1 fallback
            text = f.read_text(encoding="latin-1")
        # box literal calls
        for m in BOX_CALL_RE.finditer(text):
            box_name = m.group(2)
            line = find_line_of_pos(text, m.start())
            boxes[box_name].append({"file": str(f), "line": line})

        # box variable calls (openBox(VAR))
        for m in BOX_CALL_VAR_RE.finditer(text):
            # ensure it's not a quoted match (the previous regex already captured quoted)
            var = m.group(1)
            line = find_line_of_pos(text, m.start())
            char_after_paren = text[m.start():m.start()+20]
            if "'" in char_after_paren or '"' in char_after_paren:
                continue
            box_vars[var].append({"file": str(f), "line": line})

        # const/final strings
        for m in CONST_STR_RE.finditer(text):
            name = m.group(1)
            val = m.group(2)
            line = find_line_of_pos(text, m.start())
            const_strings[name].append({"value": val, "file": str(f), "line": line})

        # registerAdapter
        for m in REGISTER_ADAPTER_RE.finditer(text):
            adapter = m.group(1)
            line = find_line_of_pos(text, m.start())
            snippet = text[m.start():m.start()+120].split("\n")[0]
            adapters_registered[adapter].append({"file": str(f), "line": line, "snippet": snippet})

        # adapter class definitions
        for m in CLASS_ADAPTER_RE.finditer(text):
            adapter_class = m.group(1)
            model = m.group(2) if m.group(2) else None
            cls_pos = m.start()
            line = find_line_of_pos(text, cls_pos)
            snippet_region = text[cls_pos:cls_pos+8000]
            found_typeid = None
            for pat in TYPEID_PATTERNS:
                mm = pat.search(snippet_region)
                if mm:
                    found_typeid = int(mm.group(1))
                    break
            adapters_defined[adapter_class] = {
                "file": str(f),
                "line": line,
                "model": model,
                "typeId": found_typeid,
            }

        # HiveType annotations (models)
        for m in HIVETYPE_RE.finditer(text):
            type_id = int(m.group(1))
            model = m.group(2)
            line = find_line_of_pos(text, m.start())
            hive_types.append({"model": model, "typeId": type_id, "file": str(f), "line": line})

    adapters = {}
    all_adapter_names = set(list(adapters_defined.keys()) + list(adapters_registered.keys()))
    for name in sorted(all_adapter_names):
        defined = adapters_defined.get(name)
        registered = adapters_registered.get(name, [])
        adapters[name] = {
            "defined": defined,
            "registered": registered
        }

    result = {
        "boxes": {k: v for k, v in sorted(boxes.items())},
        "box_vars": {k: v for k, v in sorted(box_vars.items())},
        "const_strings": {k: v for k, v in sorted(const_strings.items())},
        "adapters": adapters,
        "hive_types": hive_types,
        "scanned_files_count": len(dart_files),
    }
    return result

def render_markdown(report, md_path: Path):
    lines = []
    lines.append("# Inventaire Hive - PermaCalendar V2\n")
    lines.append("Généré automatiquement.\n")
    lines.append(f"- Fichiers Dart scannés : **{report.get('scanned_files_count',0)}**\n")

    lines.append("## Boxes détectées (littérales)\n")
    if report["boxes"]:
        for box, occ in report["boxes"].items():
            lines.append(f"### `{box}` ({len(occ)} occurrence(s))")
            for o in occ:
                lines.append(f"- `{o['file']}` : ligne {o['line']}")
            lines.append("")
    else:
        lines.append("Aucune box littérale trouvée via `Hive.openBox('name')` ou `Hive.box('name')`.\n")

    lines.append("## Boxes passées par variable (nom dynamique)\n")
    if report["box_vars"]:
        for var, occ in report["box_vars"].items():
            lines.append(f"- Variable `{var}` :")
            for o in occ:
                lines.append(f"  - `{o['file']}` : ligne {o['line']}")
    else:
        lines.append("Aucune utilisation évidente de variable passée à `Hive.openBox()`.\n")

    lines.append("\n## Constantes String (candidates noms de box)\n")
    if report["const_strings"]:
        for name, occ in report["const_strings"].items():
            lines.append(f"- `{name}` :")
            for o in occ:
                lines.append(f"  - `{o['file']}` : ligne {o['line']} => valeur `{o['value']}`")
    else:
        lines.append("Aucune constante string trouvée.\n")

    lines.append("\n## TypeAdapters et enregistrements\n")
    if report["adapters"]:
        for adapter, info in report["adapters"].items():
            lines.append(f"### Adapter `{adapter}`")
            if info["defined"]:
                d = info["defined"]
                lines.append(f"- Défini dans `{d['file']}` : ligne {d['line']}")
                if d.get("model"):
                    lines.append(f"- Model générique : `{d.get('model')}`")
                lines.append(f"- typeId : `{d.get('typeId')}`")
            else:
                lines.append("- **Non défini** dans le code scanné.")
            if info["registered"]:
                lines.append("- Enregistrements (registerAdapter):")
                for r in info["registered"]:
                    lines.append(f"  - `{r['file']}` : ligne {r['line']} → `{r['snippet']}`")
            else:
                lines.append("- Aucun enregistrement `Hive.registerAdapter(...)` trouvé.")
            lines.append("")
    else:
        lines.append("Aucun TypeAdapter trouvé.\n")

    lines.append("\n## @HiveType (modèles annotés)\n")
    if report["hive_types"]:
        for h in report["hive_types"]:
            lines.append(f"- `{h['model']}` — typeId **{h['typeId']}** — `{h['file']}` (ligne {h['line']})")
    else:
        lines.append("Aucune annotation @HiveType trouvée.\n")

    lines.append("\n---\n")
    lines.append("**Notes** :\n")
    lines.append("- Si un nom de box est passé via une variable ou construit dynamiquement, le script ne peut pas résoudre sa valeur statiquement sauf s'il est défini comme constante String.\n")
    lines.append("- Les `typeId` sont définis dans les classes `TypeAdapter` (ou via `@HiveType(typeId: N)` sur les modèles). Vérifie que les `typeId` ne sont pas dupliqués.\n")

    md_path.parent.mkdir(parents=True, exist_ok=True)
    md_path.write_text("\n".join(lines), encoding="utf-8")
    print(f"Wrote markdown report to: {md_path}")

def main():
    parser = argparse.ArgumentParser(description="Scan repository for Hive boxes and TypeAdapters")
    parser.add_argument("--root", "-r", default=".", help="Root of repository (default current dir)")
    parser.add_argument("--out", "-o", default="docs/hive_inventory.md", help="Markdown output path")
    parser.add_argument("--json", "-j", default="docs/hive_inventory.json", help="JSON output path")
    args = parser.parse_args()

    root = Path(args.root).resolve()
    print(f"Scanning Dart files in {root} ...")
    report = scan_repo(root)

    md_path = Path(args.out)
    json_path = Path(args.json)

    render_markdown(report, md_path)
    json_path.parent.mkdir(parents=True, exist_ok=True)
    json_path.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"Wrote JSON report to: {json_path}")
    print("Scan terminé.")

if __name__ == "__main__":
    main()
