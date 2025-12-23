# fselect.yazi

A Yazi plugin that filters files by fselect. 

## Requirements

- [Yazi](https://github.com/sxyazi/yazi) file manager  
- [fselect](https://github.com/jhspetersson/fselect) Find files with SQL-like queries

## Installation

1. Clone this repo into [Yazi's plugins directory](https://yazi-rs.github.io/docs/plugins/overview)

2. Add the plugin to your Yazi keymaps (`keymap.toml`):

```toml
[[manager.prepend_keymap]]
on = [ "F" ]
run = "plugin fselect"
desc = "filter by fselect"
```

## Usage

1. In Yazi, press `F` (or your configured keybinding)
2. Enter your rules in the input box.(See [fselect docs](https://github.com/jhspetersson/fselect/blob/master/docs/usage.md))
3. Press `enter` to apply filters. And press `esc` to quit the view.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Credits
This plugin is heavily based on [modif.yazi](https://github.com/Shallow-Seek/modif.yazi). Huge thanks to the original author!