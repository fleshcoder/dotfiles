#!/usr/bin/env python3
"""
Retool Export Extractor
Extracts all structured data from a Retool app JSON export file.
Outputs a comprehensive summary for AI-based product spec generation.

Usage: python3 extract-retool.py <retool-export.json>
"""

import json
import re
import sys


def reconstruct_app_state(data):
    """Extract and reconstruct appState from export data."""
    app_state = data["page"]["data"]["appState"]
    if isinstance(app_state, list):
        app_state = "".join(str(c) for c in app_state)
    return app_state


def extract_transit_map(app_state, key):
    """Extract a Transit map ['^ ','k1','v1',...] or ['^1?',['k1','v1',...]] by key."""
    # Pattern 1: ["^1?",["k1","v1","k2","v2",...]]
    pattern1 = re.escape(f'"{key}"') + r',\["\^1\?",\[([^\]]+)\]\]'
    m = re.search(pattern1, app_state)
    if m:
        items = re.findall(r'"([^"]*)"', m.group(1))
        return dict(zip(items[0::2], items[1::2]))

    # Pattern 2: ["^A",["v1","v2",...]] (ordered list)
    pattern2 = re.escape(f'"{key}"') + r',\["\^A",\[([^\]]+)\]\]'
    m = re.search(pattern2, app_state)
    if m:
        return re.findall(r'"([^"]*)"', m.group(1))

    return None


def extract_string_field(app_state, key):
    """Extract a simple string value for a key."""
    pattern = re.escape(f'"{key}"') + r',"([^"]*)"'
    m = re.search(pattern, app_state)
    return m.group(1) if m else None


def extract_bool_field(app_state, key):
    """Extract a boolean value for a key."""
    pattern = re.escape(f'"{key}"') + r',(true|false)'
    m = re.search(pattern, app_state)
    return m.group(1) if m else None


def extract_components(app_state):
    """Extract all component definitions with their types and properties."""
    components = []
    # Find all plugin definitions: "id","<name>",... "subtype","<type>"
    # The pattern in Transit: "id","xxx","uuid",...,"subtype","WidgetType"
    for m in re.finditer(
        r'"id","([^"]+)","uuid","[^"]*","[^"]*",null,"[^"]*","([^"]+)","[^"]*","([^"]*)"',
        app_state,
    ):
        comp = {
            "id": m.group(1),
            "category": m.group(2),  # widget, datasource, state
            "type": m.group(3),
        }
        components.append(comp)

    # Fallback: broader pattern
    if not components:
        ids = []
        for m in re.finditer(r'"id","([^"$][^"]*)"', app_state):
            cid = m.group(1)
            if cid not in ids and not cid.startswith(("~", "^", "fea", "bef", "b68", "105")):
                ids.append(cid)

        for cid in ids:
            idx = app_state.find(f'"id","{cid}"')
            if idx < 0:
                continue
            chunk = app_state[idx : idx + 500]
            subtype_m = re.search(r'"(\w+Widget\w*|\w+Query\w*|State|Frame|ContainerWidget2|TextWidget2|ButtonWidget2|HTMLWidget)"', chunk)
            comp = {
                "id": cid,
                "type": subtype_m.group(1) if subtype_m else "unknown",
            }
            components.append(comp)

    return components


