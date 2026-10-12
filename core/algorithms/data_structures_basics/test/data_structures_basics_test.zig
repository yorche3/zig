// Casos de prueba de la especificación 06_Data_Structures_Basics.md
//
// Adaptación de Zig: la ausencia de enlace es `null` dentro de `?*Node`, el único
// nulo que admite el contrato; las lecturas que pueden fallar devuelven el
// centinela `-1` y `remove` devuelve `false`. Cada estructura pide un `Allocator`
// y reserva cada celda en el montón, así que los escenarios usan el allocator de
// `std.testing` —que avisa si queda memoria sin soltar— y cierran con `deinit`.
//
// Aislamiento: una instancia por ADT por escenario, como pide la especificación;
// la lista se vacía y se reengancha su cola dentro del mismo escenario, sin
// recrear la estructura para cada borde.

const std = @import("std");
const data_structures_basics = @import("data_structures_basics");

const first_value: i32 = 5;
const second_value: i32 = 10;
const third_value: i32 = 20;
const fourth_value: i32 = 30;
const reused_value: i32 = 40;
const absent_value: i32 = 99;

/// `expectEqual` no admite mensaje: se emite el del contrato antes de devolver el
/// error, como en `naive_sort_test.zig`.
fn check_int(subject: []const u8, expected: i32, actual: i32) !void {
    std.testing.expectEqual(expected, actual) catch |err| {
        std.debug.print("{s} should be {d}, found {d}\n", .{ subject, expected, actual });
        return err;
    };
}

fn check_count(subject: []const u8, expected: usize, actual: usize) !void {
    std.testing.expectEqual(expected, actual) catch |err| {
        std.debug.print("{s} should be {d}, found {d}\n", .{ subject, expected, actual });
        return err;
    };
}

fn check_flag(subject: []const u8, expected: bool, actual: bool) !void {
    std.testing.expectEqual(expected, actual) catch |err| {
        std.debug.print("{s} should be {}, found {}\n", .{ subject, expected, actual });
        return err;
    };
}

test "Node" {
    const initialized = data_structures_basics.Node.init(second_value);
    try check_int("Node init should store the value", second_value, initialized.valueOf());
    try std.testing.expectEqual(@as(?*data_structures_basics.Node, null), initialized.nextOf());

    var linked = data_structures_basics.Node.init(third_value);
    var first = initialized;
    first.next = &linked;
    try check_int(
        "Node should traverse the linked cell",
        third_value,
        first.nextOf().?.valueOf(),
    );
    try std.testing.expectEqual(@as(?*data_structures_basics.Node, null), linked.nextOf());
}

test "LinkedList" {
    var list = data_structures_basics.LinkedList.init(std.testing.allocator);
    defer list.deinit();

    try check_flag("LinkedList is_empty after init", true, list.isEmpty());
    try check_count("LinkedList len after init", 0, list.len());
    try check_int("LinkedList headValue after init", -1, list.headValue());

    try list.insertTail(second_value);
    try list.insertTail(third_value);
    try list.insertHead(first_value);
    try list.insertTail(second_value);
    try check_count("LinkedList len after inserting at both ends", 4, list.len());
    try check_int("LinkedList headValue after insertHead", first_value, list.headValue());

    try check_flag("LinkedList remove of a stored value", true, list.remove(second_value));
    try check_count("LinkedList len after the first removal", 3, list.len());
    try check_int("LinkedList headValue after removing an interior value", first_value, list.headValue());

    try check_flag("LinkedList remove of an absent value", false, list.remove(absent_value));
    try check_count("LinkedList len after an absent removal", 3, list.len());
    try check_int("LinkedList headValue after an absent removal", first_value, list.headValue());

    try check_flag("LinkedList remove of the head", true, list.remove(first_value));
    try check_int("LinkedList headValue after removing the head", third_value, list.headValue());
    try check_flag("LinkedList remove of the middle value", true, list.remove(third_value));
    try check_int("LinkedList headValue with a single value left", second_value, list.headValue());
    try check_flag("LinkedList remove of the last value", true, list.remove(second_value));
    try check_flag("LinkedList is_empty after removing every value", true, list.isEmpty());
    try check_count("LinkedList len after removing every value", 0, list.len());
    try check_int("LinkedList headValue after emptying", -1, list.headValue());
    try check_flag("LinkedList remove on an empty list", false, list.remove(second_value));
}

