// Suite del módulo: los casos de la especificación 06_Data_Structures_Basics se
// escriben aquí en el paso 4c.
//
// `build.zig` crea un módulo de pruebas que importa `data_structures_basics`, así
// que el paso `test` compila el contrato aunque todavía no haya casos. Esta
// comprobación es el andamiaje: no cubre la especificación.

const data_structures_basics = @import("data_structures_basics");

test "el contrato del módulo se compila" {
    _ = data_structures_basics;
}
