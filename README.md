# Zig

Proyectos en **Zig**, con programas independientes ejecutados mediante `zig run` o compilados con `zig build-exe`, y proyectos tipo librería gestionados con `build.zig` y probados con `std.testing`.

---

## 📂 Módulos / Modules

| Módulo | Descripción |
| ------ | ----------- |
| [`core/foundations/`](core/foundations/) | **Fase 0 — Fundamentos**: `helloworld`, `hellouser`, `unit_test/calculator`, `numbers` |

---

## ▶️ Comenzar / Getting Started

```bash
# Verificar Zig
zig version

# Hello, World!
cd core/foundations/helloworld
zig run hello_world.zig

# Hello, User!
cd ../hellouser
printf 'Ada\n' | zig run hello_user.zig

# Calculator tests
cd ../unit_test/calculator
zig build test --summary all

# Numbers tests
cd ../../numbers
zig build test --summary all
```

---

## 📦 Requisitos / Requirements

| Herramienta | Uso | Verificación |
| ----------- | --- | ------------ |
| Zig 0.16.0 | Compilador y runtime | `zig version` |
| `std.testing` | Framework de pruebas integrado | Incluido en Zig |
| `build.zig` | Orquestación de build y tests | `zig build test --summary all` |

No se requiere instalar una biblioteca externa ni usar `sudo`.

```bash
zig version
```

Salida verificada:

```text
0.16.0
```

---

## 🏗️ Tipos de proyecto / Project Types

### 1. Programa independiente (`zig run` / `zig build-exe`)

**ES:** `helloworld` y `hellouser` son archivos `.zig` ejecutados directamente con `zig run` o compilados a ejecutables nativos con `zig build-exe`.

**EN:** `helloworld` and `hellouser` are `.zig` files run directly with `zig run` or compiled into native executables with `zig build-exe`.

```bash
zig run <File>.zig
zig build-exe <File>.zig
```

### 2. Proyecto tipo librería con `build.zig`

**ES:** `calculator` y `numbers` separan `src/` y `test/`. `build.zig` conecta los módulos de producción con sus tests y define el paso `zig build test --summary all`.

**EN:** `calculator` and `numbers` separate `src/` and `test/`. `build.zig` connects production modules to their tests and defines the `zig build test --summary all` step.

---

## 🔁 Decisión de TCO / TCO Decision

Zig tiene iteración nativa mediante `while`, pero no ofrece una garantía general de Tail Call Optimization para estos módulos. Por eso `numbers` conserva `_acc` como puente educativo sin suite propia y prueba `_rec` e `_ite`:

Zig has native iteration through `while`, but does not provide a general Tail Call Optimization guarantee for these modules. Therefore `numbers` keeps `_acc` as an educational bridge without a dedicated suite and tests `_rec` and `_ite`:

```text
TCO no garantizada + iteración nativa ✅
_rec + _ite
2 suites lógicas
10 tests
22 casos
```

---

## 🧪 Convenciones de pruebas / Testing Conventions

**ES:** Zig usa `std.testing`, `test` blocks y `std.testing.expectEqual`. `zig build test --summary all` compila las librerías y ejecuta los tests con un resumen explícito.

**EN:** Zig uses `std.testing`, `test` blocks, and `std.testing.expectEqual`. `zig build test --summary all` builds the libraries and runs the tests with an explicit summary.

---

## 🧹 Artefactos de compilación / Build Artifacts

Los proyectos Zig incluyen `.gitignore` locales para excluir `zig-out/`, `.zig-cache/`, `zig-cache/`, ejecutables y artefactos nativos.

Zig projects include local `.gitignore` files to exclude `zig-out/`, `.zig-cache/`, `zig-cache/`, executables, and native artifacts.

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://github.com/yorche3/programming_languages)*