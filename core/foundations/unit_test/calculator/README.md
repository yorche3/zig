# Calculator — Zig

Implementación de la especificación [03_Unit_Test_Calculator](https://yorche3.github.io/programming_languages/core/foundations/03_Unit_Test_Calculator/) en **Zig**, usando una estructura tipo librería con `src/` y `test/`, y el framework de pruebas integrado de Zig (`std.testing` + `zig build test --summary all`).

No se requiere instalar una biblioteca externa ni usar `sudo`.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo / Directorio | Propósito |
|----------------------|-----------|
| [`build.zig`](build.zig) | Configuración del paquete, librería y paso de testing. |
| [`src/calculator.zig`](src/calculator.zig) | Implementación de las cinco operaciones. |
| [`test/calculator_test.zig`](test/calculator_test.zig) | Suite integrada de Zig agrupada por operación. |
| [`.gitignore`](.gitignore) | Ignora cachés, librerías y ejecutables generados. |

```text
calculator/
├── build.zig
├── src/
│   └── calculator.zig
├── test/
│   └── calculator_test.zig
├── .gitignore
└── README.md
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El proyecto se creó manualmente como una librería Zig. El código de producción está en `src/` y la suite en `test/`. `build.zig` instala la librería estática y define el paso `zig build test --summary all`.

**EN:** The project was created manually as a Zig library. Production code lives in `src/`, and the suite lives in `test/`. `build.zig` installs the static library and defines the `zig build test --summary all` step.

Las operaciones siguen las implementaciones educativas:

- `addition`: suma directa.
- `subtraction`: resta directa.
- `multiplication`: suma repetitiva, sin usar `*`.
- `division`: resta repetitiva, sin usar `/`.
- `modulus`: reutiliza `division` y `multiplication`, sin usar `%`.

### Inicialización / Initialization

```bash
mkdir -p zig/core/foundations/unit_test/calculator/{src,test}
cd zig/core/foundations/unit_test/calculator
zig init
```

Después se añaden la librería, la suite y el paso de tests definidos en `build.zig`.

---

## 📄 Archivos de configuración clave / Key Configuration Files

### `build.zig`

`build.zig` crea el módulo de producción, instala una librería estática, conecta el módulo `calculator` con el módulo de tests y registra el test executable bajo el paso `test`.

`build.zig` creates the production module, installs a static library, connects the `calculator` module to the test module, and registers the test executable under the `test` step.

### `test/calculator_test.zig`

La suite usa `std.testing.expectEqual` y un bloque `test` por operación. Zig incorpora el runner, las aserciones y el reporte.

The suite uses `std.testing.expectEqual` and one `test` block per operation. Zig provides the runner, assertions, and report.

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

No se requiere instalar una biblioteca externa ni usar `sudo`.

### Ejecutar las pruebas / Run tests

```bash
cd zig/core/foundations/unit_test/calculator
zig build test --summary all
```

### Salida esperada / Expected output

```text
All 5 tests passed.
```

> **ES:** El formato exacto puede variar entre versiones de Zig, pero deben ejecutarse los 5 tests y producirse 0 fallos.
> **EN:** The exact format may vary across Zig versions, but all 5 tests must run with 0 failures.

---

## 🧠 Operaciones / Operations

| Operación | Implementación educativa |
|-----------|--------------------------|
| `addition(a, b)` | Suma directa. |
| `subtraction(a, b)` | Resta directa. |
| `multiplication(a, b)` | Suma `a` repetidamente mediante `while`. |
| `division(a, b)` | Resta `b` repetidamente mediante `while`. |
| `modulus(a, b)` | Calcula el resto reutilizando `division` y `multiplication`. |

Los cinco tests están agrupados por operación mediante bloques `test`.

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** Zig incluye `std.testing` y el runner `zig build test --summary all`, por lo que no se añade una biblioteca externa.
- **EN:** Zig includes `std.testing` and the `zig build test --summary all` runner, so no external testing library is added.
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
