// Casos de prueba de la especificación 07_Data_Structures_Advanced.md:
// 6 filas de `TreeNode`, 7 de `BinaryTree` y 11 de `Graph` (24 casos, un test por fila).
//
// Adaptaciones de Zig:
// - Ausencia de enlace = `null` en `?*TreeNode`; fallo de `get_neighbors` = `null`
//   en `?[]i32`, distinto del slice vacío (vecinos de un vértice aislado).
// - Éxito/fallo de las altas y consultas = `true`/`false` (firmas del contrato).
// - Fila «Adaptación inmutable (si aplica)» de `TreeNode`: no aplica; `setLeft` muta
//   en el sitio y no existe variante inmutable en Zig.
// - El contrato no declara `deinit`: cada caso usa un `ArenaAllocator` sobre
//   `std.testing.allocator`, que además aísla el estado de cada fila.
// - Etiquetas `get_value`/`get_left`... se prueban como `valueOf`/`leftOf`... .

const std = @import("std");
const data_structures_advanced = @import("data_structures_advanced");

const TreeNode = data_structures_advanced.TreeNode;
const BinaryTree = data_structures_advanced.BinaryTree;
const Graph = data_structures_advanced.Graph;

const parent_value: i32 = 10;
const left_value: i32 = 20;
const right_value: i32 = 30;

const root_key: i32 = 50;
const lower_key: i32 = 30;
const higher_key: i32 = 70;
const lower_leaf_key: i32 = 20;
const middle_leaf_key: i32 = 40;
const absent_key: i32 = 99;

const label_ten: i32 = 10;
const label_thirty: i32 = 30;
const label_fifty: i32 = 50;
const label_seventy: i32 = 70;
const absent_label: i32 = 99;
const other_absent_label: i32 = 98;

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

fn check_absent(subject: []const u8, actual: ?*TreeNode) !void {
    if (actual != null) {
        std.debug.print("{s} should be absent\n", .{subject});
        return error.TestExpectedEqual;
    }
}

fn check_neighbors(subject: []const u8, expected: []const i32, actual: ?[]i32) !void {
    const found = actual orelse {
        std.debug.print("{s} should be {any}, found failure (null)\n", .{ subject, expected });
        return error.TestExpectedEqual;
    };
    std.testing.expectEqualSlices(i32, expected, found) catch |err| {
        std.debug.print("{s} should be {any}, found {any}\n", .{ subject, expected, found });
        return err;
    };
}

fn check_failure(subject: []const u8, actual: ?[]i32) !void {
    if (actual) |found| {
        std.debug.print("{s} should fail (null), found {any}\n", .{ subject, found });
        return error.TestExpectedEqual;
    }
}

fn check_counts(subject: []const u8, graph: *const Graph, vertices: usize, edges: usize) !void {
    try check_count(subject, vertices, graph.vertexCount());
    try check_count(subject, edges, graph.edgeCount());
}

fn insert_all(tree: *BinaryTree, subject: []const u8, keys: []const i32) !void {
    for (keys) |key| {
        try check_flag(subject, true, tree.insert(key));
    }
}

fn expect_members(tree: *const BinaryTree, subject: []const u8, keys: []const i32) !void {
    for (keys) |key| {
        try check_flag(subject, true, tree.contains(key));
    }
}

fn register_all(graph: *Graph, subject: []const u8, labels: []const i32) !void {
    for (labels) |label| {
        try check_flag(subject, true, graph.addVertex(label));
    }
}

// ---------------------------------------------------------------- TreeNode

test "TreeNode: create a tree node" {
    const node = TreeNode.init(parent_value);
    try check_int("TreeNode init should store the value", parent_value, node.valueOf());
}

test "TreeNode: absent initial links" {
    const node = TreeNode.init(parent_value);
    try check_absent("TreeNode initial left link", node.leftOf());
    try check_absent("TreeNode initial right link", node.rightOf());
}

test "TreeNode: link two children" {
    var parent = TreeNode.init(parent_value);
    var left = TreeNode.init(left_value);
    var right = TreeNode.init(right_value);
    parent.setLeft(&left);
    parent.setRight(&right);
    const linked_left = parent.leftOf() orelse return error.TestUnexpectedResult;
    const linked_right = parent.rightOf() orelse return error.TestUnexpectedResult;
    try check_int("TreeNode left child value", left_value, linked_left.valueOf());
    try check_int("TreeNode right child value", right_value, linked_right.valueOf());
}

