# Custom vcpkg Registry

Custom vcpkg package registry for personal libraries.

## Available Packages

* **`vulcant`**: Vulkan rendering and compute abstraction library.
* **`polyglot`**: Single API for Python and Lua scripting.
* **`cadacomb`**: Spatial data structures and CAD engine with optional rendering helper.
* **`smlib`**: NVIDIA SMLib solid modeling kernel with smlibpy C++ extensions.

## Usage in your project

Add a `vcpkg-configuration.json` next to your project's `vcpkg.json`:

```json
{
  "default-registry": {
    "kind": "builtin",
    "baseline": "b0698a9c2dd8fbf980bb880574801badedf16c86"
  },
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/Liech/vcpkg-registry",
      "baseline": "<commit-sha-from-this-repo>",
      "packages": [
        "vulcant",
        "polyglot",
        "cadacomb",
        "smlib"
      ]
    }
  ]
}
```

### Adding CADacomb as a dependency

**Spatial / CAD only (no Vulkan/rendering dependency):**

```json
{
  "dependencies": [
    "cadacomb"
  ]
}
```

```cmake
find_package(CADacomb CONFIG REQUIRED)
target_link_libraries(your_target PRIVATE CADacomb::CADacomb)
```

**With Rendering Helper (`CADacombRender` + `vulcant`):**

```json
{
  "dependencies": [
    {
      "name": "cadacomb",
      "features": ["render"]
    }
  ]
}
```

```cmake
find_package(CADacomb CONFIG REQUIRED COMPONENTS Render)
target_link_libraries(your_target PRIVATE CADacomb::CADacomb CADacomb::CADacombRender)
```
