# Data Structures Basics — Zig

Implementación de la especificación [06_Data_Structures_Basics](https://yorche3.github.io/programming_languages/core/algorithms/06_Data_Structures_Basics/) en **Zig**, con una estructura tipo librería (`src/` + `test/`), el gestor de construcción `build.zig` y el framework de pruebas integrado (`std.testing` + `zig build test --summary all`).

Define un único tipo de celda enlazada, `Node`, y tres tipos de datos abstractos independientes construidos desde cero sobre él: `LinkedList`, `Stack` y `Queue`. Cada estructura guarda sus propios punteros y su contador; ninguna usa colecciones de la biblioteca estándar ni delega operaciones en `LinkedList`.

Implementation of the [06_Data_Structures_Basics](https://yorche3.github.io/programming_languages/core/algorithms/06_Data_Structures_Basics/) specification in **Zig**, using a library-style layout (`src/` + `test/`), the `build.zig` build manager, and the built-in test framework (`std.testing` + `zig build test --summary all`).

It declares a single linked-cell type, `Node`, and three independent abstract data types built from scratch on top of it: `LinkedList`, `Stack`, and `Queue`. Each structure keeps its own pointers and counter; none of them uses standard-library collections or delegates operations to `LinkedList`.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo / Directory | Propósito / Purpose |
|---|---|
| [`build.zig`](build.zig) | Declara el módulo de producción, publica la librería estática y registra el paso `test`. / Declares the production module, publishes the static library, and registers the `test` step. |
| [`build.zig.zon`](build.zig.zon) | Manifiesto del paquete: nombre, fingerprint y `minimum_zig_version = "0.17.0"`. / Package manifest: name, fingerprint, and `minimum_zig_version = "0.17.0"`. |
| [`src/data_structures_basics.zig`](src/data_structures_basics.zig) | `Node`, `LinkedList`, `Stack` y `Queue`. / `Node`, `LinkedList`, `Stack`, and `Queue`. |
| [`test/data_structures_basics_test.zig`](test/data_structures_basics_test.zig) | Suite integrada: 5 tests con los 15 casos de la especificación (57 aserciones). / Integrated suite: 5 tests covering the specification's 15 cases (57 assertions). |
| [`.gitignore`](.gitignore) | Ignora cachés (`zig-out/`, `.zig-cache/`), binarios y artefactos nativos. / Ignores caches (`zig-out/`, `.zig-cache/`), binaries, and native artifacts. |
| `README.md` | Este documento. / This document. |

**Estructura de directorios / Directory structure:**

```text
data_structures_basics/
├── build.zig
├── build.zig.zon
├── src/
│   └── data_structures_basics.zig        # Node, LinkedList, Stack y Queue
├── test/
│   └── data_structures_basics_test.zig   # 5 tests × 15 casos
├── .gitignore
└── README.md
```

> **Nota de desviación / Deviation note:** La especificación propone `src/data_structures_basics.ext`, `test/data_structures_basics_test.ext` y `test/run_tests.ext`. Se conservan los dos primeros con la extensión `.zig` y **no se añade** `run_tests.zig`: el runner es el paso `test` de `build.zig` (`zig build test --summary all`), igual que en los demás módulos tipo librería del repositorio Zig.
>
> **Deviation note:** The specification proposes `src/data_structures_basics.ext`, `test/data_structures_basics_test.ext`, and `test/run_tests.ext`. The first two are kept with the `.zig` extension and `run_tests.zig` is **not** added: the runner is `build.zig`'s `test` step (`zig build test --summary all`), as in the other library-style modules of the Zig repository.

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El módulo se creó como una librería Zig con la forma que ya usan `core/foundations/numbers/` y `core/algorithms/naive_sort/`: código de producción en `src/`, suite en `test/` y `build.zig` como orquestador, sin dependencias externas. El commit de andamiaje añadió el juego de archivos que produce `zig init` (`build.zig`, `build.zig.zon`, `src/main.zig`, `src/root.zig`); después se sustituyeron los archivos genéricos por el módulo real y su suite, y `build.zig` se reescribió para declarar el módulo, publicarlo como librería estática y conectar el módulo `data_structures_basics` con los tests mediante `addImport`. Ninguna operación delega en la biblioteca estándar: ni `std.ArrayList`, ni `std.DoublyLinkedList`, ni `std.LinkedList`.

**EN:** The module was created as a Zig library with the shape already used by `core/foundations/numbers/` and `core/algorithms/naive_sort/`: production code under `src/`, suite under `test/`, and `build.zig` as the orchestrator, with no external dependencies. The scaffold commit added the file set produced by `zig init` (`build.zig`, `build.zig.zon`, `src/main.zig`, `src/root.zig`); the generic files were then replaced by the real module and its suite, and `build.zig` was rewritten to declare the module, publish it as a static library, and connect the `data_structures_basics` module to the tests through `addImport`. No operation delegates to the standard library: neither `std.ArrayList`, nor `std.DoublyLinkedList`, nor `std.LinkedList`.

### Inicialización / Initialization

```bash
cd zig/core/algorithms/data_structures_basics
zig init
```

Después se eliminan `src/main.zig` y `src/root.zig` y se escriben el módulo, la suite y el `build.zig` definitivo.

Then `src/main.zig` and `src/root.zig` are removed, and the module, the suite, and the final `build.zig` are written.

---

## 📄 Configuración clave / Key Configuration

### `build.zig`

**ES:** El script declara el módulo de producción (`src/data_structures_basics.zig`), lo publica como librería estática, declara el módulo de tests (`test/data_structures_basics_test.zig`) con `test_module.addImport("data_structures_basics", data_structures_basics_module)` y registra el paso `test` con `b.addTest` y `b.step`.

**EN:** The script declares the production module (`src/data_structures_basics.zig`), publishes it as a static library, declares the test module (`test/data_structures_basics_test.zig`) with `test_module.addImport("data_structures_basics", data_structures_basics_module)`, and registers the `test` step with `b.addTest` and `b.step`.

```zig
const data_structures_basics_module = b.createModule(.{
    .root_source_file = b.path("src/data_structures_basics.zig"),
    .target = target,
    .optimize = optimize,
});

const test_module = b.createModule(.{
    .root_source_file = b.path("test/data_structures_basics_test.zig"),
    .target = target,
    .optimize = optimize,
});
test_module.addImport("data_structures_basics", data_structures_basics_module);
```

### `build.zig.zon`

**ES:** Manifiesto del paquete sin dependencias (`.dependencies = .{}`). Declara el nombre, una versión `0.0.0` (el paquete no se publica), el fingerprint que generó la herramienta y `minimum_zig_version = "0.17.0"`, que es la versión con la que se compila y se prueba el módulo.

**EN:** Package manifest with no dependencies (`.dependencies = .{}`). It declares the name, a `0.0.0` version (the package is not published), the fingerprint generated by the tool, and `minimum_zig_version = "0.17.0"`, the version the module is built and tested with.

### `.gitignore`

```text
zig-out/
.zig-cache/
zig-cache/
data_structures_basics
data_structures_basics.exe
*.o
*.a
*.so
*.dylib
*.dll
```

---

## 🚀 Compilación y ejecución / Build & Run

### Requisitos / Requirements

- **Zig 0.17.0**.
- Framework de testing integrado (`std.testing`); no se instala nada.

Verificar:

```bash
zig version
```

Salida verificada:

```text
0.17.0
```

### Compilar y ejecutar las pruebas / Build & run tests

```bash
cd zig/core/algorithms/data_structures_basics
zig build
zig build test --summary all
```

**Salida real / Actual output:**

```text
$ zig build --summary all
Build Summary: 3/3 steps succeeded
install success
└─ install data_structures_basics success
   └─ compile lib data_structures_basics debug native success 70ms MaxRSS:88M
```

```text
$ zig build test --summary all
Build Summary: 3/3 steps succeeded; 5/5 tests passed
test success
└─ run test 5 pass (5 total) 5ms MaxRSS:4M
   └─ compile test debug native success 521ms MaxRSS:149M
```

**ES:** El resumen muestra cinco tests Zig porque cada uno agrupa los pasos del escenario de una estructura —`Node` usa dos celdas y un enlace, y cada ADT recorre sus casos sobre la misma instancia—; en total la suite cubre los 15 casos de la especificación con 57 aserciones y no hay fallos. `zig build test` no informa de fugas de memoria: los escenarios usan `std.testing.allocator` y cada uno cierra con `deinit`, así que una celda sin liberar haría fallar el test.

**EN:** The summary shows five Zig tests because each one groups the scenario steps of a structure —`Node` uses two cells and one link, and each ADT walks its cases over the same instance—; the suite covers the specification's 15 cases with 57 assertions and no failures. `zig build test` reports no memory leaks: scenarios use `std.testing.allocator` and each one closes with `deinit`, so an unreleased cell would fail the test.

**Formato / Formatting:**

```bash
zig fmt --check src test
```

**ES:** `zig fmt --check` no imprime nada cuando todo está formateado y termina con código `0` (verificado en este sprint sobre `src/` y `test/`). `zig build` tampoco emite advertencias.

**EN:** `zig fmt --check` prints nothing when everything is formatted and exits with code `0` (verified in this sprint over `src/` and `test/`). `zig build` emits no warnings either.

---

## 🧠 Algoritmos y operaciones / Algorithms & Operations

| Operación / Operation | Entrada → salida / Input → output | Complejidad / Complexity | Notas / Notes |
|---|---|---|---|
| `Node.init(value)` | `i32 → Node` | $O(1)$ | Asigna el valor y deja el enlace `null`. Es el `init` de la especificación. / Sets the value and leaves the link `null`. This is the specification's `init`. |
| `Node.valueOf()` | `*const Node → i32` | $O(1)$ | Valor de la celda; no muta. / Cell value; does not mutate. |
| `Node.nextOf()` | `*const Node → ?*Node` | $O(1)$ | Enlace siguiente o `null`. / Next link or `null`. |
| `Node.next = nodo` | `*Node → void` | $O(1)$ | El `set_next(next)` del contrato: el enlace se reengancha escribiendo el campo. / The contract's `set_next(next)`: the link is rewired by writing the field. |
| `LinkedList.init(allocator)` | `Allocator → LinkedList` | $O(1)$ | Cabeza, cola y contador a cero. / Head, tail, and counter at zero. |
| `LinkedList.deinit()` | `*LinkedList → void` | $O(n)$ | Recorre la cadena y libera cada celda. / Walks the chain and frees every cell. |
| `LinkedList.headValue()` | `*const LinkedList → i32` | $O(1)$ | Valor de la cabeza o `-1` si está vacía. / Head value or `-1` when empty. |
| `LinkedList.isEmpty()` | `*const LinkedList → bool` | $O(1)$ | `true` solo si no hay nodos. / `true` only when there are no nodes. |
| `LinkedList.len()` | `*const LinkedList → usize` | $O(1)$ | Número de nodos, sobre el contador. / Node count, read from the counter. |
| `LinkedList.insertHead(value)` | `i32 → !void` | $O(1)$ | Reserva la celda y la enlaza delante de la cabeza. / Allocates the cell and links it in front of the head. |
| `LinkedList.insertTail(value)` | `i32 → !void` | $O(1)$ | Escribe en `tail` sin recorrer la lista. / Writes through `tail` without walking the list. |
| `LinkedList.remove(value)` | `i32 → bool` | $O(n)$ | Borra la primera aparición; reengancha `tail` si era la cola. / Deletes the first occurrence; rewires `tail` when it was the tail. |
| `Stack.init(allocator)` / `deinit()` | `Allocator → Stack` / `*Stack → void` | $O(1)$ / $O(n)$ | Pila vacía; `deinit` suelta la cadena. / Empty stack; `deinit` releases the chain. |
| `Stack.isEmpty()` / `len()` | `*const Stack → bool` / `usize` | $O(1)$ | Estado y tamaño. / State and size. |
| `Stack.push(value)` | `i32 → !void` | $O(1)$ | Apila sobre `top`. / Pushes on top of `top`. |
| `Stack.pop()` | `*Stack → i32` | $O(1)$ | Extrae el tope en orden LIFO, o `-1` si está vacía. / Pops the top in LIFO order, or `-1` when empty. |
| `Stack.peek()` | `*const Stack → i32` | $O(1)$ | Observa el tope sin extraerlo, o `-1` si está vacía. / Inspects the top without popping it, or `-1` when empty. |
| `Queue.init(allocator)` / `deinit()` | `Allocator → Queue` / `*Queue → void` | $O(1)$ / $O(n)$ | Cola vacía; `deinit` suelta la cadena. / Empty queue; `deinit` releases the chain. |
| `Queue.isEmpty()` / `len()` | `*const Queue → bool` / `usize` | $O(1)$ | Estado y tamaño. / State and size. |
| `Queue.enqueue(value)` | `i32 → !void` | $O(1)$ | Escribe en `rear` sin recorrer la cola. / Writes through `rear` without walking the queue. |
| `Queue.dequeue()` | `*Queue → i32` | $O(1)$ | Extrae el frente en orden FIFO, o `-1` si está vacía; al vaciarse deja `rear` en `null`. / Dequeues the front in FIFO order, or `-1` when empty; it resets `rear` to `null` when the queue empties. |
| `Queue.peek()` | `*const Queue → i32` | $O(1)$ | Observa el frente sin extraerlo, o `-1` si está vacía. / Inspects the front without dequeuing it, or `-1` when empty. |

---

## 🧩 Decisiones de diseño / Design decisions

| Decisión / Decision | Alternativa considerada / Alternative | Razón / Reason |
|---|---|---|
| Cada celda se reserva en el montón con el `Allocator` que recibe `init` y se libera en `deinit` | Guardar los nodos por valor dentro de la estructura | Zig no tiene recolector ni destructor implícito, y una estructura `struct` se copia al asignarla: los nodos incrustados cambiarían de dirección con la copia y `?*Node` dejaría de señalar el mismo nodo lógico. Reservar cada celda e identificarla por puntero es lo que da sentido al enlace del contrato. |
| `LinkedList` guarda `tail` y `Queue` guarda `rear` | Recorrer la cadena en cada inserción al final | La especificación pide $O(1)$ en `insert_tail` y `enqueue`; en Zig mantener el puntero al último nodo no exige `unsafe` ni bloques de memoria compartida. |
| `init` recibe el `Allocator` y lo guarda en la estructura | Recibir el `Allocator` en cada operación | Cada estructura tiene un único dueño de su memoria: `deinit` no depende de que el llamante recuerde qué allocator usó. |
| `isEmpty` mira el puntero (`head`, `top`, `front`) | `count == 0`, como el pseudocódigo | El efecto observable es idéntico mientras se mantengan los invariantes: cada inserción y cada borrado ajustan el contador y el puntero a la vez, y el puntero es el estado mínimo que decide si una operación puede devolver un valor. |
| Una instancia por ADT por test, con pasos sucesivos | Un test por operación, reiniciando la estructura | La especificación pide pasos sucesivos sobre el mismo estado lógico, sin reiniciar el escenario. |
| La suite usa `std.testing.allocator` y cierra cada escenario con `deinit` | Usar `std.heap.page_allocator` | El allocator de pruebas detecta fugas: si `deinit` olvidara una celda, el test fallaría en lugar de terminar en verde. |
| `Node` conserva el campo público `value` y expone `valueOf()` | Renombrar el campo o el método | El borrador declaraba el campo `value` y un método `value()`; Zig rechaza dos miembros con el mismo nombre en una estructura. |

---

## 🔀 Adaptaciones idiomáticas / Idiomatic adaptations

| Especificación / Specification | Adaptación / Adaptation | Justificación / Justification |
|---|---|---|
| `Node.get_value()` | `Node.valueOf()` | El borrador declaraba el campo `value` **y** un método `value()`; Zig lo rechaza con `error: duplicate struct member name 'value'`, así que el lector del valor se llama `valueOf`, en paralelo a `nextOf`. |
| `Node.get_next()` | `Node.nextOf()` | Mismo motivo que `valueOf`: el enlace se lee con `nextOf()` y se escribe en el campo `next`. |
| `Node.set_next(next)` devuelve el nodo | Asignación directa al campo: `node.next = otro_nodo` | El campo `next` es público y de tipo `?*Node`; un método `setNext` solo repetiría esa asignación, y el borrador del módulo no lo declara. |
| `Node.init(value)` y `ADT.init()` sin argumentos | `Node.init(value)` y `ADT.init(allocator)` | En Zig toda reserva de memoria es explícita: `LinkedList`, `Stack` y `Queue` necesitan el `Allocator` para reservar sus celdas, y lo guardan para `deinit`. |
| Sin operación de destrucción en el pseudocódigo | `deinit()` en las tres estructuras | Zig libera la memoria del montón solo si el código lo pide; sin `deinit` la cadena quedaría reservada hasta el final del proceso. |
| `LinkedList.get_head()` | `LinkedList.headValue()` | Nombre que fija el borrador del módulo, en `camelCase` como el resto de la API (`insertHead`, `isEmpty`). |
| `ADT.size()` | `ADT.len()` | Convención de Zig (`len` es el nombre que usa la biblioteca estándar para el número de elementos); el contrato es el mismo. |
| `LinkedList.delete(value)` | `LinkedList.remove(value)` | Nombre que fija el borrador del módulo; describe "quitar la primera aparición" sin ambigüedad. |
| Inserciones sin resultado de fallo | `insertHead`, `insertTail`, `push` y `enqueue` devuelven `!void` | Zig no tiene excepciones: el agotamiento de memoria viaja por el *error union*. La especificación dice que no hay fallo por límite de capacidad y eso se conserva: el error solo aparece si el sistema no puede reservar. |
| Ausencia de enlace con la representación nativa | `null` dentro de `?*Node` | La representación nativa de Zig para un enlace ausente; `null` no se usa para valores ni para indicadores de fallo. |
| `test/run_tests.ext` | Paso `test` de `build.zig` | El runner lo genera la herramienta de construcción; no hay script propio, igual que en `naive_sort` y en `core/foundations/numbers/`. |
| Valores de prueba enteros positivos | `5`, `10`, `20`, `30`, `40` y `99` para el valor ausente | Evitan colisionar con el indicador `-1`, como pide la especificación. |

---

## 🚨 Indicadores de fallo / Failure indicators

| Operación / Operation | Situación de fallo / Failure situation | Indicador / Indicator | Ejemplo / Example |
|---|---|---|---|
| `LinkedList.headValue()` | Lista vacía / Empty list | `-1` | `list.headValue() == -1` tras `LinkedList.init(...)` |
| `LinkedList.remove(value)` | Valor no presente / Value absent | `false` | `list.remove(99) == false` |
| `Stack.peek()` | Pila vacía / Empty stack | `-1` | `stack.peek() == -1` |
| `Stack.pop()` | Pila vacía / Empty stack | `-1` | `stack.pop() == -1` |
| `Queue.peek()` | Cola vacía / Empty queue | `-1` | `queue.peek() == -1` |
| `Queue.dequeue()` | Cola vacía / Empty queue | `-1` | `queue.dequeue() == -1` |
| `Node.nextOf()` | Celda sin enlace / Cell without a link | `null` (dentro de `?*Node`) | `node.nextOf() == null` |
| `insertHead`, `insertTail`, `push`, `enqueue` | El sistema no puede reservar memoria / The system cannot allocate memory | Error en el *error union* (`!void`) | `try list.insertHead(5);` |
| Entrada nula o inválida / Null or invalid input | No aplica: el contrato recibe `i32` y no admite entrada nula / Not applicable: the contract takes `i32` and admits no null input | `No aplica / Not applicable` | — |

---

## ✅ Cobertura de pruebas / Test coverage

| Caso de la especificación / Specification case | Cubierto / Covered | Prueba / Test | Notas / Notes |
|---|---|:--:|---|
| `Node` — Inicializar y observar valor/enlace / Initialize and observe value/link | Sí / Yes | `test/data_structures_basics_test.zig:46` (`test "Node"`) | Valores `10` y `20`: `valueOf() == 10` y `nextOf() == null` tras `init`. / Values `10` and `20`: `valueOf() == 10` and `nextOf() == null` after `init`. |
| `Node` — Inicializar otro nodo, enlazar y recorrer / Initialize another node, link and traverse | Sí / Yes | `test/data_structures_basics_test.zig:46` (`test "Node"`) | Enlaza con `first.next = &linked` y comprueba `first.nextOf().?.valueOf() == 20` y el enlace ausente del segundo. / Links with `first.next = &linked` and checks `first.nextOf().?.valueOf() == 20` and the second node's absent link. |
| `LinkedList` — Estado vacío / Empty state | Sí / Yes | `test/data_structures_basics_test.zig:62` (`test "LinkedList"`) | `is_empty() == true`, `len() == 0`, `headValue() == -1`. |
| `LinkedList` — Insertar por ambos extremos / Insert at both ends | Sí / Yes | `test/data_structures_basics_test.zig:62` (`test "LinkedList"`) | `insertTail(10)`, `insertTail(20)`, `insertHead(5)`, `insertTail(10)`: `len() == 4` y `headValue() == 5`. El orden completo de la cadena se fija con la secuencia de borrados de la fila siguiente: `get_head()` devuelve el valor de la cabeza y no el nodo, y las aserciones no leen campos internos. / `insertTail(10)`, `insertTail(20)`, `insertHead(5)`, `insertTail(10)`: `len() == 4` and `headValue() == 5`. The full chain order is pinned by the deletion sequence in the next row: `get_head()` returns the head value rather than the node, and assertions do not read internal fields. |
| `LinkedList` — Eliminar primera aparición / Delete first occurrence | Sí / Yes | `test/data_structures_basics_test.zig:62` (`test "LinkedList"`) | `remove(10) == true`, `len() == 3` y `headValue() == 5`; al borrar la cola, `remove(20)` deja `headValue() == 10`, lo que confirma el orden `5, 20, 10`. / `remove(10) == true`, `len() == 3`, and `headValue() == 5`; removing the tail with `remove(20)` leaves `headValue() == 10`, confirming the `5, 20, 10` order. |
| `LinkedList` — Valor ausente / Absent value | Sí / Yes | `test/data_structures_basics_test.zig:62` (`test "LinkedList"`) | `remove(99) == false` y `len()`/`headValue()` no cambian. / `remove(99) == false` and `len()`/`headValue()` stay unchanged. |
| `LinkedList` — Vaciar / Empty the list | Sí / Yes | `test/data_structures_basics_test.zig:62` (`test "LinkedList"`) | `remove(5)`, `remove(20)` y `remove(10)` devuelven éxito; al final `isEmpty() == true`, `len() == 0`, `headValue() == -1` y `remove(10)` vuelve a dar `false`. / `remove(5)`, `remove(20)`, and `remove(10)` succeed; at the end `isEmpty() == true`, `len() == 0`, `headValue() == -1`, and `remove(10)` returns `false` again. |
| `Stack` — Estado vacío y extracción fallida / Empty state and failed removal | Sí / Yes | `test/data_structures_basics_test.zig:114` (`test "Stack"`) | `isEmpty() == true`, `len() == 0`, `peek() == -1`, `pop() == -1`. |
| `Stack` — LIFO y `peek` no mutante / LIFO and non-mutating `peek` | Sí / Yes | `test/data_structures_basics_test.zig:114` (`test "Stack"`) | Apila `10`, `20`, `30`; `peek() == 30` sin cambiar `len() == 3`. / Pushes `10`, `20`, `30`; `peek() == 30` without changing `len() == 3`. |
| `Stack` — Extracción y reutilización / Removal and reuse | Sí / Yes | `test/data_structures_basics_test.zig:114` (`test "Stack"`) | `pop()`, `push(40)` y tres `pop()` devuelven `30`, `40`, `20`, `10`; después `isEmpty() == true` y `len() == 0`. / `pop()`, `push(40)`, and three more `pop()` calls return `30`, `40`, `20`, `10`; then `isEmpty() == true` and `len() == 0`. |
| `Stack` — Vacío tras extracción / Empty after removal | Sí / Yes | `test/data_structures_basics_test.zig:114` (`test "Stack"`) | `pop()` devuelve `-1` y `isEmpty()` sigue siendo `true`. / `pop()` returns `-1` and `isEmpty()` stays `true`. |
| `Queue` — Estado vacío y extracción fallida / Empty state and failed removal | Sí / Yes | `test/data_structures_basics_test.zig:140` (`test "Queue"`) | `isEmpty() == true`, `len() == 0`, `peek() == -1`, `dequeue() == -1`. |
| `Queue` — FIFO y `peek` no mutante / FIFO and non-mutating `peek` | Sí / Yes | `test/data_structures_basics_test.zig:140` (`test "Queue"`) | Encola `10`, `20`, `30`; `peek() == 10` sin cambiar `len() == 3`. / Enqueues `10`, `20`, `30`; `peek() == 10` without changing `len() == 3`. |
| `Queue` — Extracción y reutilización / Removal and reuse | Sí / Yes | `test/data_structures_basics_test.zig:140` (`test "Queue"`) | `dequeue()`, `enqueue(40)` y tres `dequeue()` devuelven `10`, `20`, `30`, `40`; después `isEmpty() == true` y `len() == 0`. / `dequeue()`, `enqueue(40)`, and three more `dequeue()` calls return `10`, `20`, `30`, `40`; then `isEmpty() == true` and `len() == 0`. |
| `Queue` — Vacío tras extracción / Empty after removal | Sí / Yes | `test/data_structures_basics_test.zig:140` (`test "Queue"`) | `dequeue()` devuelve `-1` y `isEmpty()` sigue siendo `true`; el `rear` se reinicia al vaciarse la cola. / `dequeue()` returns `-1` and `isEmpty()` stays `true`; `rear` resets when the queue empties. |
| Extra: reenganche de la cola al borrar el último nodo / Extra: tail rewiring when the last node is deleted | Sí / Yes (no está en la tabla de la especificación / not in the specification's table) | `test/data_structures_basics_test.zig:96` (`test "LinkedList relinks the tail"`) | Cubre la rama `if tail == current: tail = previous` del pseudocódigo: tras borrar la cola, el valor insertado después sigue siendo alcanzable y se puede borrar. / Covers the pseudocode's `if tail == current: tail = previous` branch: after deleting the tail, the value inserted afterwards is still reachable and can be deleted. |

---

## ⚠️ Limitaciones conocidas / Known limitations

| Limitación / Limitation | Impacto / Impact | Alternativa o plan / Workaround or plan |
|---|---|---|
| Valor de celda fijo en `i32` con centinela `-1` / Cell value fixed to `i32` with the `-1` sentinel | Un `-1` almacenado no se distingue del indicador de fallo de `headValue`, `pop`, `peek` y `dequeue` / A stored `-1` cannot be told apart from the failure indicator of `headValue`, `pop`, `peek`, and `dequeue` | Lo fija el contrato de la fase, que prohíbe `Option`/`Result` para los valores enteros; los casos de prueba usan enteros positivos. / Fixed by the phase contract, which forbids `Option`/`Result` for integer values; test cases use positive integers. |
| Sin sincronización / No synchronization | Compartir una estructura entre hilos exige que el llamante aporte el candado / Sharing a structure across threads requires the caller to provide locking | Fuera del alcance de la fase: ningún módulo de algoritmos puros pide concurrencia. / Out of scope for this phase: no pure-algorithms module asks for concurrency. |

---

## 📝 Notas de implementación / Implementation Notes

### 🧱 Celda compartida y ADT independientes / Shared cell and independent ADTs

`Node` es el único tipo de celda enlazada del módulo y lo comparten las tres estructuras. `Stack` guarda `top` y `Queue` guarda `front` y `rear`: ninguna envuelve a `LinkedList` ni reutiliza sus métodos, y no hay tipos de nodo duplicados. Las tres estructuras gestionan su contador y sus punteros directamente, como pide la especificación.

`Node` is the module's single linked-cell type, shared by all three structures. `Stack` keeps `top` and `Queue` keeps `front` and `rear`: neither wraps `LinkedList` nor reuses its methods, and there are no duplicate node types. All three structures manage their counter and their pointers directly, as the specification requires.

### 💾 Memoria: reserva explícita y `deinit` / Memory: explicit allocation and `deinit`

Cada celda se reserva con `allocator.create(Node)` y se suelta con `allocator.destroy(node)`; los `deinit` recorren la cadena y liberan cada celda. `remove` y `pop`/`dequeue` liberan el nodo que desenganchan, así que ninguna operación deja memoria reservada. Zig usa `destroy` (no `free`) porque la celda se reservó como valor único con `create`. La suite comprueba esta propiedad indirectamente: `std.testing.allocator` informa de cualquier reserva sin soltar y el test falla.

Every cell is allocated with `allocator.create(Node)` and released with `allocator.destroy(node)`; the `deinit` functions walk the chain and free each cell. `remove` and `pop`/`dequeue` free the node they unlink, so no operation leaves memory allocated. Zig uses `destroy` (not `free`) because the cell was allocated as a single value with `create`. The suite checks this property indirectly: `std.testing.allocator` reports any unreleased allocation and the test fails.

### 🔁 Iteración, opcionales y errores / Iteration, optionals, and errors

Todos los recorridos son iterativos (`while (current) |node|`), sin recursión ni acumuladores. Zig no tiene `for` de tres cláusulas: los recorridos usan `while` sobre el enlace o `for` sobre rangos. El enlace se desenvuelve con `orelse` (`self.head orelse return -1`) o con captura de opcional (`if (self.tail) |tail|`), que es también la forma de escribir la rama de cola del pseudocódigo sin `if` anidados. No hay excepciones: las inserciones devuelven `!void` y la suite las invoca con `try`.

All traversals are iterative (`while (current) |node|`), with no recursion and no accumulators. Zig has no three-clause `for`: traversals use `while` over the link or `for` over ranges. The link is unwrapped with `orelse` (`self.head orelse return -1`) or with optional capture (`if (self.tail) |tail|`), which is also the way to write the pseudocode's tail branch without nested `if`s. There are no exceptions: insertions return `!void` and the suite calls them with `try`.

### 🧪 Estructura de la suite / Suite structure

La suite declara bloques `test` con `std.testing` y tres helpers compartidos (`check_int`, `check_count`, `check_flag`, en `test/data_structures_basics_test.zig:25`). Cada helper emite el mensaje del contrato con `std.debug.print` antes de devolver el error, porque `std.testing.expectEqual` no admite mensaje: en un fallo se lee, por ejemplo, `Stack pop in LIFO order should be 30, found 10`. Los fixtures (`first_value`, `second_value`…) se declaran como constantes `i32` y cada escenario usa una instancia por ADT con pasos sucesivos, sin reiniciar el estado.

The suite declares `test` blocks with `std.testing` and three shared helpers (`check_int`, `check_count`, `check_flag`, in `test/data_structures_basics_test.zig:25`). Each helper prints the contract message with `std.debug.print` before returning the error, because `std.testing.expectEqual` accepts no message: on failure you read, for example, `Stack pop in LIFO order should be 30, found 10`. Fixtures (`first_value`, `second_value`…) are declared as `i32` constants, and every scenario uses one instance per ADT with successive steps, without resetting state.

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
| Especificación / Specification | [`06_Data_Structures_Basics.md`](../../../../docs/core/algorithms/06_Data_Structures_Basics.md) |
| Módulo homologado del lenguaje / Homologated module | [`naive_sort/`](../naive_sort/README.md) · [`foundations/numbers/`](../../foundations/numbers/README.md) |
| Guía de inicialización / Initialisation guide | [`core/00_Project_Initialization_Guide.md`](../../../../docs/core/00_Project_Initialization_Guide.md) |
| Adaptaciones idiomáticas / Idiomatic adaptations | [`AGENT_Template.md`](../../../../docs/AGENT_Template.md) |
| Validación de la documentación / Documentation validation | [`WORKFLOW.md`](../../../../docs/WORKFLOW.md) |
| Acta de evidencia / Evidence record | [`docs/evidence/algorithms/data_structures_basics/zig.md`](https://github.com/yorche3/programming_languages/blob/main/docs/evidence/algorithms/data_structures_basics/zig.md) |
| Documentación oficial del lenguaje / Language official docs | [Zig Language Reference](https://ziglang.org/documentation/0.17.0/) |

---

*[← Volver a Algoritmos Puros](../README.md)*

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://yorche3.github.io/programming_languages/)*
