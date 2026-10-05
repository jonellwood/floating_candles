"""Refresh ContentDB's description after editing README.md. Python standard library."""
import json
from pathlib import Path
root = Path(__file__).resolve().parents[1]
path = root / '.cdb.json'
data = json.loads(path.read_text())
data['long_description'] = (root / 'README.md').read_text()
path.write_text(json.dumps(data, indent=2) + '\n')
print('Updated .cdb.json long_description from README.md')
