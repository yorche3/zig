// naive_sort — ordenamientos elementales O(n²).
//
// Especificación: 05_Naive_Sort
//
// Contrato: las tres funciones reciben un slice de enteros, lo ordenan in-place
// de menor a mayor y devuelven el mismo slice, sin invocar `std.sort` ni
// ninguna otra ayuda de ordenamiento de la biblioteca estándar y sin
// estructuras auxiliares complejas.
// API (naming snake_case, el mismo de la especificación y de `core/foundations/
// numbers/`): `selection_sort`, `bubble_sort` e `insertion_sort`, con la firma
// `pub fn <algoritmo>(arr: []i32) []i32`.
// El caso nulo se omite: en Zig un slice no admite `null` sin envolverlo en un
// opcional (`?[]i32`), que se formaliza en una fase posterior. Si el slice tiene
// menos de dos elementos se devuelve sin cambios. No lanza errores.
//
// Implementación pendiente: la escribe el autor. Esta delegación solo genera el
// esqueleto y las pruebas unitarias.
