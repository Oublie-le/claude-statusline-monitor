# claude-statusline-monitor

在 Claude Code 底部状态栏实时显示会话信息：

```
Opus 4.6 (1M context) | ↑1.0M ↓14.7K | ctx:8% | $6.08
```

## 显示内容

| 字段 | 含义 |
|------|------|
| 模型名 | 当前使用的模型 |
| ↑ / ↓ | 累计输入 / 输出 tokens |
| ctx | 上下文窗口使用百分比 |
| $ | 会话累计费用 (USD) |

## 安装

### 方式一：作为插件安装

```bash
claude --plugin-dir /path/to/claude-statusline-monitor
```

### 方式二：手动安装

```bash
git clone https://github.com/yourname/claude-statusline-monitor.git
cd claude-statusline-monitor
bash install.sh
```

### 方式三：直接配置

在 `~/.claude/settings.json` 中添加：

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash /path/to/claude-statusline-monitor/statusline.sh"
  }
}
```

## 依赖

- `python3`（解析 JSON）
- `bc`（数字格式化）

## 自定义

编辑 `statusline.sh` 可自定义显示内容和颜色。可用字段见 `example-input.json`。

## License

MIT
