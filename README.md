# Nytro

Nytro is an experimental float-native compute language and register-based VM for signal processing, written entirely in Dart.

## VM Design

The virtual machine's design was intentionally constrained to explore interesting compiler and assembly problems.

- The machine is float-native, meaning instead of everything being bytes, everything is floats.
- There is a limit of 16 registers which can each hold 16 floats.
- Memory is a map where the key is an index and the value is a variable length float list.

Everything must be designed around these constraints as immutable truths of the machine's state.

## Getting Started

The current version of Nytro exposes a simple shader-style workflow using `shader.nyasm` and `input.png`.

`shader.nyasm` is executed as a pixel-wise image filter over `input.png`, producing `output.png`.

### Generate Source Files

Nytro uses generated instruction metadata which is not committed to the repository.

Before running the project, generate the required files with:

```bash
dart run tool/gen_instr_set.dart
```

### Run the Project

Place:

- an image named `input.png`
- and a shader named `shader.nyasm`

in the project root, then run:

```bash
dart run
```

After execution, the filtered image will be written to:

```txt
output.png
```

### Shader Memory Bindings

The shader entry point currently uses the following memory bindings:

- `m0` — `vec4` input color
- `m1` — `vec2` normalized UV coordinates
- `m2` — `vec4` output color

### Example Shader

```asm
LOAD m0 4 r0
ADD_FLOAT r0:0 r0:1 r1
ADD_FLOAT r0:2 r1 r1
DIV_FLOAT r1 3f r1
WRITE r1 r1 r1 1f r0
STORE r0 4 m2
```
