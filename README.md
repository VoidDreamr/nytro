# Nytro

Nytro is an experimental float-native compute language and register-based VM for signal processing, written entirely in Dart.

## VM Design

The virtual machine's design was intentionally constrained to explore interesting compiler and assembly problems.

- The machine is float-native, meaning instead of everything being bytes, everything is floats.
- There is a limit of 16 registers which can each hold 16 floats.
- Memory is a map where the key is an index and the value is a variable length float list.

Everything must be designed around these constraints as immutable truths of the machine's state.

## Assembly

#### Types

| Name       | Lanes | Description                                                                                                    |
| ---------- | ----- | -------------------------------------------------------------------------------------------------------------- |
| `register` | N/A   | A register slot, with an optional lane offset (default: 0). This is written `r<SLOT>[:<OFFSET>]`.              |
| `memory`   | N/A   | A memory resource index, with an optional starting offset (default: 0). This is written `m<INDEX>[:<OFFSET>]`. |
| `int`      | N/A   | An integer value used for counts, slots, indexes, and offsets. Integer values are not stored in the VM.        |
| `float`    | `1`   | A single float from a `register` or an immediate constant written as `<VALUE>f`.                               |
| `vec2`     | `2`   | A 2D vector from a `register`.                                                                                 |
| `vec3`     | `3`   | A 3D vector from a `register`.                                                                                 |
| `vec4`     | `4`   | A 4D vector from a `register`.                                                                                 |
| `tex2`     | N/A   | A 2D texture resource referenced from `memory`. Cannot be stored in a register.                                |

### WRITE

Writes individual values to a register. Values not set are unchanged in the register.

#### Parameters

| Name    | Required | Type       | Description          |
| ------- | -------- | ---------- | -------------------- |
| `val0`  | `true`   | `float`    | Value set in lane 0  |
| `val1`  | `false`  | `float`    | Value set in lane 1  |
| `val2`  | `false`  | `float`    | Value set in lane 2  |
| `val3`  | `false`  | `float`    | Value set in lane 3  |
| `val4`  | `false`  | `float`    | Value set in lane 4  |
| `val5`  | `false`  | `float`    | Value set in lane 5  |
| `val6`  | `false`  | `float`    | Value set in lane 6  |
| `val7`  | `false`  | `float`    | Value set in lane 7  |
| `val8`  | `false`  | `float`    | Value set in lane 8  |
| `val9`  | `false`  | `float`    | Value set in lane 9  |
| `val10` | `false`  | `float`    | Value set in lane 10 |
| `val11` | `false`  | `float`    | Value set in lane 11 |
| `val12` | `false`  | `float`    | Value set in lane 12 |
| `val13` | `false`  | `float`    | Value set in lane 13 |
| `val14` | `false`  | `float`    | Value set in lane 14 |
| `val15` | `false`  | `float`    | Value set in lane 15 |
| `dest`  | `true`   | `register` | Destination register |

### LOAD

Loads consecutive float lanes from memory into a register slot.

#### Parameters

| Name    | Required | Type       | Description                        |
| ------- | -------- | ---------- | ---------------------------------- |
| `src`   | `true`   | `memory`   | Source memory                      |
| `count` | `true`   | `int`      | Number of lanes consumed, up to 16 |
| `dest`  | `true`   | `register` | Destination register               |

### ALLOC

Allocates a blank memory slot with fixed lane length.

#### Parameters

| Name     | Required | Type     | Description                                |
| -------- | -------- | -------- | ------------------------------------------ |
| `length` | `true`   | `int`    | Number of lanes to allocate                |
| `ref`    | `true`   | `memory` | Unused memory reference, offset is ignored |

### DEL

Deletes a memory reference and anything stored.

#### Parameters

| Name  | Required | Type     | Description                         |
| ----- | -------- | -------- | ----------------------------------- |
| `ref` | `true`   | `memory` | Memory reference, offset is ignored |

### STORE

Stores consecutive register lanes into memory.

#### Parameters

| Name    | Required | Type       | Description              |
| ------- | -------- | ---------- | ------------------------ |
| `src`   | `true`   | `register` | Source register          |
| `count` | `true`   | `int`      | Number of lanes to store |
| `dest`  | `true`   | `memory`   | Destination memory       |

### ADD_FLOAT

Adds float values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                            |
| ------ | -------- | ---------- | -------------------------------------- |
| `a`    | `true`   | `float`    | First value                            |
| `b`    | `true`   | `float`    | Second value                           |
| `dest` | `true`   | `register` | Destination register, stores a `float` |

### ADD_VEC2

Adds 2D vector values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                           |
| ------ | -------- | ---------- | ------------------------------------- |
| `a`    | `true`   | `vec2`     | First value                           |
| `b`    | `true`   | `vec2`     | Second value                          |
| `dest` | `true`   | `register` | Destination register, stores a `vec2` |

### ADD_VEC3

Adds 3D vector values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                           |
| ------ | -------- | ---------- | ------------------------------------- |
| `a`    | `true`   | `vec3`     | First value                           |
| `b`    | `true`   | `vec3`     | Second value                          |
| `dest` | `true`   | `register` | Destination register, stores a `vec3` |

### ADD_VEC4

Adds 4D vector values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                           |
| ------ | -------- | ---------- | ------------------------------------- |
| `a`    | `true`   | `vec4`     | First value                           |
| `b`    | `true`   | `vec4`     | Second value                          |
| `dest` | `true`   | `register` | Destination register, stores a `vec4` |

### SUB_FLOAT

