# Naive Sort — Zig

Implementación de la especificación [05_Naive_Sort](https://yorche3.github.io/programming_languages/core/algorithms/05_Naive_Sort/) en **Zig**, usando una estructura tipo librería con `src/` y `test/`, el gestor de construcción `build.zig` y el framework de pruebas integrado (`std.testing` + `zig build test --summary all`).

Los tres algoritmos elementales de ordenamiento $O(n^2)$ — **selection sort**, **bubble sort** e **insertion sort** — ordenan *in-place* el slice recibido y devuelven ese mismo slice, sin invocar `std.sort` ni ninguna otra ayuda de ordenamiento de la biblioteca estándar.

No se requiere instalar una biblioteca externa ni usar `sudo`.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo / Directorio | Propósito |
|----------------------|-----------|
| [`build.zig`](build.zig) | Configuración del módulo de producción, la librería estática y el paso `test`. |
| [`src/naive_sort.zig`](src/naive_sort.zig) | Implementación de los 3 algoritmos del contrato. |
| [`test/naive_sort_test.zig`](test/naive_sort_test.zig) | Suite integrada: 3 tests (uno por algoritmo) con los 7 casos. |
| [`.gitignore`](.gitignore) | Ignora cachés (`zig-out/`, `.zig-cache/`), librerías y ejecutables generados. |

```text
naive_sort/
├── build.zig
├── src/
│   └── naive_sort.zig        # 3 algoritmos in-place
├── test/
│   └── naive_sort_test.zig   # 3 tests × 7 casos
├── .gitignore
└── README.md
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El proyecto se creó manualmente como una librería Zig, igual que `core/foundations/numbers/`: código de producción en `src/`, suite en `test/` y `build.zig` como orquestador, sin dependencias externas. `build.zig` crea el módulo de producción, instala una librería estática, conecta el módulo `naive_sort` con los tests y registra el paso `zig build test --summary all`.

**EN:** The project was created by hand as a Zig library, like `core/foundations/numbers/`: production code under `src/`, suite under `test/`, and `build.zig` as the orchestrator, with no external dependencies. `build.zig` creates the production module, installs a static library, connects the `naive_sort` module to the tests, and registers the `zig build test --summary all` step.

### Inicialización / Initialization

```bash
mkdir -p zig/core/algorithms/naive_sort/{src,test}
cd zig/core/algorithms/naive_sort
```

Después se añaden `build.zig`, el módulo en `src/` y la suite en `test/`.

---

## 📄 Configuración clave / Key Configuration

### `build.zig`

**ES:** El script declara el módulo de producción (`src/naive_sort.zig`), lo publica como librería estática (`libnaive_sort.a`), declara el módulo de tests (`test/naive_sort_test.zig`) con `test_module.addImport("naive_sort", naive_sort_module)` y registra el paso `test` con `b.test`.

**EN:** The script declares the production module (`src/naive_sort.zig`), publishes it as a static library (`libnaive_sort.a`), declares the test module (`test/naive_sort_test.zig`) with `test_module.addImport("naive_sort", naive_sort_module)`, and registers the `test` step with `b.test`.

```zig
const naive_sort_module = b.createModule(.{
    .root_source_file = b.path("src/naive_sort.zig"),
    .target = target,
    .optimize = optimize,
});
```

### `src/naive_sort.zig` — contrato e implementación

**ES:** Las tres funciones reciben un slice de enteros, lo ordenan *in-place* y devuelven el mismo slice. Con menos de dos elementos el slice vuelve sin cambios y ninguna función lanza errores.

**EN:** All three functions take an integer slice, sort it *in-place*, and return that same slice. With fewer than two elements the slice is returned unchanged and no function throws.

| Elemento del contrato | Representación en Zig |
| --------------------- | --------------------- |
| Array de enteros | `[]i32` (slice mutable, índices 0-based de tipo `usize`) |
| Caso nulo / inválido | Omitido: un slice no admite `null` sin envolverlo en un opcional (`?[]i32`) |
| Array vacío | `[_]i32{}` (`arr.len == 0`) |
| Orden | *in-place* sobre el slice recibido, devuelve el mismo slice |
| Nombres de la especificación | `selection_sort`, `bubble_sort`, `insertion_sort` (`snake_case`, idénticos a la especificación y a `core/foundations/numbers/`) |

### `test/naive_sort_test.zig`

**ES:** La suite usa bloques `test` con `std.testing` y un único helper compartido, `assert_sorts_all_cases(algorithm, sort)`, que recibe el nombre del algoritmo y un puntero a la función del contrato (`*const fn ([]i32) []i32`) y recorre los 7 casos. Cada caso copia su fixture en un búfer local antes de ordenarlo.

**EN:** The suite uses `test` blocks with `std.testing` and a single shared helper, `assert_sorts_all_cases(algorithm, sort)`, which receives the algorithm name and a pointer to the contract function (`*const fn ([]i32) []i32`) and walks the 7 cases. Every case copies its fixture into a local buffer before sorting it.

```zig
fn assert_sorts_all_cases(
    algorithm: []const u8,
    sort: *const fn ([]i32) []i32,
) !void {
    for (cases) |test_case| {
        var buffer: [64]i32 = undefined;
        const input = buffer[0..test_case.input.len];
        @memcpy(input, test_case.input);
        // …
    }
}
```

---

## 🚀 Compilación y ejecución / Build & Run

### Requisitos / Requirements

- **Zig 0.16.0**.
- Framework de testing integrado (`std.testing`).

Verificar:

```bash
zig version
```

Salida verificada:

```text
0.16.0
```

### Compilar y ejecutar las pruebas / Build & run tests

```bash
cd zig/core/algorithms/naive_sort
zig build
zig build test --summary all
```

**Salida real / Actual output:**

```text
$ zig build
Build Summary: 3/3 steps succeeded
install cached
+- install naive_sort cached
   +- compile lib naive_sort Debug native cached 26ms MaxRSS:38M
```

```text
$ zig build test --summary all
Build Summary: 3/3 steps succeeded; 3/3 tests passed
test success
+- run test 3 pass (3 total) 6ms MaxRSS:4M
   +- compile test Debug native cached 45ms MaxRSS:38M
```

> **ES:** El resumen muestra tres tests Zig porque cada test agrupa los 7 casos de la especificación; en total se validan 21 casos y no hay fallos.
> **EN:** The summary shows three Zig tests because each test groups the 7 specification cases; 21 cases are validated in total with no failures.

---

## 🧠 Algoritmos y operaciones / Algorithms & Operations

| Función / Algorithm | Enfoque / Approach | Descripción / Description |
| ------------------- | ------------------ | ------------------------- |
| `selection_sort(arr)` | iterativo, *in-place*, `for` sobre rangos | Busca el mínimo del tramo no ordenado con `min_index` y lo intercambia al inicio con `temp`. $O(n^2)$ siempre. |
| `bubble_sort(arr)` | iterativo, *in-place*, con bandera | Compara adyacentes e intercambia; sale antes con `if (!swapped) break;` cuando una pasada no intercambia nada. $O(n^2)$ peor/promedio, $O(n)$ mejor. |
| `insertion_sort(arr)` | iterativo, *in-place*, estable | Guarda `key`, desplaza el tramo ordenado con `while (j > 0 and arr[j - 1] > key)` y lo inserta en su posición. $O(n^2)$ peor/promedio, $O(n)$ mejor. |

| Caso (descripción en la suite) | Entrada | Salida esperada |
| ------------------------------ | ------- | --------------- |
| an unsorted array | `[_]i32{ 5, 2, 9, 1, 5, 6 }` | `[_]i32{ 1, 2, 5, 5, 6, 9 }` |
| an already sorted array | `[_]i32{ 1, 2, 3, 4, 5 }` | `[_]i32{ 1, 2, 3, 4, 5 }` |
| a reverse ordered array | `[_]i32{ 5, 4, 3, 2, 1 }` | `[_]i32{ 1, 2, 3, 4, 5 }` |
| an array of identical elements | `[_]i32{ 7, 7, 7, 7 }` | `[_]i32{ 7, 7, 7, 7 }` |
| an array with negative numbers | `[_]i32{ 3, -1, 4, -5, 0 }` | `[_]i32{ -5, -1, 0, 3, 4 }` |
| a single element array | `[_]i32{42}` | `[_]i32{42}` |
| an empty array | `[_]i32{}` | `[_]i32{}` |

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** Divergencia idiomática aceptada: las tres funciones ordenan ***in-place*** el slice recibido y devuelven ese mismo slice, variante que la especificación permite. Los slices de Zig son vistas sobre memoria mutable, así que la suite copia cada fixture en un búfer local (`[64]i32` + `@memcpy`) antes de ordenarlo: ningún caso reutiliza un búfer ya ordenado.
- **EN:** Accepted idiomatic divergence: all three functions sort the received slice ***in-place*** and return that same slice, a variant the specification allows. Zig slices are views over mutable memory, so the suite copies every fixture into a local buffer (`[64]i32` + `@memcpy`) before sorting it: no case reuses an already sorted buffer.
- **ES:** Caso nulo omitido: un slice `[]i32` no admite `null` sin envolverlo en un opcional (`?[]i32`), que se formaliza en la fase de abstracción y persistencia, así que la entrada nula no es representable en la firma y no hay indicador de fallo que comprobar. Se conservan los 7 casos. Ninguna función lanza errores.
- **EN:** Null case omitted: a `[]i32` slice does not admit `null` without wrapping it in an optional (`?[]i32`), which is formalized in the abstraction and persistence phase, so a null input is not representable in the signature and there is no failure indicator to check. The 7 cases are kept. No function throws.
- **ES:** Zig no tiene `for` de tres cláusulas: `for` itera operandos. Los bucles del pseudocódigo se traducen a `for (0..n - 1) |i|` con el interior `for (i + 1..n) |j|` (selection) y `for (0..n - 1 - i) |j|` (bubble, equivalente exacto de `for j = 0 to n - 2 - i`); `insertion_sort` usa `while (j > 0 and arr[j - 1] > key) : (j -= 1)`, equivalente al `while j >= 0 and arr[j] > key` del pseudocódigo con índices `usize` que no pueden volverse negativos (el decremento bajo cero sería un *underflow* de runtime).
- **EN:** Zig has no three-clause `for`: `for` iterates operands. The pseudocode loops translate to `for (0..n - 1) |i|` with the inner `for (i + 1..n) |j|` (selection) and `for (0..n - 1 - i) |j|` (bubble, the exact equivalent of `for j = 0 to n - 2 - i`); `insertion_sort` uses `while (j > 0 and arr[j - 1] > key) : (j -= 1)`, equivalent to the pseudocode's `while j >= 0 and arr[j] > key` with `usize` indices that cannot become negative (decrementing below zero would be a runtime underflow).
- **ES:** Los operadores booleanos de Zig son `and` / `or`; `&&` y `||` no existen. La comparación estricta (`arr[j - 1] > key`) mantiene `insertion_sort` estable.
- **EN:** Zig boolean operators are `and` / `or`; `&&` and `||` do not exist. The strict comparison (`arr[j - 1] > key`) keeps `insertion_sort` stable.
- **ES:** `bubble_sort` conserva la optimización de salida temprana: la bandera `swapped` y el `break` reproducen el `if not swapped: break` del pseudocódigo (mejor caso $O(n)$). La bandera no es observable en la salida, así que su presencia se verifica contra el pseudocódigo.
- **EN:** `bubble_sort` keeps the early-exit optimization: the `swapped` flag and the `break` reproduce the pseudocode's `if not swapped: break` (best case $O(n)$). The flag is not observable in the output, so its presence is verified against the pseudocode.
- **ES:** `std.testing.expectEqualSlices` no admite mensaje, así que el helper imprime el mensaje del contrato con `std.debug.print("{s} should sort {s}", .{ algorithm, test_case.description })` antes de devolver el error; esa línea es la que aparece en el reporte de fallo (por ejemplo `selection_sort should sort an unsorted array`).
- **EN:** `std.testing.expectEqualSlices` does not accept a message, so the helper prints the contract message with `std.debug.print("{s} should sort {s}", .{ algorithm, test_case.description })` before returning the error; that line is the one shown in the failure report (for example `selection_sort should sort an unsorted array`).
- **ES:** Los fixtures se declaran como arrays `[_]i32` (`standard_input`, `reverse_input`, …) más una tabla `cases` de `SortCase` con descripción, entrada y salida esperada; el helper recorre la tabla para cada algoritmo.
- **EN:** The fixtures are declared as `[_]i32` arrays (`standard_input`, `reverse_input`, …) plus a `cases` table of `SortCase` with description, input, and expected output; the helper walks the table for each algorithm.
- **ES:** A diferencia de `core/foundations/numbers/`, este módulo sí incluye comentarios en `src/` y `test/`: el contrato, la decisión sobre el caso nulo y el aislamiento de fixtures se documentan junto al código. `zig fmt --check` sobre `build.zig`, `src/naive_sort.zig` y `test/naive_sort_test.zig` no reporta desvíos.
- **EN:** Unlike `core/foundations/numbers/`, this module does include comments in `src/` and `test/`: the contract, the null-case decision, and fixture isolation are documented next to the code. `zig fmt --check` on `build.zig`, `src/naive_sort.zig`, and `test/naive_sort_test.zig` reports no deviations.
- **ES:** Nota de desviación respecto a la ubicación esperada: se conservan `src/naive_sort.zig` (solo cambia la extensión) y `test/naive_sort_test.zig` (mismo nombre que la especificación); no se añade `run_tests.zig` porque `zig build test --summary all` es el runner. Los artefactos (`zig-out/`, `.zig-cache/`, `*.a`) quedan excluidos por `.gitignore`.
- **EN:** Deviation note from the expected location: `src/naive_sort.zig` (only the extension changes) and `test/naive_sort_test.zig` (same name as the specification) are kept; no `run_tests.zig` is added because `zig build test --summary all` is the runner. Artifacts (`zig-out/`, `.zig-cache/`, `*.a`) are excluded by `.gitignore`.

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*[← Volver a Algoritmos Puros](../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
