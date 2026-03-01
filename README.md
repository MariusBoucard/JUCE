# JUCE CMake Plugin Builder

A CMake-based build system for JUCE audio plugins. This project provides a unified structure to build multiple plugins as either **Standalone** applications or **VST3** plugins, on both **Windows** and **Linux**.

---

## Overview

Plugins are organized within the `projects/` folder. Each plugin is a separate CMake target that can be selected and configured through CMake cache variables, making it straightforward to build only the plugin you need, in the format you want.

---

## Prerequisites

- [CMake](https://cmake.org/) >= 3.22
- A C++17-compatible compiler (MSVC on Windows, GCC/Clang on Linux)
- [JUCE](https://juce.com/) (fetched automatically or provided locally, depending on your setup)
- VST3 SDK (bundled with JUCE)

---

## Project Structure

```
.
├── CMakeLists.txt          # Root CMake configuration
├── projects/
│   ├── PluginA/            # Source for Plugin A
│   ├── PluginB/            # Source for Plugin B
│   └── ...
└── README.md
```

---

## Building

### 1. Configure

From the repository root, run CMake and specify which plugin to build using the `TARGET_PLUGIN` cache variable:

```bash
cmake -B build -DTARGET_PLUGIN=PluginA
```

### 2. Select the Plugin Format

Use the `PLUGIN_FORMAT` cache variable to choose between `Standalone` and `VST3`:

```bash
cmake -B build -DTARGET_PLUGIN=PluginA -DPLUGIN_FORMAT=VST3
```

Available values:
- `Standalone` — builds the plugin as a self-contained desktop application
- `VST3` — builds the plugin as a VST3 binary loadable in any compatible DAW

### 3. Build

```bash
cmake --build build --config Release
```

---

## Platform Support

| Platform | Standalone | VST3 |
|----------|-----------|------|
| Windows  | ✅        | ✅   |
| Linux    | ✅        | ✅   |

---

## Available Plugins

| Plugin Name | Description |
|-------------|-------------|
| PluginA     | ...         |
| PluginB     | ...         |

> Update this table as you add plugins to the `projects/` folder.

---

## Notes

- All CMake cache variables can also be set via a GUI tool like `cmake-gui` or `ccmake`.
- Output binaries are placed in the `build/` directory under their respective target folders.
- On Linux, make sure you have the required JUCE dependencies installed (ALSA, FreeType, etc.). Refer to the [JUCE Linux dependencies guide](https://github.com/juce-framework/JUCE/blob/master/docs/Linux%20Dependencies.md) for details.

---

## License

*Add your license here.*