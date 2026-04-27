#!/bin/bash
# claude-statusline-monitor: Display session metrics in Claude Code status line
# Input: JSON from stdin with session state
# Output: Formatted status line string

input=$(cat)

eval $(echo "$input" | python3 -c "
import sys, json
d = json.load(sys.stdin)
model = d.get('model', {})
if isinstance(model, dict):
    model_name = model.get('display_name', '?')
else:
    model_name = str(model)
cost = d.get('cost', {})
ctx = d.get('context_window', {})
print(f'model={repr(model_name)}')
print(f'total_cost={cost.get(\"total_cost_usd\", 0):.2f}')
print(f'total_in={ctx.get(\"total_input_tokens\", 0)}')
print(f'total_out={ctx.get(\"total_output_tokens\", 0)}')
print(f'ctx_used={ctx.get(\"used_percentage\", 0)}')
" 2>/dev/null)

# Fallbacks
model=${model:-?}
total_cost=${total_cost:-0}
total_in=${total_in:-0}
total_out=${total_out:-0}
ctx_used=${ctx_used:-0}

# Format token counts (K/M)
fmt() {
    local n=$1
    if [ "$n" -ge 1000000 ] 2>/dev/null; then
        printf "%.1fM" "$(echo "$n/1000000" | bc -l)"
    elif [ "$n" -ge 1000 ] 2>/dev/null; then
        printf "%.1fK" "$(echo "$n/1000" | bc -l)"
    else
        printf "%s" "$n"
    fi
}

tin=$(fmt "$total_in")
tout=$(fmt "$total_out")

# Color output
printf "\e[0;34m%s\e[m" "$model"
printf " | \e[0;32m↑%s ↓%s\e[m" "$tin" "$tout"
printf " | \e[0;33mctx:%s%%\e[m" "$ctx_used"
printf " | \e[0;36m\$%s\e[m" "$total_cost"