def extract_queries(app_state):
    """Extract all API query definitions."""
    queries = []

    # Find all RESTQuery blocks
    # Each query has: id, query (path), type (method), headers, transformer, etc.
    for m in re.finditer(r'"id","([^"]+)"[^}]*?"RESTQuery"', app_state):
        qid = m.group(1)
        # Get the chunk around this query
        start = m.start()
        # Find a reasonable end boundary
        chunk = app_state[start : start + 5000]

        query_info = {"id": qid}

        # Extract path
        path_m = re.search(r'"query","(/[^"]+)"', chunk)
        if path_m:
            query_info["path"] = path_m.group(1)

        # Extract HTTP method
        method_m = re.search(r'"type","(GET|POST|PUT|PATCH|DELETE)"', chunk)
        if method_m:
            query_info["method"] = method_m.group(1)

        # Extract resource name
        res_m = re.search(r'"resourceDisplayName","([^"]+)"', chunk)
        if not res_m:
            res_m = re.search(r'"resourceName","([^"]+)"', chunk)
        if res_m and res_m.group(1) != "null":
            query_info["resource"] = res_m.group(1)

        # Extract headers
        headers_m = re.search(r'"headers","(\[.*?\])"', chunk)
        if headers_m:
            try:
                decoded = headers_m.group(1).replace('\\"', '"')
                parsed = json.loads(decoded)
                query_info["headers"] = [
                    h for h in parsed if h.get("key")
                ]
            except (json.JSONDecodeError, TypeError):
                query_info["headers_raw"] = headers_m.group(1)[:200]

        # Extract transformer
        trans_idx = chunk.find('"transformer","')
        if trans_idx >= 0:
            t_start = trans_idx + len('"transformer","')
            i = t_start
            while i < len(chunk):
                if chunk[i] == "\\" and i + 1 < len(chunk):
                    i += 2
                    continue
                if chunk[i] == '"':
                    break
                i += 1
            transformer = chunk[t_start:i]
            transformer = transformer.replace("\\n", "\n").replace("\\t", "\t").replace('\\"', '"')
            if transformer.strip():
                query_info["transformer"] = transformer

        # Extract transformer enabled
        te_m = re.search(r'"transformerEnabled",(true|false)', chunk)
        if te_m:
            query_info["transformer_enabled"] = te_m.group(1)

        # Extract runWhenModelUpdates
        rwmu = re.search(r'"runWhenModelUpdates",(true|false)', chunk)
        if rwmu:
            query_info["run_when_model_updates"] = rwmu.group(1)

        # Extract runWhenPageLoads
        rwpl = re.search(r'"runWhenPageLoads",(true|false)', chunk)
        if rwpl:
            query_info["run_when_page_loads"] = rwpl.group(1)

        # Extract queryTimeout
        qt = re.search(r'"queryTimeout","([^"]*)"', chunk)
        if qt and qt.group(1):
            query_info["timeout"] = qt.group(1)

        # Extract success/failure toasters
        sf = re.search(r'"showFailureToaster",(true|false)', chunk)
        if sf:
            query_info["show_failure_toaster"] = sf.group(1)
        ss = re.search(r'"showSuccessToaster",(true|false)', chunk)
        if ss:
            query_info["show_success_toaster"] = ss.group(1)

        # Extract body
        body_m = re.search(r'"body","([^"]+)"', chunk)
        if body_m and body_m.group(1).strip():
            body = body_m.group(1).replace("\\n", "\n").replace('\\"', '"')
            query_info["body"] = body

        # Extract queryParams from URL
        if "path" in query_info and "?" in query_info["path"]:
            params_str = query_info["path"].split("?", 1)[1]
            query_info["query_params_in_url"] = params_str

        queries.append(query_info)

    # Fallback: simpler pattern
    if not queries:
        paths = re.findall(r'"query","(/api/[^"]+)"', app_state)
        methods = re.findall(r'"type","(GET|POST|PUT|PATCH|DELETE)"', app_state)
        for i, path in enumerate(paths):
            q = {"path": path}
            if i < len(methods):
                q["method"] = methods[i]
            # Try to find headers near this query
            idx = app_state.find(f'"query","{path}"')
            if idx >= 0:
                chunk = app_state[max(0, idx - 2000) : idx + 3000]
                headers_m = re.search(r'"headers","(\[.*?\])"', chunk)
                if headers_m:
                    try:
                        decoded = headers_m.group(1).replace('\\"', '"')
                        parsed = json.loads(decoded)
                        q["headers"] = [h for h in parsed if h.get("key")]
                    except (json.JSONDecodeError, TypeError):
                        pass

                # Transformer
                trans_idx = chunk.find('"transformer","')
                if trans_idx >= 0:
                    t_start = trans_idx + len('"transformer","')
                    j = t_start
                    while j < len(chunk):
                        if chunk[j] == "\\" and j + 1 < len(chunk):
                            j += 2
                            continue
                        if chunk[j] == '"':
                            break
                        j += 1
                    transformer = chunk[t_start:j].replace("\\n", "\n").replace("\\t", "\t").replace('\\"', '"')
                    if transformer.strip():
                        q["transformer"] = transformer

                # Resource
                res_m = re.search(r'"resourceDisplayName","([^"]+)"', chunk)
                if not res_m:
                    res_m = re.search(r'"(?:\^1<|resourceName)","([^"]+)"', chunk)
                if res_m and res_m.group(1) not in ("null", ""):
                    q["resource"] = res_m.group(1)

                # Booleans
                for field in ["runWhenModelUpdates", "runWhenPageLoads", "showFailureToaster", "showSuccessToaster"]:
                    fm = re.search(f'"{field}",(true|false)', chunk)
                    if fm:
                        q[field] = fm.group(1)

            queries.append(q)

    return queries