test "TreeNode: traverse each link" {
    var parent = TreeNode.init(parent_value);
    var left = TreeNode.init(left_value);
    var right = TreeNode.init(right_value);
    parent.setLeft(&left);
    parent.setRight(&right);
    const reached_left = parent.leftOf() orelse return error.TestUnexpectedResult;
    const reached_right = parent.rightOf() orelse return error.TestUnexpectedResult;
    try check_int("TreeNode traversal to the left child", left_value, reached_left.valueOf());
    try check_int("TreeNode traversal to the right child", right_value, reached_right.valueOf());
    try check_absent("TreeNode left child's left link", reached_left.leftOf());
    try check_absent("TreeNode left child's right link", reached_left.rightOf());
    try check_absent("TreeNode right child's left link", reached_right.leftOf());
    try check_absent("TreeNode right child's right link", reached_right.rightOf());
}

test "TreeNode: unlink children" {
    var parent = TreeNode.init(parent_value);
    var left = TreeNode.init(left_value);
    var right = TreeNode.init(right_value);
    parent.setLeft(&left);
    parent.setRight(&right);

    parent.setLeft(null);
    try check_absent("TreeNode left link after clearing it", parent.leftOf());
    try check_int("TreeNode value after clearing left", parent_value, parent.valueOf());
    try check_int(
        "TreeNode right child after clearing left",
        right_value,
        (parent.rightOf() orelse return error.TestUnexpectedResult).valueOf(),
    );

    parent.setRight(null);
    try check_absent("TreeNode left link after clearing both", parent.leftOf());
    try check_absent("TreeNode right link after clearing both", parent.rightOf());
    try check_int("TreeNode value after clearing both", parent_value, parent.valueOf());
}

// "Immutable adaptation (if applicable)": not applicable in Zig, see header.

// -------------------------------------------------------------- BinaryTree

test "BinaryTree: create empty" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const tree = BinaryTree.init(arena.allocator());
    try check_flag("BinaryTree is_empty after init", true, tree.isEmpty());
    try check_count("BinaryTree size after init", 0, tree.len());
    try check_flag("BinaryTree contains(50) after init", false, tree.contains(root_key));
}

test "BinaryTree: insert the root" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var tree = BinaryTree.init(arena.allocator());
    try check_flag("BinaryTree insert of the root", true, tree.insert(root_key));
    try check_count("BinaryTree size after the root", 1, tree.len());
    try check_flag("BinaryTree is_empty after the root", false, tree.isEmpty());
    try check_flag("BinaryTree contains the root", true, tree.contains(root_key));
}

test "BinaryTree: insert lower and higher" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var tree = BinaryTree.init(arena.allocator());
    const keys = [_]i32{ root_key, lower_key, higher_key };
    try insert_all(&tree, "BinaryTree insert of 50, 30, 70", &keys);
    try check_count("BinaryTree size after 50, 30, 70", 3, tree.len());
    try expect_members(&tree, "BinaryTree contains 50, 30, 70", &keys);
}

test "BinaryTree: multilevel branches" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var tree = BinaryTree.init(arena.allocator());
    const keys = [_]i32{ root_key, lower_key, higher_key, lower_leaf_key, middle_leaf_key };
    try insert_all(&tree, "BinaryTree multilevel insert", &keys);
    try expect_members(&tree, "BinaryTree multilevel contains", &keys);
    try check_count("BinaryTree multilevel size", 5, tree.len());
}

test "BinaryTree: missing value in nonempty tree" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var tree = BinaryTree.init(arena.allocator());
    try check_flag("BinaryTree insert of 50", true, tree.insert(root_key));
    try check_flag("BinaryTree contains(99)", false, tree.contains(absent_key));
    try check_count("BinaryTree size after a missing query", 1, tree.len());
    try check_flag("BinaryTree contains(50) after a missing query", true, tree.contains(root_key));
}

test "BinaryTree: idempotent duplicate" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var tree = BinaryTree.init(arena.allocator());
    const keys = [_]i32{ root_key, lower_key, higher_key, lower_key };
    try insert_all(&tree, "BinaryTree insert of 50, 30, 70, 30", &keys);
    try check_count("BinaryTree size after a duplicate", 3, tree.len());
    try expect_members(&tree, "BinaryTree contains after a duplicate", keys[0..3]);
}

