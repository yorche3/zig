# Numbers — Zig

Implementación de la especificación [04_Numbers](https://yorche3.github.io/programming_languages/core/foundations/04_Numbers/) en **Zig**, usando una estructura tipo librería con `src/` y `test/`, y el framework de pruebas integrado de Zig (`std.testing` + `zig build test --summary all`).

No se requiere instalar una biblioteca externa ni usar `sudo`.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo / Directorio | Propósito |
|----------------------|-----------|
| [`build.zig`](build.zig) | Configuración de la librería y del ejecutable de tests. |
| [`src/numbers.zig`](src/numbers.zig) | Implementación de los 15 procedimientos. |
| [`test/numbers_test.zig`](test/numbers_test.zig) | Suite integrada con 10 tests y 22 assertions. |
| [`.gitignore`](.gitignore) | Ignora cachés, librerías y ejecutables generados. |

```text
numbers/
├── build.zig
├── src/
│   └── numbers.zig
├── test/
│   └── numbers_test.zig
├── .gitignore
└── README.md
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El proyecto se creó manualmente como una librería Zig. El código de producción está en `src/` y la suite en `test/`. `build.zig` conecta el módulo de producción con los tests y define el paso `zig build test --summary all`.

**EN:** The project was created manually as a Zig library. Production code lives in `src/`, and the suite lives in `test/`. `build.zig` connects the production module to the tests and defines the `zig build test --summary all` step.

Los cinco algoritmos tienen tres implementaciones:

| Enfoque | Sufijo | Ejemplo | ¿Tiene suite propia? |
|---------|--------|---------|:--------------------:|
| Recursivo directo | `_rec` | `fibonacci_rec` | Sí |
| Recursivo con acumulador | `_acc` | `fibonacci_acc` | No, por TCO no garantizada |
| Iterativo | `_ite` | `fibonacci_ite` | Sí |

**Combinación aplicada:** TCO no garantizada + iteración nativa (`while`) ✅ → `_rec` + `_ite` = **2 suites lógicas, 10 tests y 22 casos/assertions**.

**Applied combination:** No guaranteed TCO + native iteration (`while`) ✅ → `_rec` + `_ite` = **2 logical suites, 10 tests, and 22 cases/assertions**.

### Inicialización / Initialization

```bash
mkdir -p zig/core/foundations/numbers/{src,test}
cd zig/core/foundations/numbers
zig init
```

Después se añaden el módulo, el archivo `build.zig` y la suite de tests.

---

## 📄 Archivos de configuración clave / Key Configuration Files

### `build.zig`

`build.zig` crea el módulo de producción, instala una librería estática, conecta el módulo `numbers` con los tests y registra el paso `test`.

`build.zig` creates the production module, installs a static library, connects the `numbers` module to the tests, and registers the `test` step.

### `test/numbers_test.zig`

La suite usa `std.testing.expectEqual`. Los cinco tests `_rec` y los cinco tests `_ite` agrupan sus casos de entrada dentro de cada bloque `test`.

The suite uses `std.testing.expectEqual`. Five `_rec` tests and five `_ite` tests group their input cases inside each `test` block.

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

### Ejecutar las pruebas / Run tests

```bash
cd zig/core/foundations/numbers
zig build test --summary all
```

### Salida esperada / Expected output

```text
Build Summary: 3/3 steps succeeded; 5/5 tests passed
```

> **ES:** El resumen muestra cinco tests Zig porque cada test agrupa varios casos/assertions. En total se validan 22 casos y no hay fallos.
> **EN:** The summary shows five Zig tests because each test groups multiple cases/assertions. In total, 22 cases are validated with no failures.

---

## 🧠 Operaciones / Operations

| Función | `_rec` | `_acc` | `_ite` |
|---------|--------|--------|--------|
| `sum_of_first_n` | Recursión directa | Helper con acumulador | `while` |
| `factorial` | Recursión directa | Helper con acumulador | `while` |
| `fibonacci` | Dos llamadas recursivas | Dos acumuladores | `while` |
| `greatest_common_divisor` | Euclides recursivo | Helper de Euclides | `while` |
| `least_common_multiple` | Usa MCD y aritmética | Usa MCD y aritmética | Usa MCD y aritmética |

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** Zig tiene iteración nativa mediante `while`, por lo que `_ite` se implementa sin llamadas recursivas.
- **EN:** Zig has native iteration through `while`, so `_ite` is implemented without recursive calls.
- **ES:** Zig no ofrece una garantía general de TCO para este proyecto; `_acc` se conserva como puente didáctico sin suite propia.
- **EN:** Zig does not provide a general TCO guarantee for this project; `_acc` remains as an educational bridge without its own suite.
- **ES:** `std.testing` proporciona las aserciones y el runner `zig build test --summary all`.
- **EN:** `std.testing` provides assertions and the `zig build test --summary all` runner.
- **ES:** La división por cero y los divisores no positivos quedan fuera de los casos básicos y provocan un `@panic` explícito.
- **EN:** Division by zero and non-positive divisors are outside the basic cases and trigger an explicit `@panic`.
- **ES:** Los artefactos de Zig quedan excluidos mediante `.gitignore`.
- **EN:** Zig artifacts are excluded through `.gitignore`.
- **ES:** El código fuente no incluye comentarios inline; la explicación se mantiene en este README.
- **EN:** The source code contains no inline comments; explanations are kept in this README.

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://github.com/yorche3/programming_languages)*