def extract_table_columns(app_state):
    """Extract Retool Table widget column definitions."""
    result = {}

    col_keys = extract_transit_map(app_state, "_columnKey")
    col_labels = extract_transit_map(app_state, "_columnLabel")
    col_formats = extract_transit_map(app_state, "_columnFormat")
    col_align = extract_transit_map(app_state, "_columnAlignment")
    col_ids = extract_transit_map(app_state, "_columnIds")
    col_size = extract_transit_map(app_state, "_columnSize")

    if col_keys:
        result["keys"] = col_keys
    if col_labels:
        result["labels"] = col_labels
    if col_formats:
        result["formats"] = col_formats
    if col_align:
        result["alignment"] = col_align
    if col_ids:
        result["order"] = col_ids
    if col_size:
        result["sizes"] = col_size

    # Extract format options (decimal places, etc.)
    fmt_opts = re.search(r'"_columnFormatOptions",\["\^1\?",\[([^\]]+)\]\]', app_state)
    if fmt_opts:
        result["format_options_raw"] = fmt_opts.group(1)[:500]

    return result if result else None


def extract_html_widgets(app_state):
    """Extract HTML widget content."""
    widgets = []

    for m in re.finditer(r'"HTMLWidget"', app_state):
        start = m.start()
        # Search backwards for the component id
        chunk_before = app_state[max(0, start - 500) : start]
        id_m = re.search(r'"id","([^"]+)"', chunk_before)

        # Search forwards for html content
        chunk_after = app_state[start : start + 10000]

        widget = {}
        if id_m:
            widget["id"] = id_m.group(1)

        # Extract HTML
        html_idx = chunk_after.find('"html","')
        if html_idx >= 0:
            h_start = html_idx + len('"html","')
            i = h_start
            while i < len(chunk_after):
                if chunk_after[i] == "\\" and i + 1 < len(chunk_after):
                    i += 2
                    continue
                if chunk_after[i] == '"':
                    break
                i += 1
            html = chunk_after[h_start:i].replace("\\n", "\n").replace("\\t", "\t").replace('\\"', '"')
            widget["html"] = html

        # Extract CSS
        css_idx = chunk_after.find('"css","')
        if css_idx >= 0:
            c_start = css_idx + len('"css","')
            i = c_start
            while i < len(chunk_after):
                if chunk_after[i] == "\\" and i + 1 < len(chunk_after):
                    i += 2
                    continue
                if chunk_after[i] == '"':
                    break
                i += 1
            css = chunk_after[c_start:i].replace("\\n", "\n").replace("\\t", "\t")
            widget["css"] = css

        if widget:
            widgets.append(widget)

    return widgets


def extract_buttons(app_state):
    """Extract button widgets."""
    buttons = []

    for m in re.finditer(r'"ButtonWidget2"', app_state):
        start = m.start()
        chunk_before = app_state[max(0, start - 500) : start]
        chunk_after = app_state[start : start + 2000]
        combined = chunk_before + chunk_after

        button = {}

        # ID
        id_m = re.search(r'"id","([^"]+)"', chunk_before)
        if id_m:
            button["id"] = id_m.group(1)

        # Text/label
        text_m = re.search(r'"text","([^"]+)"', chunk_after)
        if text_m:
            button["text"] = text_m.group(1)

        # Style
        style_m = re.search(r'"styleVariant","([^"]+)"', chunk_after)
        if style_m:
            button["style"] = style_m.group(1)

        # Events - click handler
        # Find events block and extract pluginId for click event
        events_idx = chunk_after.find('"events"')
        if events_idx >= 0:
            # Get a reasonable chunk containing the events definition
            ev_chunk = chunk_after[events_idx : events_idx + 500]
            if '"event","click"' in ev_chunk:
                plugin_m = re.search(r'"pluginId","([^"]+)"', ev_chunk)
                type_m = re.search(r'"type","(datasource|script|widget)"', ev_chunk)
                if plugin_m:
                    button["click_action"] = {
                        "type": type_m.group(1) if type_m else "unknown",
                        "target": plugin_m.group(1),
                    }

        # Disabled
        disabled_m = re.search(r'"disabled",(true|false)', chunk_after)
        if disabled_m:
            button["disabled"] = disabled_m.group(1)

        # Hidden
        hidden_m = re.search(r'"hidden",(true|false)', chunk_after)
        if hidden_m:
            button["hidden"] = hidden_m.group(1)

        if button:
            buttons.append(button)

    return buttons


