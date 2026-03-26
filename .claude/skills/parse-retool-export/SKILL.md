---
name: parse-retool-export
description: Use when user provides a Retool app JSON export file and wants to reverse-engineer the product specification, extract API endpoints, table schema, UI components, or migrate the functionality to another framework.
---

# Parse Retool App Export

## Overview

Retool exports apps as JSON using **Transit JSON** serialization. This skill uses an automated extraction script to parse the export, then generates a product spec from the structured output.

## When to Use

- User provides a `.json` file exported from Retool
- Goal: reverse-engineer feature spec, API contracts, table columns, UI behavior
- Goal: migrate Retool app to another frontend (e.g. React/Refine)

## Workflow

### Step 1: Run the Extraction Script

Run the extraction script against the Retool export file. This replaces all manual regex parsing.

```bash
python3 scripts/extract-retool.py <path-to-retool-export.json>
```

The script outputs a single JSON object containing all extracted data:

| Field | Description |
|-------|-------------|
| `queries` | API endpoints (path, method, headers, transformer, settings) |
| `table_columns` | Retool Table column definitions (keys, labels, formats, alignment, sizes) |
| `table_settings` | Retool Table settings (pagination, sorting, search, selection) |
| `toolbar_buttons` | Retool Table toolbar buttons (labels, icons, position) |
| `pagination` | Pagination configuration |
| `html_widgets` | HTML widget content (html template, css) |
| `buttons` | Button widgets (text, style, click_action with target) |
| `variables` | State variables (id, value) |
| `containers` | Container widgets (header/footer/border visibility) |
| `text_widgets` | Text widgets (id, value/title) |
| `events` | Event handler bindings (event type, target, method) |
| `downloads` | Download handlers and notification configs |
| `data_bindings` | All `{{query.data...}}` expressions (reveals API response shape) |
| `modules` | Module names and sizes |

### Step 2: Analyze the Output

Read the JSON output and use it to understand:
1. **API contract** — from `queries` (paths, methods, headers, transformers)
2. **Response shape** — from `data_bindings` (e.g. `query1.data.list`, `query1.data[0].field`)
3. **UI layout** — from `html_widgets`, `table_columns`, `buttons`, `containers`, `text_widgets`
4. **Interactions** — from `events`, `buttons.click_action`
5. **Data transformation** — from `queries[].transformer`

### Step 3: Generate Product Spec

Write the spec to `docs/retool-specs/<feature-name>.md` using this template:

```markdown
# <Feature Name> — 產品功能規格

> 來源：Retool App 匯出檔反推，匯出時間 YYYY-MM

## 功能概述
App name, module, purpose

## API 端點
| 用途 | Method | Path |
|------|--------|------|

**資源名稱**: `<resource>`

## 查詢參數
| 參數 | 來源 | 說明 |

## API 回應格式
(Infer from data_bindings and transformer)

## 表格欄位定義 (if Retool Table)
| 顯示順序 | 欄位 Key | 中文標籤 | 格式 | 對齊 | 小數位 | 欄寬 |

## 頁面佈局 (if HTML Widget)
Describe table structure, rowSpan, dynamic vs hardcoded

## 分頁機制
Server/client, type, page size, total source

## 工具列按鈕
| 按鈕 | 圖示 | 行為 |

## 匯出/下載功能
(If present)

## 請求 Headers
| Header | 值 |

## 互動行為
Event handlers, auto-reload, page load behavior

## 表格樣式
(If HTML Widget with custom CSS)

## 其他設定
Editable, search mode, auto-load, timeout, etc.

## 遷移注意事項
Key points for React/Refine migration
```

## Transit JSON Quick Reference

| Transit Marker | Meaning |
|---------------|---------|
| `["^1?",["k1","v1","k2","v2"]]` | Map (key-value pairs) |
| `["^A",["a","b","c"]]` | Set / ordered list |
| `["^ ","k1","v1","k2","v2"]` | Map (compact form) |
| `["~#iR",["^ ","n","name","v",[...]]]` | Named record |
| `"~m1234567890"` | Timestamp (millis) |

## Troubleshooting

If the script output is missing expected data:
- **No table_columns**: The app uses HTML Widget instead of Retool Table — check `html_widgets`
- **No queries**: Check if queries use non-REST types (e.g. SQL, GraphQL) — may need manual extraction
- **Empty transformer**: `transformerEnabled` might be `false`
- **Missing resource name**: Some exports use Transit shorthand references (`^1<`) — check raw appState manually

For edge cases, use targeted regex on the raw appState:
```bash
python3 -c "
import json
with open('export.json') as f:
    data = json.load(f)
app_state = data['page']['data']['appState']
if isinstance(app_state, list):
    app_state = ''.join(str(c) for c in app_state)
# Add custom regex here
"
```
