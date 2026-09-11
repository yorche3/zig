# 🚀 Fundamentos / Foundations — Zig

Implementación de los ejercicios de la sección [Fundamentos / Foundations](https://yorche3.github.io/programming_languages/core/foundations/) del repositorio principal en **Zig**.

---

## 📖 Descripción / Description

**ES:** Esta sección introduce Zig mediante programas independientes y proyectos tipo librería con pruebas unitarias usando el framework integrado de Zig (`std.testing` + `zig build test --summary all`).

**EN:** This section introduces Zig through standalone programs and library-style projects with unit tests using Zig's built-in framework (`std.testing` + `zig build test --summary all`).

---

## 📁 Estructura / Structure

```text
zig/
└── core/
    └── foundations/
        ├── README.md                   # Este archivo / This file
        ├── helloworld/                 # 01_Hello_World
        │   ├── hello_world.zig
        │   └── README.md
        ├── hellouser/                  # 02_Hello_User
        │   ├── hello_user.zig
        │   └── README.md
        ├── unit_test/
        │   └── calculator/             # 03_Unit_Test_Calculator
        │       ├── build.zig
        │       ├── src/
        │       │   └── calculator.zig
        │       ├── test/
        │       │   └── calculator_test.zig
        │       ├── .gitignore
        │       └── README.md
        └── numbers/                    # 04_Numbers
            ├── build.zig
            ├── src/
            │   └── numbers.zig
            ├── test/
            │       └── numbers_test.zig
            ├── .gitignore
            └── README.md
```

---

## 🔢 Progresión / Progression

| Especificación | Proyecto | Conceptos | Tests | Dependencias |
| -------------- | -------- | --------- | :---: | ------------ |
| [`01_Hello_World`](https://yorche3.github.io/programming_languages/core/foundations/01_Hello_World/) | [`helloworld/`](helloworld/) | `std`, `main`, `std.debug.print`, `zig run` | — | Solo Zig |
| [`02_Hello_User`](https://yorche3.github.io/programming_languages/core/foundations/02_Hello_User/) | [`hellouser/`](hellouser/) | `std.process.Init`, `std.posix.read`, entrada estándar | — | Solo Zig |
| [`03_Unit_Test_Calculator`](https://yorche3.github.io/programming_languages/core/foundations/03_Unit_Test_Calculator/) | [`unit_test/calculator/`](unit_test/calculator/) | `build.zig`, librería estática, `std.testing` | 5 | Testing integrado |
| [`04_Numbers`](https://yorche3.github.io/programming_languages/core/foundations/04_Numbers/) | [`numbers/`](numbers/) | recursión, acumuladores, `while`, TCO | 10 (22 casos) | Testing integrado |

---

## 🛠️ Enfoque general / General Approach

**ES:** Los proyectos de esta sección siguen una progresión gradual:

1. **Hello World**: programa Zig independiente ejecutado con `zig run` o compilado a un ejecutable nativo.
2. **Hello User**: programa con lectura de stdin usando las APIs de Zig 0.16.
3. **Calculator**: primer proyecto tipo librería con `build.zig`, `src/` y `test/`. Usa `std.testing` para validar cinco operaciones educativas.
4. **Numbers**: implementa cinco algoritmos en tres enfoques. Zig tiene iteración nativa mediante `while`, pero no ofrece una garantía general de TCO; por eso se prueban `_rec` e `_ite`, mientras `_acc` queda como puente didáctico sin suite propia.

**EN:** The projects in this section follow a gradual progression:

1. **Hello World**: standalone Zig program run with `zig run` or compiled to a native executable.
2. **Hello User**: program reading stdin through Zig 0.16's APIs.
3. **Calculator**: the first library-style project with `build.zig`, `src/`, and `test/`. It uses `std.testing` to validate five educational operations.
4. **Numbers**: implements five algorithms in three approaches. Zig has native iteration through `while`, but does not provide a general TCO guarantee; therefore `_rec` and `_ite` are tested, while `_acc` remains an educational bridge without its own suite.

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

## 🚀 Ejecución rápida / Quick Start

### Hello World

```bash
cd zig/core/foundations/helloworld
zig run hello_world.zig
```

### Hello User

```bash
cd zig/core/foundations/hellouser
printf 'Ada\n' | zig run hello_user.zig
```

### Calculator

```bash
cd zig/core/foundations/unit_test/calculator
zig build test --summary all
```

Resultado verificado: 5 tests aprobados.

### Numbers

```bash
cd zig/core/foundations/numbers
zig build test --summary all
```

Resultado verificado:

```text
Build Summary: 3/3 steps succeeded; 10/10 tests passed
```

---

## 🧪 Convenciones de pruebas / Testing Conventions

**ES:** Los proyectos tipo librería usan `build.zig` y `std.testing`. Cada bloque `test` agrupa los casos de un algoritmo mediante `std.testing.expectEqual`. `zig build test --summary all` compila la librería y ejecuta todas las pruebas.

**EN:** Library-style projects use `build.zig` and `std.testing`. Each `test` block groups an algorithm's cases through `std.testing.expectEqual`. `zig build test --summary all` builds the library and runs all tests.

`calculator` tiene 5 tests. `numbers` tiene 10 tests que agrupan 22 casos/assertions entre `_rec` e `_ite`.

`calculator` has 5 tests. `numbers` has 10 tests grouping 22 cases/assertions across `_rec` and `_ite`.

---

## 🔁 TCO e iteración / TCO and Iteration

Zig ofrece iteración nativa mediante `while`, pero no se documenta una garantía general de Tail Call Optimization para estos módulos. Según la regla de `04_Numbers`, la combinación aplicada es:

Zig provides native iteration through `while`, but no general Tail Call Optimization guarantee is documented for these modules. According to the `04_Numbers` rule, the applied combination is:

```text
TCO no garantizada + iteración nativa ✅
_rec + _ite
2 suites lógicas
10 tests
22 casos
```

La implementación `_acc` permanece en el código fuente como puente conceptual hacia `_ite`, pero no tiene una suite independiente.

The `_acc` implementation remains in the source as a conceptual bridge toward `_ite`, but it has no independent suite.

---

## 🧹 Artefactos de compilación / Build Artifacts

Los `.gitignore` locales excluyen `zig-out/`, `.zig-cache/`, `zig-cache/`, ejecutables y artefactos nativos generados por Zig.

Local `.gitignore` files exclude `zig-out/`, `.zig-cache/`, `zig-cache/`, executables, and native artifacts generated by Zig.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://github.com/yorche3/programming_languages)*