test "BinaryTree: ordered insertions" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var tree = BinaryTree.init(arena.allocator());
    const keys = [_]i32{ lower_leaf_key, lower_key, middle_leaf_key, root_key, higher_key };
    try insert_all(&tree, "BinaryTree ordered insert", &keys);
    try check_count("BinaryTree ordered size", 5, tree.len());
    try expect_members(&tree, "BinaryTree ordered contains", &keys);
    try check_flag("BinaryTree ordered contains(99)", false, tree.contains(absent_key));
}

// ------------------------------------------------------------------- Graph

test "Graph: create empty" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const graph = Graph.init(arena.allocator());
    try check_flag("Graph is_empty after init", true, graph.isEmpty());
    try check_counts("Graph counts after init", &graph, 0, 0);
    try check_flag("Graph has_edge(10,30) after init", false, graph.hasEdge(label_ten, label_thirty));
    try check_failure("Graph get_neighbors(10) after init", graph.getNeighbors(label_ten));
}

test "Graph: isolated vertex" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var graph = Graph.init(arena.allocator());
    try check_flag("Graph add_vertex(10)", true, graph.addVertex(label_ten));
    try check_flag("Graph is_empty after add_vertex", false, graph.isEmpty());
    try check_counts("Graph counts with an isolated vertex", &graph, 1, 0);
    try check_neighbors("Graph neighbours of an isolated vertex", &.{}, graph.getNeighbors(label_ten));
}

test "Graph: nonconsecutive labels and directed edge" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var graph = Graph.init(arena.allocator());
    try register_all(&graph, "Graph add_vertex of 10, 70", &.{ label_ten, label_seventy });
    try check_flag("Graph add_edge(10,70)", true, graph.addEdge(label_ten, label_seventy));
    try check_flag("Graph has_edge(10,70)", true, graph.hasEdge(label_ten, label_seventy));
    try check_flag("Graph has_edge(70,10)", false, graph.hasEdge(label_seventy, label_ten));
    try check_counts("Graph counts after a directed edge", &graph, 2, 1);
}

test "Graph: duplicate vertex preserves adjacency" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var graph = Graph.init(arena.allocator());
    try register_all(&graph, "Graph add_vertex of 10, 30", &.{ label_ten, label_thirty });
    try check_flag("Graph add_edge(10,30)", true, graph.addEdge(label_ten, label_thirty));
    try check_flag("Graph duplicate add_vertex(10)", true, graph.addVertex(label_ten));
    try check_counts("Graph counts after a duplicate vertex", &graph, 2, 1);
    try check_neighbors("Graph neighbours of 10 after a duplicate vertex", &.{label_thirty}, graph.getNeighbors(label_ten));
}

test "Graph: duplicate edge" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var graph = Graph.init(arena.allocator());
    try register_all(&graph, "Graph add_vertex of 10, 30", &.{ label_ten, label_thirty });
    try check_flag("Graph first add_edge(10,30)", true, graph.addEdge(label_ten, label_thirty));
    try check_flag("Graph second add_edge(10,30)", true, graph.addEdge(label_ten, label_thirty));
    try check_counts("Graph counts after a duplicate edge", &graph, 2, 1);
    try check_neighbors("Graph neighbours of 10 after a duplicate edge", &.{label_thirty}, graph.getNeighbors(label_ten));
}

test "Graph: missing endpoint without mutation" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var graph = Graph.init(arena.allocator());
    try register_all(&graph, "Graph add_vertex of 10, 30", &.{ label_ten, label_thirty });
    try check_flag("Graph add_edge(10,30)", true, graph.addEdge(label_ten, label_thirty));

    try check_flag("Graph add_edge(10,99)", false, graph.addEdge(label_ten, absent_label));
    try check_flag("Graph add_edge(99,10)", false, graph.addEdge(absent_label, label_ten));
    try check_flag("Graph add_edge(98,99)", false, graph.addEdge(other_absent_label, absent_label));
    try check_flag("Graph add_edge(99,99)", false, graph.addEdge(absent_label, absent_label));

    try check_counts("Graph counts after failed edges", &graph, 2, 1);
    try check_neighbors("Graph neighbours of 10 after failed edges", &.{label_thirty}, graph.getNeighbors(label_ten));
    try check_neighbors("Graph neighbours of 30 after failed edges", &.{}, graph.getNeighbors(label_thirty));
    try check_flag("Graph has_edge(10,99) after failure", false, graph.hasEdge(label_ten, absent_label));
    try check_flag("Graph has_edge(99,10) after failure", false, graph.hasEdge(absent_label, label_ten));
    try check_flag("Graph has_edge(98,99) after failure", false, graph.hasEdge(other_absent_label, absent_label));
    try check_flag("Graph has_edge(99,99) after failure", false, graph.hasEdge(absent_label, absent_label));
    try check_failure("Graph get_neighbors(98) after failure", graph.getNeighbors(other_absent_label));
    try check_failure("Graph get_neighbors(99) after failure", graph.getNeighbors(absent_label));
}

