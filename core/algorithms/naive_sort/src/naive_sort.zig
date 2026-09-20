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

pub fn selection_sort(arr: []i32) []i32 {
    const n = arr.len;
    if (n < 2) return arr;

    for (0..n - 1) |i| {
        var min_index = i;
        for (i + 1..n) |j| {
            if (arr[j] < arr[min_index]) min_index = j;
        }
        if (min_index != i) {
            const temp = arr[i];
            arr[i] = arr[min_index];
            arr[min_index] = temp;
        }
    }
    return arr;
}

pub fn bubble_sort(arr: []i32) []i32 {
    const n = arr.len;
    if (n < 2) return arr;

    for (0..n - 1) |i| {
        var swapped = false;
        for (0..n - 1 - i) |j| {
            if (arr[j] > arr[j + 1]) {
                const temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
                swapped = true;
            }
        }
        if (!swapped) break;
    }
    return arr;
}

pub fn insertion_sort(arr: []i32) []i32 {
    const n = arr.len;
    if (n < 2) return arr;

    var i: usize = 1;
    while (i < n) : (i += 1) {
        const key = arr[i];
        var j: usize = i;
        while (j > 0 and arr[j - 1] > key) : (j -= 1) {
            arr[j] = arr[j - 1];
        }
        arr[j] = key;
    }
    return arr;
}