Subtracts float values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                            |
| ------ | -------- | ---------- | -------------------------------------- |
| `a`    | `true`   | `float`    | First value                            |
| `b`    | `true`   | `float`    | Second value                           |
| `dest` | `true`   | `register` | Destination register, stores a `float` |

### SUB_VEC2

Subtracts 2D vector values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                           |
| ------ | -------- | ---------- | ------------------------------------- |
| `a`    | `true`   | `vec2`     | First value                           |
| `b`    | `true`   | `vec2`     | Second value                          |
| `dest` | `true`   | `register` | Destination register, stores a `vec2` |

### SUB_VEC3

Subtracts 3D vector values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                           |
| ------ | -------- | ---------- | ------------------------------------- |
| `a`    | `true`   | `vec3`     | First value                           |
| `b`    | `true`   | `vec3`     | Second value                          |
| `dest` | `true`   | `register` | Destination register, stores a `vec3` |

### SUB_VEC4

Subtracts 4D vector values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                           |
| ------ | -------- | ---------- | ------------------------------------- |
| `a`    | `true`   | `vec4`     | First value                           |
| `b`    | `true`   | `vec4`     | Second value                          |
| `dest` | `true`   | `register` | Destination register, stores a `vec4` |

### MUL_FLOAT

Multiplies float values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                            |
| ------ | -------- | ---------- | -------------------------------------- |
| `a`    | `true`   | `float`    | First value                            |
| `b`    | `true`   | `float`    | Second value                           |
| `dest` | `true`   | `register` | Destination register, stores a `float` |

### MUL_VEC2

Multiplies 2D vector values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                           |
| ------ | -------- | ---------- | ------------------------------------- |
| `a`    | `true`   | `vec2`     | First value                           |
| `b`    | `true`   | `vec2`     | Second value                          |
| `dest` | `true`   | `register` | Destination register, stores a `vec2` |

### MUL_VEC3

Multiplies 3D vector values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                           |
| ------ | -------- | ---------- | ------------------------------------- |
| `a`    | `true`   | `vec3`     | First value                           |
| `b`    | `true`   | `vec3`     | Second value                          |
| `dest` | `true`   | `register` | Destination register, stores a `vec3` |

### MUL_VEC4

Multiplies 4D vector values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                           |
| ------ | -------- | ---------- | ------------------------------------- |
| `a`    | `true`   | `vec4`     | First value                           |
| `b`    | `true`   | `vec4`     | Second value                          |
| `dest` | `true`   | `register` | Destination register, stores a `vec4` |

### DIV_FLOAT

Divides float values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                            |
| ------ | -------- | ---------- | -------------------------------------- |
| `a`    | `true`   | `float`    | First value                            |
| `b`    | `true`   | `float`    | Second value                           |
| `dest` | `true`   | `register` | Destination register, stores a `float` |

### DIV_VEC2

Divides 2D vector values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                           |
| ------ | -------- | ---------- | ------------------------------------- |
| `a`    | `true`   | `vec2`     | First value                           |
| `b`    | `true`   | `vec2`     | Second value                          |
| `dest` | `true`   | `register` | Destination register, stores a `vec2` |

### DIV_VEC3

Divides 3D vector values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                           |
| ------ | -------- | ---------- | ------------------------------------- |
| `a`    | `true`   | `vec3`     | First value                           |
| `b`    | `true`   | `vec3`     | Second value                          |
| `dest` | `true`   | `register` | Destination register, stores a `vec3` |

### DIV_VEC4

Divides 4D vector values and stores the result in a register.

#### Parameters

| Name   | Required | Type       | Description                           |
| ------ | -------- | ---------- | ------------------------------------- |
| `a`    | `true`   | `vec4`     | First value                           |
| `b`    | `true`   | `vec4`     | Second value                          |
| `dest` | `true`   | `register` | Destination register, stores a `vec4` |

### SCALE_VEC2

Scales a 2D vector value by a scalar and stores the result in a register.

#### Parameters

| Name     | Required | Type       | Description                           |
| -------- | -------- | ---------- | ------------------------------------- |
| `vec`    | `true`   | `vec2`     | Vector value                          |
| `scalar` | `true`   | `float`    | Scalar value                          |
| `dest`   | `true`   | `register` | Destination register, stores a `vec2` |

### SCALE_VEC3

Scales a 3D vector value by a scalar and stores the result in a register.

#### Parameters

| Name     | Required | Type       | Description                           |
| -------- | -------- | ---------- | ------------------------------------- |
| `vec`    | `true`   | `vec3`     | Vector value                          |
| `scalar` | `true`   | `float`    | Scalar value                          |
| `dest`   | `true`   | `register` | Destination register, stores a `vec3` |

### SCALE_VEC4

Scales a 4D vector value by a scalar and stores the result in a register.

#### Parameters

| Name     | Required | Type       | Description                           |
| -------- | -------- | ---------- | ------------------------------------- |
| `vec`    | `true`   | `vec4`     | Vector value                          |
| `scalar` | `true`   | `float`    | Scalar value                          |
| `dest`   | `true`   | `register` | Destination register, stores a `vec4` |

### SAMPLE_TEX2

Samples a 2D texture and stores the resulting `vec4` color in a register.

#### Parameters

| Name   | Required | Type       | Description                           |
| ------ | -------- | ---------- | ------------------------------------- |
| `tex`  | `true`   | `tex2`     | Texture reference.                    |
| `uv`   | `true`   | `vec2`     | Normalized UV coordinates             |
| `dest` | `true`   | `register` | Destination register, stores a `vec4` |
