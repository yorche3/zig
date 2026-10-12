# 🚀 Algoritmos Puros / Algorithms Pure — Zig

Implementaciones de la [Fase 1 — Algoritmos Puros](https://yorche3.github.io/programming_languages/ROADMAP/#fase-1--algoritmos-puros--algorithms-pure-) en **Zig**: ordenamientos elementales, estructuras de datos propias, ordenamientos óptimos y distribuidos, y búsqueda.

Los módulos de esta fase trabajan sobre **slices mutables** (`[]i32`), que se ordenan *in-place* y se devuelven. Un slice no admite `null` sin envolverlo en un opcional (`?[]i32`), así que el caso nulo no es representable en la firma del contrato.

`data_structures_basics` trabaja en cambio con celdas enlazadas: cada nodo se reserva en el montón con el `Allocator` que recibe la estructura en `init` y se suelta en `deinit`, y el enlace ausente es `null` dentro de `?*Node`.

---

## 📂 Módulos / Modules

| Módulo | Especificación | Enfoque | Tests | Estado |
|--------|---------------|---------|:-----:|:------:|
| [`naive_sort/`](naive_sort/) | [05_Naive_Sort](https://yorche3.github.io/programming_languages/core/algorithms/05_Naive_Sort/) | `build.zig` + `std.testing` | 21 | ✅ |
| [`data_structures_basics/`](data_structures_basics/) | [06_Data_Structures_Basics](https://yorche3.github.io/programming_languages/core/algorithms/06_Data_Structures_Basics/) | `build.zig` + `std.testing` + `Allocator` | 15 | ✅ |

---

## 📁 Estructura / Structure

```text
algorithms/
├── naive_sort/                      # 05_Naive_Sort
│   ├── .gitignore                   # zig-out/, .zig-cache/, librerías y ejecutables
│   ├── build.zig                    # librería estática + paso `test`
│   ├── src/
│   │   └── naive_sort.zig           # 3 algoritmos in-place
│   ├── test/
│   │   └── naive_sort_test.zig      # 3 tests × 7 casos
│   └── README.md
└── data_structures_basics/          # 06_Data_Structures_Basics
    ├── .gitignore                   # zig-out/, .zig-cache/, binarios y artefactos nativos
    ├── build.zig                    # librería estática + paso `test`
    ├── build.zig.zon                # minimum_zig_version = "0.17.0"
    ├── src/
    │   └── data_structures_basics.zig    # Node, LinkedList, Stack y Queue
    ├── test/
    │   └── data_structures_basics_test.zig   # 5 tests × 15 casos
    └── README.md
```

---

## 🛠️ Patrón común / Common Pattern

| Característica | Descripción |
|---------------|-------------|
| **Runtime** | Zig 0.17.0 (`zig build` + `zig build test --summary all`) |
| **CLI** | `zig build test --summary all` desde la raíz del módulo |
| **Andamiaje** | ✍️ Estructura manual (`mkdir -p src test`), la que ya usa [`foundations/numbers/`](../foundations/numbers/); `data_structures_basics` partió de `zig init` y reorganizó ese andamiaje a la misma forma |
| **Framework de tests** | `std.testing` integrado: bloques `test "…"`, `std.testing.expectEqualSlices` |
| **Runner** | `build.zig` registra el paso `test` con `b.addTest` y `b.step`; no hay `run_tests.zig` |
| **Separación** | `src/` (módulo de producción) ↔ `test/` (suite), conectados por `build.zig` con `addImport` |
| **Módulo fuente** | Archivo raíz del módulo (`src/naive_sort.zig`) con funciones `pub fn`, como `src/numbers.zig` |
| **API** | Una función por algoritmo: `naive_sort.selection_sort(arr)`, etc. |
| **Naming** | `snake_case` idéntico al de la especificación en los módulos de ordenamiento (`selection_sort`); `camelCase` en `data_structures_basics` (`insertHead`, `headValue`, `valueOf`), donde el borrador del módulo lo fija así |
| **Mutabilidad** | Los slices son vistas sobre memoria mutable y los algoritmos ordenan *in-place*; la suite copia cada fixture en un búfer local para no reutilizar slices ordenados |
| **Nulabilidad** | `[]i32` no admite `null` sin `?[]i32`: el caso nulo no es representable y se omite |
| **Bucles** | Zig no tiene `for` de tres cláusulas: `for (0..n - 1) \|i\|` sobre rangos y `while (cond) : (cont)`; operadores booleanos `and` / `or` |
| **Mensajes de aserción** | `expectEqualSlices` no admite mensaje: el mensaje del contrato se emite con `std.debug.print("{s} should sort {s}", …)` antes de devolver el error |
| **Verificación estática** | `zig build` compila el módulo y la librería estática sin warnings ni errores; `zig fmt --check` no reporta desvíos |
| **Artefactos** | `zig-out/` (incluida `libnaive_sort.a`), `.zig-cache/`, `zig-cache/`, ejecutables y artefactos nativos (`*.o`, `*.a`, `*.so`, `*.dylib`, `*.dll`) — ignorados por el `.gitignore` |

---

## 🚀 Compilación rápida / Quick Build

```bash
# Naive Sort Tests
cd naive_sort
zig build
zig build test --summary all

# Data Structures Basics Tests
cd ../data_structures_basics
zig build
zig build test --summary all
```

---

## ▶️ Siguiente / Next

👉 Continúa con los módulos pendientes de esta fase en el [Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/).

👉 Continue with the pending modules of this phase in the [Roadmap](https://yorche3.github.io/programming_languages/ROADMAP/).

---

*[← Volver a Core](../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
