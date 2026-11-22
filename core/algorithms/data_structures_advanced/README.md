# Data Structures Advanced — Zig

Implementación de la especificación [07_Data_Structures_Advanced](https://yorche3.github.io/programming_languages/core/algorithms/07_Data_Structures_Advanced/) en **Zig**, con una estructura tipo librería (`src/` + `test/`), el gestor de construcción `build.zig` y el framework de pruebas integrado (`std.testing` + `zig build test --summary all`).

Define un nodo con valor embebido y enlaces opcionales, `TreeNode`, y dos tipos abstractos de datos construidos manualmente desde cero: `BinaryTree` (árbol binario de búsqueda no acotado) y `Graph` (grafo dirigido con registro canónico enlazado y listas de adyacencia ordenadas). Ninguna estructura utiliza colecciones de la biblioteca estándar (`std.ArrayList`, `std.AutoHashMap`, etc.) ni delega operaciones en contenedores preexistentes.

Implementation of the [07_Data_Structures_Advanced](https://yorche3.github.io/programming_languages/core/algorithms/07_Data_Structures_Advanced/) specification in **Zig**, using a library-style layout (`src/` + `test/`), the `build.zig` build manager, and the built-in test framework (`std.testing` + `zig build test --summary all`).

It defines an embedded-value node with optional links, `TreeNode`, and two abstract data types built manually from scratch: `BinaryTree` (unbounded binary search tree) and `Graph` (directed graph with a linked canonical vertex registry and sorted adjacency lists). Neither structure uses standard-library collections (`std.ArrayList`, `std.AutoHashMap`, etc.) nor delegates operations to pre-existing containers.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo / Directory | Propósito / Purpose |
|---|---|
| [`build.zig`](build.zig) | Declara el módulo de producción, publica la librería estática y registra el paso `test`. / Declares the production module, publishes the static library, and registers the `test` step. |
| [`build.zig.zon`](build.zig.zon) | Manifiesto del paquete: nombre, fingerprint y `minimum_zig_version = "0.17.1"`. / Package manifest: name, fingerprint, and `minimum_zig_version = "0.17.1"`. |
| [`src/data_structures_advanced.zig`](src/data_structures_advanced.zig) | `TreeNode`, `BinaryTree`, `Graph`, y los nodos internos `NeighborNode` y `GraphNode`. / `TreeNode`, `BinaryTree`, `Graph`, and internal nodes `NeighborNode` and `GraphNode`. |
| [`test/data_structures_advanced_test.zig`](test/data_structures_advanced_test.zig) | Suite integrada: 23 tests que cubren los 24 casos de la especificación (23 ejecutados, 1 caso inmutable omitido). / Integrated suite: 23 tests covering the specification's 24 cases (23 executed, 1 immutable case omitted). |
| [`.gitignore`](.gitignore) | Ignora cachés (`zig-out/`, `.zig-cache/`), binarios y artefactos nativos. / Ignores caches (`zig-out/`, `.zig-cache/`), binaries, and native artifacts. |
| `README.md` | Este documento. / This document. |

**Estructura de directorios / Directory structure:**

```text
data_structures_advanced/
├── build.zig
├── build.zig.zon
├── src/
│   └── data_structures_advanced.zig        # TreeNode, BinaryTree, Graph y nodos internos
├── test/
│   └── data_structures_advanced_test.zig   # 23 tests × 24 casos de la especificación
├── .gitignore
└── README.md
```

> **Nota de desviación / Deviation note:** La especificación propone `src/data_structures_advanced.ext`, `test/data_structures_advanced_test.ext` y `test/run_tests.ext`. Se conservan los dos primeros con la extensión `.zig` y **no se añade** `run_tests.zig`: el runner es el paso `test` de `build.zig` (`zig build test --summary all`), como en los módulos homologados `data_structures_basics` y `numbers`.
>
> **Deviation note:** The specification proposes `src/data_structures_advanced.ext`, `test/data_structures_advanced_test.ext`, and `test/run_tests.ext`. The first two are kept with the `.zig` extension and `run_tests.zig` is **not** added: the runner is `build.zig`'s `test` step (`zig build test --summary all`), as in the homologated `data_structures_basics` and `numbers` modules.

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El módulo se diseñó como una librería estática Zig siguiendo la estructura de `core/algorithms/data_structures_basics/` y `core/foundations/numbers/`: código de producción en `src/`, suite en `test/` y `build.zig` como orquestador nativo, sin dependencias externas. La implementación es completamente manual: el registro canónico de vértices se gestiona mediante punteros y enlaces en `GraphNode.next_vertex`, y las aristas salientes se mantienen como una lista enlazada ordenada en `NeighborNode`. La búsqueda por etiqueta (`findVertex`), la inserción ordenada de vecinos (`insertNeighborSorted`) y la copia aislada de adyacencias (`getNeighbors`) se escriben a mano, sin delegar en `std.ArrayList`, tablas hash ni rutinas de ordenamiento de la biblioteca estándar.

**EN:** The module was designed as a static Zig library following the structure of `core/algorithms/data_structures_basics/` and `core/foundations/numbers/`: production code under `src/`, suite under `test/`, and `build.zig` as the native orchestrator, with no external dependencies. The implementation is entirely manual: the canonical vertex registry is managed via pointers and links in `GraphNode.next_vertex`, and outgoing edges are maintained as a sorted linked list in `NeighborNode`. Label lookup (`findVertex`), sorted neighbour insertion (`insertNeighborSorted`), and isolated adjacency copying (`getNeighbors`) are hand-written, without delegating to `std.ArrayList`, hash tables, or standard-library sorting routines.

### Inicialización / Initialization

```bash
cd zig/core/algorithms/data_structures_advanced
zig init
```

Después se eliminan las plantillas generadas (`src/main.zig`, `src/root.zig`) y se crean `src/data_structures_advanced.zig`, `test/data_structures_advanced_test.zig` y el `build.zig` del módulo.

Then the generated templates (`src/main.zig`, `src/root.zig`) are removed, and `src/data_structures_advanced.zig`, `test/data_structures_advanced_test.zig`, and the module's `build.zig` are written.

---

## 📄 Configuración clave / Key Configuration

### `build.zig`

**ES:** El script declara el módulo de producción (`src/data_structures_advanced.zig`), publica la librería estática `data_structures_advanced`, declara el módulo de pruebas (`test/data_structures_advanced_test.zig`) vinculando el módulo de producción con `addImport("data_structures_advanced", ...)` y expone el paso `test` con `b.addTest` y `b.step`.

**EN:** The script declares the production module (`src/data_structures_advanced.zig`), publishes the `data_structures_advanced` static library, declares the test module (`test/data_structures_advanced_test.zig`) linking the production module via `addImport("data_structures_advanced", ...)`, and exposes the `test` step with `b.addTest` and `b.step`.

```zig
const data_structures_advanced_module = b.createModule(.{
    .root_source_file = b.path("src/data_structures_advanced.zig"),
    .target = target,
    .optimize = optimize,
});

const test_module = b.createModule(.{
    .root_source_file = b.path("test/data_structures_advanced_test.zig"),
    .target = target,
    .optimize = optimize,
});
test_module.addImport("data_structures_advanced", data_structures_advanced_module);
```

### `build.zig.zon`

**ES:** Manifiesto del paquete sin dependencias externas (`.dependencies = .{}`). Declara el nombre `.data_structures_advanced`, versión semántica `0.0.0`, el fingerprint único y `minimum_zig_version = "0.17.1"`.

**EN:** Package manifest with no external dependencies (`.dependencies = .{}`). It declares name `.data_structures_advanced`, semantic version `0.0.0`, the unique fingerprint, and `minimum_zig_version = "0.17.1"`.

### `.gitignore`

```text
zig-out/
.zig-cache/
zig-cache/
data_structures_advanced
data_structures_advanced.exe
*.o
*.a
*.so
*.dylib
*.dll
```

---

## 🚀 Compilación y ejecución / Build & Run

### Requisitos / Requirements

- **Zig 0.17.1**.
- Framework de pruebas integrado (`std.testing`).

Verificar versión / Check version:

```bash
zig version
```

Salida verificada / Verified output:

```text
0.17.1
```

### Compilar y ejecutar las pruebas / Build & run tests

```bash
cd zig/core/algorithms/data_structures_advanced
zig build --summary all
zig build test --summary all
```

**Salida real / Actual output:**

```text
$ zig build --summary all
Build Summary: 3/3 steps succeeded
install success
+- install data_structures_advanced success
   +- compile lib data_structures_advanced debug native success 82ms MaxRSS:89M
```

```text
$ zig build test --summary all
Build Summary: 3/3 steps succeeded; 23/23 tests passed
test success
+- run test 23 pass (23 total) 6ms MaxRSS:4M
   +- compile test debug native success 697ms MaxRSS:149M
```

**ES:** El resumen muestra 23 tests Zig aprobados, ejecutando de forma exhaustiva 23 de los 24 casos de la especificación (el caso de adaptación inmutable se omite formalmente al ser un lenguaje con mutación in-place). Cada prueba aísla su memoria mediante un `ArenaAllocator` sobre `std.testing.allocator`, garantizando ausencia de fugas y aislamiento estricto de escenarios.

**EN:** The summary shows 23 passing Zig tests, comprehensively exercising 23 of the 24 specification cases (the immutable adaptation case is formally omitted as Zig uses in-place mutation). Each test isolates its memory via an `ArenaAllocator` over `std.testing.allocator`, ensuring leak-free execution and strict scenario isolation.

**Formato / Formatting:**

```bash
zig fmt --check src test
```

**ES:** `zig fmt --check` finaliza con código de salida `0` y sin salidas en stdout/stderr, confirmando formateo canónico.

**EN:** `zig fmt --check` exits with status `0` and no stdout/stderr output, confirming canonical formatting.

---

## 🧠 Algoritmos y operaciones / Algorithms & Operations

| Operación / Operation | Entrada → salida / Input → output | Complejidad / Complexity | Notas / Notes |
|---|---|---|---|
| `TreeNode.init(value)` | `i32 → TreeNode` | $O(1)$ | Inicializa el nodo con valor embebido y enlaces ausentes (`null`). / Initializes node with embedded value and absent links (`null`). |
| `TreeNode.valueOf()` | `*const TreeNode → i32` | $O(1)$ | Consulta el valor embebido del nodo; no muta. / Reads embedded node value; non-mutating. |
| `TreeNode.leftOf()` | `*const TreeNode → ?*TreeNode` | $O(1)$ | Enlace izquierdo o `null`. / Left link or `null`. |
| `TreeNode.rightOf()` | `*const TreeNode → ?*TreeNode` | $O(1)$ | Enlace derecho o `null`. / Right link or `null`. |
| `TreeNode.setLeft(left)` | `(*TreeNode, ?*TreeNode) → void` | $O(1)$ | Muta el enlace izquierdo in-place. / Mutates left link in-place. |
| `TreeNode.setRight(right)` | `(*TreeNode, ?*TreeNode) → void` | $O(1)$ | Muta el enlace derecho in-place. / Mutates right link in-place. |
| `BinaryTree.init(allocator)` | `Allocator → BinaryTree` | $O(1)$ | Árbol vacío (`root = null`, `count = 0`) con allocator explícito. / Empty tree (`root = null`, `count = 0`) with explicit allocator. |
| `BinaryTree.insert(value)` | `(*BinaryTree, i32) → bool` | $O(h)$ | Inserta según invariante de ABB mediante bucle iterativo; duplicado retorna éxito sin alterar tamaño. / Inserts following BST invariant via iterative loop; duplicates succeed without increasing size. |
| `BinaryTree.contains(value)` | `(*const BinaryTree, i32) → bool` | $O(h)$ | Búsqueda iterativa en ABB; $h$ es la altura del árbol. / Iterative search in BST; $h$ is tree height. |
| `BinaryTree.isEmpty()` | `*const BinaryTree → bool` | $O(1)$ | `count == 0`. |
| `BinaryTree.len()` | `*const BinaryTree → usize` | $O(1)$ | Número de claves únicas en el árbol. / Number of unique keys in tree. |
| `Graph.init(allocator)` | `Allocator → Graph` | $O(1)$ | Grafo vacío (`vertices = null`, contadores a cero). / Empty graph (`vertices = null`, counters at zero). |
| `Graph.addVertex(label)` | `(*Graph, i32) → bool` | $O(V)$ | Registra vértice; duplicado retorna éxito conservando adyacencias existentes. / Registers vertex; duplicate succeeds preserving existing adjacency. |
| `Graph.addEdge(u, v)` | `(*Graph, i32, i32) → bool` | $O(V + d(u))$ | Verifica existencia de `u` y `v`; inserta `v` ordenado en la adyacencia de `u`; duplicado o bucle retornan éxito sin duplicar aristas. / Verifies endpoints; inserts `v` sorted in `u`'s adjacency; duplicates/loops succeed without duplicate edge. |
| `Graph.hasEdge(u, v)` | `(*const Graph, i32, i32) → bool` | $O(V + d(u))$ | Comprueba existencia de arista dirigida `u → v`. / Checks existence of directed edge `u → v`. |
| `Graph.getNeighbors(u)` | `(*const Graph, i32) → ?[]i32` | $O(V + d(u))$ | Copia asignada de vecinos en orden creciente; slice vacío si está aislado; `null` si `u` no existe. / Allocated copy of sorted neighbours; empty slice if isolated; `null` if `u` missing. |
| `Graph.isEmpty()` | `*const Graph → bool` | $O(1)$ | `vertex_total == 0`. |
| `Graph.vertexCount()` | `*const Graph → usize` | $O(1)$ | Número de vértices registrados. / Number of registered vertices. |
| `Graph.edgeCount()` | `*const Graph → usize` | $O(1)$ | Número de aristas dirigidas registradas. / Number of registered directed edges. |

---

## 🧩 Decisiones de diseño / Design decisions

| Decisión / Decision | Alternativa considerada / Alternative | Razón / Reason |
|---|---|---|
| Valor embebido en `TreeNode` y `GraphNode` en lugar de herencia formal | Herencia tipo POO con clase base | Zig no posee herencia de estructuras; la especificación autoriza expresamente el valor embebido (`value: i32`) para representar la base `Node(value)`. / Zig does not feature struct inheritance; the specification explicitly authorizes embedded values (`value: i32`) to represent base `Node(value)`. |
| Reserva dinámica de nodos vía `Allocator` | Arrays de capacidad prefijada o colecciones `std` | El contrato exige estructuras dinámicas no acotadas sin capacidad máxima prefijada, implementadas manualmente sin colecciones de biblioteca. / The contract demands unbounded dynamic structures with no preset max capacity, manually implemented without stdlib collections. |
| Registro canónico de vértices enlazado en `GraphNode.next_vertex` | `std.AutoHashMap` o tabla hash interna | La especificación prohíbe explícitamente delegar el registro en diccionarios o tablas hash; el registro enlazado cumple $O(V)$ manual. / The spec explicitly forbids delegating registry to hash maps; the linked registry complies with manual $O(V)$. |
| Inserción ordenada de adyacencias en $O(d(u))$ al momento de `addEdge` | Almacenamiento desordenado y ordenamiento en `getNeighbors` | Mantiene la invariante de orden creciente en todo momento; evita ordenar en cada consulta de vecinos y cumple la cota $O(V + d(u))$. / Maintains ascending invariant at all times; avoids sorting on each query and satisfies $O(V + d(u))$. |
| `getNeighbors` devuelve un slice copia asignado (`?[]i32`) | Devolver puntero directo a los nodos internos de adyacencia | Garantiza aislamiento estricto: el llamante no puede alterar la estructura interna del grafo ni sus datos mutan con altas posteriores. / Guarantees strict isolation: caller cannot alter internal graph structure and data is isolated from future mutations. |
| Uso de `ArenaAllocator` en las pruebas unitarias | `std.heap.page_allocator` sin aislamiento | El contrato del módulo no define método `deinit`; el arena sobre `std.testing.allocator` garantiza limpieza determinista sin fugas en cada test. / Module contract does not define `deinit`; arena over `std.testing.allocator` ensures deterministic leak-free teardown per test. |
| Nombres de métodos en `camelCase` (`valueOf`, `leftOf`, `isEmpty`) | Snake_case idéntico al pseudocódigo | Idiomático en Zig; evita colisiones léxicas con los nombres de campos de la estructura (`value`, `left`, `right`). / Idiomatic in Zig; prevents lexical collisions with struct field names (`value`, `left`, `right`). |

---

## 🔀 Adaptaciones idiomáticas / Idiomatic adaptations

| Especificación / Specification | Adaptación / Adaptation | Justificación / Justification |
|---|---|---|
| `Node` como tipo base por herencia | Valor embebido `value: i32` en cada nodo | Zig no implementa herencia de estructuras; el valor embebido es la forma nativa permitida por la especificación. / Zig lacks struct inheritance; embedded value is the native pattern permitted by the specification. |
| `TreeNode.get_value()` / `get_left()` / `get_right()` | `valueOf()`, `leftOf()`, `rightOf()` | Evita colisión de identificadores con los campos `value`, `left`, `right` de la estructura en Zig. / Prevents name collisions with struct fields `value`, `left`, `right` in Zig. |
| `TreeNode.set_left` / `set_right` retornan `this` | Métodos mutantes in-place con retorno `void` | Convención idiomática de Zig para métodos mutadores; el llamante ya posee el puntero mutable. / Idiomatic Zig convention for mutator methods; caller already holds the mutable pointer. |
| Adaptación inmutable de `TreeNode` | Omitida / Not applicable | Zig en esta fase opera con estructuras mutables in-place; no se declara variante inmutable persistente. / Zig operates in-place on mutable structures in this phase; no persistent immutable variant is declared. |
| `BinaryTree.init()` / `Graph.init()` sin argumentos | `BinaryTree.init(allocator)` / `Graph.init(allocator)` | En Zig la asignación de memoria es explícita; las estructuras requieren un `Allocator` para crear nodos. / Memory allocation is explicit in Zig; structures require an `Allocator` to instantiate nodes. |
| `BinaryTree.size()` | `BinaryTree.len()` | Convención estándar en Zig (`len` para conteo de elementos). / Standard Zig convention (`len` for element counts). |
| `GraphNode` y `NeighborNode` en API pública | Tipos internos privados a `data_structures_advanced.zig` | Encapsulamiento del registro canónico; los consumidores interactúan exclusivamente a través de la API pública de `Graph`. / Encapsulation of canonical registry; consumers interact exclusively via `Graph`'s public API. |
| `Graph.get_neighbors` fallo y aislado | `null` para vértice ausente, `&.{}` para vértice aislado | Zig distingue nativamente la ausencia opcional (`?[]i32`) del slice vacío sin ambigüedades ni centinelas. / Zig natively distinguishes optional absence (`?[]i32`) from empty slice without sentinels. |
| `test/run_tests.ext` | `zig build test --summary all` | Runner provisto directamente por la herramienta de construcción nativa `build.zig`. / Runner provided directly by the native `build.zig` build tool. |

---

## 🚨 Indicadores de fallo / Failure indicators

| Operación / Operation | Situación de fallo / Failure situation | Indicador / Indicator | Ejemplo / Example |
|---|---|---|---|
| `BinaryTree.contains(value)` | Valor ausente en el árbol / Value not in tree | `false` | `tree.contains(99) == false` |
| `BinaryTree.insert(value)` | Agotamiento de memoria del sistema / Memory allocation failure | `false` | Retorna `false` si `allocator.create` falla. / Returns `false` if `allocator.create` fails. |
| `Graph.addVertex(label)` | Agotamiento de memoria del sistema / Memory allocation failure | `false` | Retorna `false` si falla la asignación. / Returns `false` if allocation fails. |
| `Graph.addEdge(u, v)` | Extremo `u` o `v` inexistente, o fallo de memoria / Endpoint `u` or `v` missing, or out of memory | `false` | `graph.addEdge(10, 99) == false` |
| `Graph.hasEdge(u, v)` | Arista ausente, o extremo `u` inexistente / Edge absent, or endpoint `u` missing | `false` | `graph.hasEdge(10, 30) == false` |
| `Graph.getNeighbors(u)` | Vértice `u` inexistente en el grafo / Vertex `u` does not exist in graph | `null` (dentro de `?[]i32`) | `graph.getNeighbors(99) == null` |
| `TreeNode.leftOf()`, `rightOf()` | Enlace ausente / Absent link | `null` (dentro de `?*TreeNode`) | `node.leftOf() == null` |
| Entrada nula o inválida / Null or invalid input | No aplica: las etiquetas y claves son de tipo `i32` no anulable / Not applicable: keys and labels are non-nullable `i32` | No aplica / Not applicable | — |

---

## ✅ Cobertura de pruebas / Test coverage

| Caso de la especificación / Specification case | Cubierto / Covered | Prueba / Test | Notas / Notes |
|---|---|:--:|---|
| `TreeNode` — Crear un nodo de árbol / Create a tree node | Sí / Yes | `test/data_structures_advanced_test.zig:110` (`test "TreeNode: create a tree node"`) | Inicialización con valor 10 y verificación con `valueOf()`. / Init with value 10 and verification via `valueOf()`. |
| `TreeNode` — Enlaces iniciales ausentes / Absent initial links | Sí / Yes | `test/data_structures_advanced_test.zig:115` (`test "TreeNode: absent initial links"`) | Comprueba que `leftOf()` y `rightOf()` retornan `null`. / Checks that `leftOf()` and `rightOf()` return `null`. |
| `TreeNode` — Enlazar dos hijos / Link two children | Sí / Yes | `test/data_structures_advanced_test.zig:121` (`test "TreeNode: link two children"`) | Enlaza hijos 20 y 30 con `setLeft`/`setRight` y lee sus valores. / Links children 20 and 30 with `setLeft`/`setRight` and reads values. |
| `TreeNode` — Recorrer cada enlace / Traverse each link | Sí / Yes | `test/data_structures_advanced_test.zig:133` (`test "TreeNode: traverse each link"`) | Navega hacia hijos izquierdo y derecho verificando valores y enlaces hoja `null`. / Traverses left and right children verifying values and null leaf links. |
| `TreeNode` — Desenlazar hijos / Unlink children | Sí / Yes | `test/data_structures_advanced_test.zig:149` (`test "TreeNode: unlink children"`) | Desenlaza izquierdo pasando `null` y luego derecho; conserva valor del padre. / Unlinks left passing `null` then right; preserves parent value. |
| `TreeNode` — Adaptación inmutable (si aplica) / Immutable adaptation (if applicable) | Omitido / Omitted | `test/data_structures_advanced_test.zig:171` (comentario explicativo / explanatory comment) | No aplica en Zig: las estructuras mutan in-place y no existe variante inmutable. / Not applicable in Zig: structures mutate in-place, no immutable variant. |
| `BinaryTree` — Crear vacío / Create empty | Sí / Yes | `test/data_structures_advanced_test.zig:175` (`test "BinaryTree: create empty"`) | `isEmpty() == true`, `len() == 0`, `contains(50) == false`. |
| `BinaryTree` — Insertar la raíz / Insert the root | Sí / Yes | `test/data_structures_advanced_test.zig:184` (`test "BinaryTree: insert the root"`) | Inserta 50; `len() == 1`, `isEmpty() == false`, `contains(50) == true`. |
| `BinaryTree` — Insertar menor y mayor / Insert lower and higher | Sí / Yes | `test/data_structures_advanced_test.zig:194` (`test "BinaryTree: insert lower and higher"`) | Inserta 50, 30, 70; `len() == 3`, pertenencia comprobada para los tres. / Inserts 50, 30, 70; `len() == 3`, membership verified for all three. |
| `BinaryTree` — Ramas de varios niveles / Multilevel branches | Sí / Yes | `test/data_structures_advanced_test.zig:204` (`test "BinaryTree: multilevel branches"`) | Inserta 50, 30, 70, 20, 40; `len() == 5`, verifica presencia de todos los nodos. / Inserts 50, 30, 70, 20, 40; `len() == 5`, verifies presence of all nodes. |
| `BinaryTree` — Valor ausente en árbol no vacío / Missing value in nonempty tree | Sí / Yes | `test/data_structures_advanced_test.zig:214` (`test "BinaryTree: missing value in nonempty tree"`) | Consulta `contains(99) == false`; tamaño 1 y `contains(50)` intactos. / Query `contains(99) == false`; size 1 and `contains(50)` intact. |
| `BinaryTree` — Duplicado idempotente / Idempotent duplicate | Sí / Yes | `test/data_structures_advanced_test.zig:224` (`test "BinaryTree: idempotent duplicate"`) | Reinserta 30; éxito en inserción, `len() == 3` sin duplicación de nodos. / Re-inserts 30; insert succeeds, `len() == 3` without node duplication. |
| `BinaryTree` — Inserciones ordenadas / Ordered insertions | Sí / Yes | `test/data_structures_advanced_test.zig:234` (`test "BinaryTree: ordered insertions"`) | Inserta 20, 30, 40, 50, 70; `len() == 5`, todos presentes y 99 ausente. / Inserts 20, 30, 40, 50, 70; `len() == 5`, all present and 99 absent. |
| `Graph` — Crear vacío / Create empty | Sí / Yes | `test/data_structures_advanced_test.zig:247` (`test "Graph: create empty"`) | `isEmpty() == true`, `vertexCount() == 0`, `edgeCount() == 0`, `hasEdge(10,30) == false`, `getNeighbors(10) == null`. |
| `Graph` — Vértice aislado / Isolated vertex | Sí / Yes | `test/data_structures_advanced_test.zig:257` (`test "Graph: isolated vertex"`) | `addVertex(10)` tiene éxito; 1 vértice, 0 aristas, vecinos vacíos `&.{}` (no `null`). / `addVertex(10)` succeeds; 1 vertex, 0 edges, empty neighbours `&.{}` (not `null`). |
| `Graph` — Etiquetas no consecutivas y arista dirigida / Nonconsecutive labels and directed edge | Sí / Yes | `test/data_structures_advanced_test.zig:267` (`test "Graph: nonconsecutive labels and directed edge"`) | Vértices 10, 70; arista dirigida `(10, 70)` presente y `(70, 10)` ausente; 2 vértices, 1 arista. / Vertices 10, 70; forward edge `(10, 70)` present, reverse absent; 2 vertices, 1 edge. |
| `Graph` — Vértice duplicado conserva adyacencia / Duplicate vertex preserves adjacency | Sí / Yes | `test/data_structures_advanced_test.zig:278` (`test "Graph: duplicate vertex preserves adjacency"`) | Re-registrar 10 tiene éxito, conserva 2 vértices, 1 arista y vecinos `[30]`. / Re-registering 10 succeeds, preserves 2 vertices, 1 edge, and neighbours `[30]`. |
| `Graph` — Arista duplicada / Duplicate edge | Sí / Yes | `test/data_structures_advanced_test.zig:289` (`test "Graph: duplicate edge"`) | Segunda llamada `addEdge(10, 30)` tiene éxito pero no incrementa el contador (2 vértices, 1 arista). / Second call `addEdge(10, 30)` succeeds without incrementing counter (2 vertices, 1 edge). |
| `Graph` — Extremo inexistente sin mutación / Missing endpoint without mutation | Sí / Yes | `test/data_structures_advanced_test.zig:300` (`test "Graph: missing endpoint without mutation"`) | Intentos con vértices inexistentes (98, 99) fallan (`false`); contadores y adyacencias intactos. / Attempts with absent vertices (98, 99) fail (`false`); counters and adjacencies unchanged. |
| `Graph` — Vecinos ordenados y contadores / Sorted neighbours and counts | Sí / Yes | `test/data_structures_advanced_test.zig:323` (`test "Graph: sorted neighbours and counts"`) | Aristas añadidas en desorden resultan en vecinos de 10 ordenados `[30, 50, 70]`; 4 vértices, 4 aristas. / Edges added out of order yield sorted neighbours for 10 `[30, 50, 70]`; 4 vertices, 4 edges. |
| `Graph` — Consulta de arista ausente / Missing-edge query | Sí / Yes | `test/data_structures_advanced_test.zig:339` (`test "Graph: missing-edge query"`) | Vértices 10 y 30 sin arista; `hasEdge(10, 30) == false`, `vertexCount() == 2`, `edgeCount() == 0`. / Vertices 10 and 30 without edge; `hasEdge(10, 30) == false`, `vertexCount() == 2`, `edgeCount() == 0`. |
| `Graph` — Vecinos de vértice inexistente / Neighbours of missing vertex | Sí / Yes | `test/data_structures_advanced_test.zig:349` (`test "Graph: neighbours of missing vertex"`) | `getNeighbors(99) == null`, mientras que vecinos de 10 siguen vacíos `&.{}`. / `getNeighbors(99) == null`, while neighbours of 10 remain empty `&.{}`. |
| `Graph` — Bucle y duplicado / Self-loop and duplicate | Sí / Yes | `test/data_structures_advanced_test.zig:359` (`test "Graph: self-loop and duplicate"`) | Bucle `(10, 10)` admitido y duplicado idempotente; 1 vértice, 1 arista, vecinos `[10]`. / Self-loop `(10, 10)` accepted, duplicate idempotent; 1 vertex, 1 edge, neighbours `[10]`. |
| `Graph` — Aislamiento del resultado de vecinos / Neighbour-result isolation | Sí / Yes | `test/data_structures_advanced_test.zig:371` (`test "Graph: neighbour-result isolation"`) | Modificar la copia devuelta o añadir nuevas aristas no altera el slice previamente obtenido. / Mutating returned copy or adding edges does not alter previously returned slice. |

> **Mapeo de agrupación / Grouping mapping:** `unidad/variante → casos aplicables → grupo lógico → archivo/suite → runner`:
> - `TreeNode`: 6 casos de especificación (5 aplicables + 1 inmutable omitido) → 5 bloques `test` en `test/data_structures_advanced_test.zig` → `zig build test --summary all`.
> - `BinaryTree`: 7 casos de especificación → 7 bloques `test` en `test/data_structures_advanced_test.zig` → `zig build test --summary all`.
> - `Graph`: 11 casos de especificación → 11 bloques `test` en `test/data_structures_advanced_test.zig` → `zig build test --summary all`.

---

## ⚠️ Limitaciones conocidas / Known limitations

| Limitación / Limitation | Impacto / Impact | Alternativa o plan / Workaround or plan |
|---|---|---|
| Claves y etiquetas fijas a `i32` / Keys and labels fixed to `i32` | El módulo opera exclusivamente con identificadores y valores numéricos `i32` / Module operates exclusively on `i32` numeric values and identifiers | Fijado por el contrato de la fase y la especificación; suficiente para la validación algorítmica. / Fixed by phase contract and specification; sufficient for algorithmic validation. |
| Destrucción de memoria delegada al ciclo de vida del Allocator / Memory reclamation delegated to Allocator lifecycle | Las estructuras no declaran un método contractual `deinit` / Structures do not expose a contractual `deinit` method | La suite de pruebas usa `std.heap.ArenaAllocator` para liberar limpiamente todos los nodos asignados al finalizar cada escenario. / Test suite uses `std.heap.ArenaAllocator` to cleanly reclaim all allocated nodes at the end of each scenario. |
| Ausencia de sincronización / No synchronization primitives | Las estructuras no son seguras para acceso concurrente multihilo / Structures are not thread-safe for concurrent access | Fuera del alcance de la fase de algoritmos secuenciales puros; la sincronización corresponde al llamante. / Out of scope for pure sequential algorithms phase; caller must synchronize. |

---

## 📝 Notas de implementación / Implementation Notes

### 🧱 Nodos con valor embebido y ADT independientes / Embedded-value nodes and independent ADTs

`TreeNode` y `GraphNode` declaran su valor directamente como `value: i32` en lugar de requerir una jerarquía de herencia formal. Esto modela con fidelidad la base `Node(value)` en Zig, donde las estructuras no soportan polimorfismo por herencia. `BinaryTree` y `Graph` son completamente independientes: ninguna envuelve a la otra ni delega en estructuras previas.

`TreeNode` and `GraphNode` declare their value directly as `value: i32` rather than requiring a formal inheritance hierarchy. This faithfully models base `Node(value)` in Zig, where structs do not support inheritance polymorphism. `BinaryTree` and `Graph` are entirely independent: neither wraps the other nor delegates to previous structures.

### 💾 Gestión manual de memoria y aislamiento en pruebas / Manual memory management & test isolation

Todas las reservas de celdas (`TreeNode`, `GraphNode`, `NeighborNode`) y buffers de adyacencia (`getNeighbors`) se efectúan a través de `allocator.create` y `allocator.alloc`. Puesto que el contrato de la especificación no define un método `deinit`, cada prueba unitaria instancia un `std.heap.ArenaAllocator` respaldado por `std.testing.allocator`, garantizando que la memoria acumulada durante el escenario se libere en bloque al salir del ámbito (`defer arena.deinit()`).

All allocations of cells (`TreeNode`, `GraphNode`, `NeighborNode`) and adjacency buffers (`getNeighbors`) occur through `allocator.create` and `allocator.alloc`. Because the specification contract does not define a `deinit` method, each unit test instantiates a `std.heap.ArenaAllocator` backed by `std.testing.allocator`, ensuring that accumulated memory during the scenario is released in bulk on scope exit (`defer arena.deinit()`).

### 🔁 Recorridos iterativos y búsqueda manual / Iterative traversals and manual search

Tanto la inserción y búsqueda en el árbol binario (`insert`, `contains`) como la búsqueda de vértices (`findVertex`) y adyacencias (`findNeighbor`) se implementan mediante bucles iterativos `while (current) |node|`. No se usan funciones de ordenamiento de la biblioteca estándar; la lista de adyacencias de cada vértice se mantiene ordenada ascendentemente en tiempo de inserción en $O(d(u))$.

Both BST insertion and lookup (`insert`, `contains`) and vertex/adjacency lookups (`findVertex`, `findNeighbor`) are implemented via iterative `while (current) |node|` loops. No standard-library sorting functions are used; each vertex's adjacency list is maintained in ascending order at insertion time in $O(d(u))$.

### 🧪 Organización de la suite / Suite organization

La suite define 23 bloques de pruebas independientes estructurados con helpers de verificación (`check_int`, `check_count`, `check_flag`, `check_absent`, `check_neighbors`, `check_failure`, `check_counts`) que imprimen diagnósticos enriquecidos antes de propagar errores. Se utilizan constantes descriptivas (`root_key`, `label_ten`, `absent_label`) para garantizar claridad y trazabilidad directa con los casos de la especificación.

The suite defines 23 independent test blocks structured with verification helpers (`check_int`, `check_count`, `check_flag`, `check_absent`, `check_neighbors`, `check_failure`, `check_counts`) that print rich diagnostic messages before propagating errors. Descriptive constants (`root_key`, `label_ten`, `absent_label`) are used to ensure clarity and direct traceability with the specification cases.

### 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el repositorio principal para consultar las demás versiones.

This project is also implemented in other languages. Explore the main repository to see the other versions.

---

## 🔍 Checklist de validación / Validation checklist

- [x] La suite nativa se ejecutó y su salida real está copiada en este README.
- [x] Cada caso de la especificación tiene su fila en _Cobertura de pruebas_ (o `Omitido` con razón).
- [x] Cada desviación del pseudocódigo o de la ubicación esperada está en _Adaptaciones idiomáticas_.
- [x] Cada operación con fallo posible está en _Indicadores de fallo_.
- [x] No hay rutas absolutas del autor, credenciales ni salidas inventadas.
- [x] Los enlaces relativos resuelven dentro del repositorio y el documento es bilingüe.
- [x] Ninguna sección repite lo que ya dice la especificación.

---

## 📚 Referencias / References

| Tipo / Kind | Referencia / Reference |
|---|---|
| Especificación / Specification | [`07_Data_Structures_Advanced.md`](../../../../docs/core/algorithms/07_Data_Structures_Advanced.md) |
| Primera base del lenguaje / First language reference | `data_structures_basics` — [`../data_structures_basics/README.md`](../data_structures_basics/README.md) |
| Segunda base del lenguaje / Second language reference | `numbers` — [`../../foundations/numbers/README.md`](../../foundations/numbers/README.md) |
| Guía de inicialización / Initialisation guide | [`core/00_Project_Initialization_Guide.md`](../../../../docs/core/00_Project_Initialization_Guide.md) |
| Adaptaciones idiomáticas / Idiomatic adaptations | [`AGENT_Template.md`](../../../../docs/AGENT_Template.md) |
| Validación de la documentación / Documentation validation | [`WORKFLOW.md`](../../../../docs/WORKFLOW.md) |
| Documentación oficial del lenguaje / Language official docs | [Zig Language Reference](https://ziglang.org/documentation/0.17.1/) |

---

*[← Volver a Algoritmos Puros](../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