test "Graph: sorted neighbours and counts" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var graph = Graph.init(arena.allocator());
    try register_all(&graph, "Graph add_vertex of 10, 30, 50, 70", &.{ label_ten, label_thirty, label_fifty, label_seventy });
    try check_flag("Graph add_edge(10,70)", true, graph.addEdge(label_ten, label_seventy));
    try check_flag("Graph add_edge(10,30)", true, graph.addEdge(label_ten, label_thirty));
    try check_flag("Graph add_edge(10,50)", true, graph.addEdge(label_ten, label_fifty));
    try check_flag("Graph add_edge(30,50)", true, graph.addEdge(label_thirty, label_fifty));
    try check_neighbors("Graph sorted neighbours of 10", &.{ label_thirty, label_fifty, label_seventy }, graph.getNeighbors(label_ten));
    try check_neighbors("Graph neighbours of 30", &.{label_fifty}, graph.getNeighbors(label_thirty));
    try check_neighbors("Graph neighbours of 50", &.{}, graph.getNeighbors(label_fifty));
    try check_neighbors("Graph neighbours of 70", &.{}, graph.getNeighbors(label_seventy));
    try check_counts("Graph counts after four edges", &graph, 4, 4);
}

test "Graph: missing-edge query" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var graph = Graph.init(arena.allocator());
    try register_all(&graph, "Graph add_vertex of 10, 30", &.{ label_ten, label_thirty });
    try check_flag("Graph has_edge(10,30) without the edge", false, graph.hasEdge(label_ten, label_thirty));
    try check_counts("Graph counts without edges", &graph, 2, 0);
    try check_flag("Graph is_empty with vertices only", false, graph.isEmpty());
}

test "Graph: neighbours of missing vertex" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var graph = Graph.init(arena.allocator());
    try check_flag("Graph add_vertex(10)", true, graph.addVertex(label_ten));
    try check_failure("Graph get_neighbors(99) of a missing vertex", graph.getNeighbors(absent_label));
    try check_neighbors("Graph neighbours of 10 stay empty, not failure", &.{}, graph.getNeighbors(label_ten));
    try check_counts("Graph counts after a missing-vertex query", &graph, 1, 0);
}

test "Graph: self-loop and duplicate" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var graph = Graph.init(arena.allocator());
    try check_flag("Graph add_vertex(10)", true, graph.addVertex(label_ten));
    try check_flag("Graph first add_edge(10,10)", true, graph.addEdge(label_ten, label_ten));
    try check_flag("Graph second add_edge(10,10)", true, graph.addEdge(label_ten, label_ten));
    try check_flag("Graph has_edge(10,10)", true, graph.hasEdge(label_ten, label_ten));
    try check_neighbors("Graph neighbours of a self-loop", &.{label_ten}, graph.getNeighbors(label_ten));
    try check_counts("Graph counts with a self-loop", &graph, 1, 1);
}

test "Graph: neighbour-result isolation" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var graph = Graph.init(arena.allocator());
    try register_all(&graph, "Graph add_vertex of 10, 30, 50", &.{ label_ten, label_thirty, label_fifty });
    try check_flag("Graph add_edge(10,30)", true, graph.addEdge(label_ten, label_thirty));

    const saved = graph.getNeighbors(label_ten) orelse return error.TestUnexpectedResult;
    const saved_copy = try std.testing.allocator.dupe(i32, saved);
    defer std.testing.allocator.free(saved_copy);

    const scratch = graph.getNeighbors(label_ten) orelse return error.TestUnexpectedResult;
    for (scratch) |*slot| slot.* = absent_label;
    try check_neighbors("Graph neighbours of 10 after changing a returned copy", &.{label_thirty}, graph.getNeighbors(label_ten));

    try check_flag("Graph add_edge(10,50)", true, graph.addEdge(label_ten, label_fifty));
    try check_neighbors("Graph saved result after add_edge(10,50)", saved_copy, saved);
    try check_neighbors("Graph fresh neighbours of 10", &.{ label_thirty, label_fifty }, graph.getNeighbors(label_ten));
    try check_counts("Graph counts after the isolation scenario", &graph, 3, 2);
}
