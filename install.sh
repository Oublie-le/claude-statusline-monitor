#!/bin/bash
# Install claude-statusline-monitor
# Adds statusLine config to ~/.claude/settings.json

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SETTINGS="$HOME/.claude/settings.json"

if [ ! -f "$SETTINGS" ]; then
    echo '{}' > "$SETTINGS"
fi

# Use python3 to merge statusLine config
python3 -c "
import json, sys

settings_path = '$SETTINGS'
script_path = '$SCRIPT_DIR/statusline.sh'

with open(settings_path) as f:
    settings = json.load(f)

settings['statusLine'] = {
    'type': 'command',
    'command': f'bash {script_path}'
}

with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)

print('✅ statusLine 已配置')
print(f'   脚本路径: {script_path}')
print('   重启 Claude Code 生效')
"