def extract_variables(app_state):
    """Extract state variables."""
    variables = []

    for m in re.finditer(r'"id","(variable\d+)"', app_state):
        vid = m.group(1)
        start = m.start()
        chunk = app_state[start : start + 2000]

        var = {"id": vid}

        # Extract value
        val_idx = chunk.find('"value","')
        if val_idx >= 0:
            v_start = val_idx + len('"value","')
            i = v_start
            while i < len(chunk):
                if chunk[i] == "\\" and i + 1 < len(chunk):
                    i += 2
                    continue
                if chunk[i] == '"':
                    break
                i += 1
            value = chunk[v_start:i].replace("\\n", "\n").replace("\\t", "\t").replace('\\"', '"')
            var["value"] = value

        variables.append(var)

    return variables


def extract_containers(app_state):
    """Extract container widgets with their titles."""
    containers = []

    for m in re.finditer(r'"ContainerWidget2"', app_state):
        start = m.start()
        chunk_before = app_state[max(0, start - 500) : start]
        chunk_after = app_state[start : start + 2000]

        container = {}

        id_m = re.search(r'"id","([^"]+)"', chunk_before)
        if id_m:
            container["id"] = id_m.group(1)

        # showHeader, showFooter
        for field in ["showHeader", "showFooter", "showBorder"]:
            fm = re.search(f'"{field}",(true|false)', chunk_after)
            if fm:
                container[field] = fm.group(1)

        containers.append(container)

    return containers


def extract_text_widgets(app_state):
    """Extract text widget values."""
    texts = []

    for m in re.finditer(r'"TextWidget2"', app_state):
        start = m.start()
        chunk_before = app_state[max(0, start - 500) : start]
        chunk_after = app_state[start : start + 1000]

        text = {}

        id_m = re.search(r'"id","([^"]+)"', chunk_before)
        if id_m:
            text["id"] = id_m.group(1)

        val_m = re.search(r'"value","([^"]*)"', chunk_after)
        if val_m:
            text["value"] = val_m.group(1).replace("\\n", "\n")

        if text:
            texts.append(text)

    return texts


def extract_events(app_state):
    """Extract all event handler bindings."""
    events = []

    # Pattern: "event","<type>","type","<handler>","id","<id>","waitMs","<ms>"
    for m in re.finditer(
        r'"event","([^"]+)","type","([^"]+)","id","([^"]+)","waitMs","([^"]*)"',
        app_state,
    ):
        event = {
            "event": m.group(1),
            "handler_type": m.group(2),
            "handler_id": m.group(3),
            "wait_ms": m.group(4),
        }

        # Look for pluginId (target) - may appear before or after the event field
        # Check before (within the same Transit map block)
        before = app_state[max(0, m.start() - 300) : m.start()]
        target_m = re.search(r'"pluginId","([^"]+)"', before)
        if not target_m:
            # Check after
            after = app_state[m.end() : m.end() + 200]
            target_m = re.search(r'"pluginId","([^"]+)"', after)
        if target_m:
            event["target"] = target_m.group(1)

        # Look for method (trigger, control, etc.)
        method_m = re.search(r'"method","([^"]+)"', before)
        if method_m:
            event["method"] = method_m.group(1)

        events.append(event)

    return events


def extract_pagination(app_state):
    """Extract pagination configuration."""
    pagination = {}

    server_pag = '"_serverPaginated",true' in app_state
    pagination["server_paginated"] = server_pag

    pag_type = re.search(r'"_serverPaginationType","([^"]+)"', app_state)
    if pag_type:
        pagination["type"] = pag_type.group(1)

    total_expr = re.search(r'"_limitOffsetRowCount","([^"]+)"', app_state)
    if total_expr:
        pagination["total_expression"] = total_expr.group(1)

    page_size = re.search(r'page_size=(\d+)', app_state)
    if page_size:
        pagination["page_size"] = page_size.group(1)

    return pagination if any(v for v in pagination.values()) else None


