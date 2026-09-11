# Hello, User! — Zig

Implementación de la especificación [02_Hello_User](https://yorche3.github.io/programming_languages/core/foundations/02_Hello_User/) en **Zig**, con un enfoque manual y minimalista.

Solicita un nombre mediante la entrada estándar y muestra un saludo personalizado.

---

## 📂 Archivos y estructura / Files & Structure

| Archivo | Propósito |
|---------|-----------|
| [`hello_user.zig`](hello_user.zig) | Código fuente: solicita un nombre, lo lee desde `stdin` y muestra un saludo. |

**Estructura de directorios esperada:**

```text
hellouser/
├── hello_user.zig  # Código fuente
└── README.md       # Este archivo
```

---

## 🛠️ Enfoque y construcción / Approach & Build

**ES:** El proyecto se creó manualmente, sin `build.zig` ni herramientas de scaffolding. El programa usa la API de E/S de Zig 0.16 para escribir el prompt, leer una línea desde la entrada estándar y mostrar el saludo.

**EN:** The project was created manually, without `build.zig` or scaffolding tools. The program uses Zig 0.16's I/O API to write the prompt, read a line from standard input, and print the greeting.

### Inicialización / Initialization

1. Crear la estructura de directorios:

   ```bash
   mkdir -p zig/core/foundations/hellouser
   ```

2. Escribir el archivo `hello_user.zig` con el código fuente.

3. Ejecutarlo con `zig run` o compilarlo con `zig build-exe`.

---

## 📄 Archivos de configuración clave / Key Configuration Files

No se requieren archivos de configuración para este ejercicio.

```zig
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    _ = init;
    std.debug.print("Enter your name: ", .{});

    var buffer: [64]u8 = undefined;
    const length = try std.posix.read(std.posix.STDIN_FILENO, &buffer);
    const input = buffer[0..length];
    const name = std.mem.trimEnd(u8, input, "\r\n");

    std.debug.print("Hello, {s}!\n", .{name});
}
```

| Elemento | Propósito |
|----------|-----------|
| `std.process.Init` | Proporciona el contexto de inicio requerido por Zig 0.16. |
| `std.debug.print(...)` | Escribe el prompt y el saludo con formato. |
| `std.posix.read(...)` | Lee bytes desde la entrada estándar. |
| `std.mem.trimEnd(...)` | Elimina `CR`/`LF` al final de la entrada. |
| `"{s}"` | Inserta la cadena del nombre en el saludo. |

> **ES:** La implementación usa las APIs de Zig 0.16; versiones anteriores o posteriores pueden tener APIs de E/S diferentes.
> **EN:** The implementation uses Zig 0.16 APIs; earlier or later versions may expose different I/O APIs.

---

## 🚀 Compilación y ejecución / Build & Run

### Requisitos / Requirements

- **Zig 0.16.0**.
- El ejecutable `zig` disponible en el `PATH`.

Verificar la instalación:

```bash
zig version
```

Salida verificada:

```text
0.16.0
```

### Ejecutar directamente / Run directly

```bash
cd zig/core/foundations/hellouser
printf 'Ada\n' | zig run hello_user.zig
```

### Compilar y ejecutar / Compile and run

```bash
cd zig/core/foundations/hellouser
zig build-exe hello_user.zig -femit-bin=/tmp/zig-hello-user
printf 'Ada\n' | /tmp/zig-hello-user
```

### Salida esperada / Expected output

Con la entrada `Ada`, la salida verificada es:

```text
Enter your name: Hello, Ada!
```

El prompt permanece en la misma línea que la entrada porque no se imprime un salto de línea después del prompt.

The prompt remains on the same line as the input because no newline is printed after the prompt.

---

## 📝 Notas de implementación / Implementation Notes

- **ES:** Zig requiere una función `main`; en Zig 0.16 puede recibir `std.process.Init`.
- **EN:** Zig requires a `main` function; in Zig 0.16 it may receive `std.process.Init`.
- **ES:** La entrada se limita a un buffer de 64 bytes para este ejemplo educativo.
- **EN:** Input is limited to a 64-byte buffer for this educational example.
- **ES:** El ejecutable generado en `/tmp` es un artefacto de compilación y no forma parte del código fuente.
- **EN:** The executable generated under `/tmp` is a build artifact and is not part of the source code.

---

## 🌐 Otras implementaciones / Other implementations

Este proyecto también está implementado en otros lenguajes. Explora el [repositorio principal](https://github.com/yorche3/programming_languages) para ver todas las versiones.

---

*🌐 [github.com/yorche3/programming_languages](https://github.com/yorche3/programming_languages) · [GitHub Pages](https://github.com/yorche3/programming_languages)*
