// Casos de prueba de la especificación 05_Naive_Sort.md
//
// Caso nulo omitido: en Zig un slice no admite `null` sin envolverlo en un
// opcional (`?[]i32`), que se formaliza en una fase posterior, así que una
// entrada nula no es representable en la firma y no hay indicador que comprobar.
// Se conservan los 7 casos de la especificación.
//
// Aislamiento: los slices apuntan a memoria mutable, así que el helper copia
// cada fixture recibido en un búfer local antes de ordenarlo; ningún caso
// reutiliza un búfer ya ordenado.

const std = @import("std");
const naive_sort = @import("naive_sort");

// Entradas y salidas de la especificación
const standard_input = [_]i32{ 5, 2, 9, 1, 5, 6 };
const standard_output = [_]i32{ 1, 2, 5, 5, 6, 9 };

const sorted_input = [_]i32{ 1, 2, 3, 4, 5 };
const sorted_output = [_]i32{ 1, 2, 3, 4, 5 };

const reverse_input = [_]i32{ 5, 4, 3, 2, 1 };
const reverse_output = [_]i32{ 1, 2, 3, 4, 5 };

const identical_input = [_]i32{ 7, 7, 7, 7 };
const identical_output = [_]i32{ 7, 7, 7, 7 };

const negative_input = [_]i32{ 3, -1, 4, -5, 0 };
const negative_output = [_]i32{ -5, -1, 0, 3, 4 };

const single_input = [_]i32{42};
const single_output = [_]i32{42};

const empty_input = [_]i32{};
const empty_output = [_]i32{};

const SortCase = struct {
    description: []const u8,
    input: []const i32,
    expected: []const i32,
};

// Tabla de casos: descripción, entrada y salida esperada.
const cases = [_]SortCase{
    .{ .description = "an unsorted array", .input = &standard_input, .expected = &standard_output },
    .{ .description = "an already sorted array", .input = &sorted_input, .expected = &sorted_output },
    .{ .description = "a reverse ordered array", .input = &reverse_input, .expected = &reverse_output },
    .{ .description = "an array of identical elements", .input = &identical_input, .expected = &identical_output },
    .{ .description = "an array with negative numbers", .input = &negative_input, .expected = &negative_output },
    .{ .description = "a single element array", .input = &single_input, .expected = &single_output },
    .{ .description = "an empty array", .input = &empty_input, .expected = &empty_output },
};

// Helper compartido: recibe el nombre del algoritmo y la función a probar, y
// ejecuta todos los casos con el mensaje descriptivo del contrato.
fn assert_sorts_all_cases(
    algorithm: []const u8,
    sort: *const fn ([]i32) []i32,
) !void {
    for (cases) |test_case| {
        var buffer: [64]i32 = undefined;
        const input = buffer[0..test_case.input.len];
        @memcpy(input, test_case.input);

        const actual = sort(input);

        std.testing.expectEqualSlices(i32, test_case.expected, actual) catch |err| {
            std.debug.print("{s} should sort {s}\n", .{ algorithm, test_case.description });
            return err;
        };
    }
}

test "selection_sort" {
    try assert_sorts_all_cases("selection_sort", naive_sort.selection_sort);
}

test "bubble_sort" {
    try assert_sorts_all_cases("bubble_sort", naive_sort.bubble_sort);
}

test "insertion_sort" {
    try assert_sorts_all_cases("insertion_sort", naive_sort.insertion_sort);
}