def extract_table_settings(app_state):
    """Extract Retool Table widget settings."""
    settings = {}

    for field in [
        "_serverPaginated",
        "_showPaginationControls",
        "_allowSorting",
        "_allowSearch",
        "_allowDownload",
        "_searchMode",
        "_primaryKeyColumn",
        "_showNoRowsMessage",
        "_noRowsMessage",
        "_rowSelectionMode",
        "_serverSearch",
    ]:
        val = extract_string_field(app_state, field)
        if val:
            settings[field] = val
        else:
            bool_val = extract_bool_field(app_state, field)
            if bool_val:
                settings[field] = bool_val

    return settings if settings else None


def extract_toolbar_buttons(app_state):
    """Extract toolbar button definitions from Retool Table."""
    toolbar = {}

    labels = extract_transit_map(app_state, "_toolbarButtonLabel")
    if labels:
        toolbar["labels"] = labels

    icons = extract_transit_map(app_state, "_toolbarButtonIcon")
    if icons:
        toolbar["icons"] = icons

    pos = extract_string_field(app_state, "_toolbarPosition")
    if pos:
        toolbar["position"] = pos

    return toolbar if toolbar else None


def extract_download_handlers(app_state):
    """Extract download/export related code."""
    downloads = []

    for m in re.finditer(r'utils\.downloadFile\([^)]+\)', app_state):
        downloads.append(m.group())

    # Also check for notification handlers related to downloads
    notifications = re.findall(
        r'"notificationType","([^"]+)","title","([^"]+)","description","([^"]+)"',
        app_state,
    )

    return {
        "download_calls": downloads,
        "notifications": [
            {"type": n[0], "title": n[1], "description": n[2]}
            for n in notifications
        ],
    } if downloads or notifications else None


def extract_data_bindings(app_state):
    """Extract data binding expressions to infer API response shape."""
    bindings = set()

    for m in re.finditer(r'\{\{(query\d+\.data[^}]*)\}\}', app_state):
        bindings.add(m.group(1))

    return sorted(bindings) if bindings else None


def extract_modules(data):
    """Extract module information."""
    modules = {}
    for mod_name, mod_data in data.get("modules", {}).items():
        mod_info = {"name": mod_name}
        if "data" in mod_data:
            ms = mod_data["data"].get("appState", "")
            if isinstance(ms, list):
                ms = "".join(str(c) for c in ms)
            mod_info["appState_length"] = len(ms)
        modules[mod_name] = mod_info
    return modules


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 extract-retool.py <retool-export.json>", file=sys.stderr)
        sys.exit(1)

    filepath = sys.argv[1]

    with open(filepath, encoding="utf-8") as f:
        data = json.load(f)

    app_state = reconstruct_app_state(data)

    result = {
        "file": filepath,
        "uuid": data.get("uuid", ""),
        "appState_length": len(app_state),
        "modules": extract_modules(data),
    }

    # Extract all components
    queries = extract_queries(app_state)
    if queries:
        result["queries"] = queries

    table_columns = extract_table_columns(app_state)
    if table_columns:
        result["table_columns"] = table_columns

    table_settings = extract_table_settings(app_state)
    if table_settings:
        result["table_settings"] = table_settings

    toolbar = extract_toolbar_buttons(app_state)
    if toolbar:
        result["toolbar_buttons"] = toolbar

    pagination = extract_pagination(app_state)
    if pagination:
        result["pagination"] = pagination

    html_widgets = extract_html_widgets(app_state)
    if html_widgets:
        result["html_widgets"] = html_widgets

    buttons = extract_buttons(app_state)
    if buttons:
        result["buttons"] = buttons

    variables = extract_variables(app_state)
    if variables:
        result["variables"] = variables

    containers = extract_containers(app_state)
    if containers:
        result["containers"] = containers

    text_widgets = extract_text_widgets(app_state)
    if text_widgets:
        result["text_widgets"] = text_widgets

    events = extract_events(app_state)
    if events:
        result["events"] = events

    downloads = extract_download_handlers(app_state)
    if downloads:
        result["downloads"] = downloads

    bindings = extract_data_bindings(app_state)
    if bindings:
        result["data_bindings"] = bindings

    # Output as formatted JSON
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
