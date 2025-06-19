# PasteMate

**PasteMate** is a lightweight AutoHotkey-powered utility that turns your hotkeys into powerful text and link inserters.
It's perfect for quickly pasting common phrases, opening links, or triggering template-based actions — all from a simple config file.

---

## How It Works

- Press `Alt + 0–9` or click your extra mouse buttons (XButton1/XButton2)
- PasteMate looks for a matching entry in `config.txt`
- If it finds one, it:
  - Inserts custom text
  - Opens a link
  - Or both — depending on how the entry is set up

If no match is found, it sends the original key as usual.

---

##  File Contents

- `PasteMate.exe` — the tool, built with AutoHotkey v2
- `config.txt` — your customizable trigger list

---

##  config.txt Format

Each block is enclosed in `[key] ... [/key]`, where `key` can be `0–9`, `10` (XButton1), or `11` (XButton2):

```txt
[1]
Hello, this is a test!
[/1]

[2]
[[TODAY]] Follow up with client.
[/2]

[3]
[[LINK]] https://example.com
[/3]

Available Placeholders
[[TODAY]] → Replaced with current date (MM/DD/YYYY)

[[CLIPBOARD]] → Inserts the text currently in your clipboard

[[NEWWIN]] → Opens a new window (Ctrl+N) before pasting

[[LINK]] → Interprets the line as a URL and opens it instead of pasting