test "LinkedList relinks the tail" {
    var list = data_structures_basics.LinkedList.init(std.testing.allocator);
    defer list.deinit();

    try list.insertTail(second_value);
    try list.insertTail(third_value);
    try list.insertTail(fourth_value);
    try check_flag("LinkedList remove of the tail", true, list.remove(fourth_value));
    try check_count("LinkedList len after removing the tail", 2, list.len());

    // El final se reengancha al borrar la cola: lo que se inserte después tiene
    // que quedar alcanzable y poder borrarse.
    try list.insertTail(reused_value);
    try check_count("LinkedList len after appending to the shortened list", 3, list.len());
    try check_flag("LinkedList remove of the appended tail", true, list.remove(reused_value));
    try check_count("LinkedList len after removing the appended tail", 2, list.len());
}

test "Stack" {
    var stack = data_structures_basics.Stack.init(std.testing.allocator);
    defer stack.deinit();

    try check_flag("Stack is_empty after init", true, stack.isEmpty());
    try check_count("Stack len after init", 0, stack.len());
    try check_int("Stack peek on an empty stack", -1, stack.peek());
    try check_int("Stack pop on an empty stack", -1, stack.pop());

    try stack.push(second_value);
    try stack.push(third_value);
    try stack.push(fourth_value);
    try check_int("Stack peek should be the most recently pushed value", fourth_value, stack.peek());
    try check_count("Stack peek should not change the size", 3, stack.len());

    try check_int("Stack pop in LIFO order", fourth_value, stack.pop());
    try stack.push(reused_value);
    try check_int("Stack pop of a value pushed after reuse", reused_value, stack.pop());
    try check_int("Stack LIFO order after reuse", third_value, stack.pop());
    try check_int("Stack pop of the first pushed value last", second_value, stack.pop());
    try check_flag("Stack is_empty after popping every value", true, stack.isEmpty());
    try check_count("Stack len after popping every value", 0, stack.len());
    try check_int("Stack pop after emptying", -1, stack.pop());
    try check_flag("Stack stays empty after a failed pop", true, stack.isEmpty());
}

test "Queue" {
    var queue = data_structures_basics.Queue.init(std.testing.allocator);
    defer queue.deinit();

    try check_flag("Queue is_empty after init", true, queue.isEmpty());
    try check_count("Queue len after init", 0, queue.len());
    try check_int("Queue peek on an empty queue", -1, queue.peek());
    try check_int("Queue dequeue on an empty queue", -1, queue.dequeue());

    try queue.enqueue(second_value);
    try queue.enqueue(third_value);
    try queue.enqueue(fourth_value);
    try check_int("Queue peek should be the first enqueued value", second_value, queue.peek());
    try check_count("Queue peek should not change the size", 3, queue.len());

    try check_int("Queue dequeue in FIFO order", second_value, queue.dequeue());
    try queue.enqueue(reused_value);
    try check_int("Queue FIFO order after reuse", third_value, queue.dequeue());
    try check_int("Queue dequeue of the third enqueued value", fourth_value, queue.dequeue());
    try check_int("Queue dequeue of the reused value last", reused_value, queue.dequeue());
    try check_flag("Queue is_empty after dequeuing every value", true, queue.isEmpty());
    try check_count("Queue len after dequeuing every value", 0, queue.len());
    try check_int("Queue dequeue after emptying", -1, queue.dequeue());
    try check_flag("Queue stays empty after a failed dequeue", true, queue.isEmpty());
}
