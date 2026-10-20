# Custom vcpkg Registry

Custom vcpkg package registry for personal libraries.

## Available Packages

* **`vulcant`**: Vulkan rendering and compute abstraction library.

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
        "vulcant"
      ]
    }
  ]
}
```

Then add `"vulcant"` to your `vcpkg.json`:

```json
{
  "dependencies": [
    "vulcant"
  ]
}
```

And in CMake:

```cmake
find_package(Vulcant CONFIG REQUIRED)
target_link_libraries(your_target PRIVATE Vulcant::Vulcant)
```
