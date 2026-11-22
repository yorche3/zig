// data_structures_advanced — TreeNode, BinaryTree, GraphNode y Graph.
//
// Especificación: 07_Data_Structures_Advanced
//
// Contrato declarado con la API pública del módulo: `TreeNode`, `BinaryTree` y
// `Graph`; `NeighborNode` y `GraphNode` quedan internos al grafo.
//
// Adaptaciones declaradas:
//   - Ausencia de enlace: `null` sobre `?*TreeNode`.
//   - Vértice inexistente frente a aislado: `getNeighbors` devuelve `?[]i32`;
//     `null` es el vértice que no existe y un slice de longitud 0 el que existe
//     sin vecinos. Zig distingue los dos valores sin centinelas.
//   - Valor embebido: cada nodo declara su `value` y valida sus propios
//     enlaces; Zig no tiene herencia de structs.
//   - Memoria: el contrato no declara `deinit`, así que el módulo crea sus
//     nodos con el `Allocator` que recibe y cada suite usa un `ArenaAllocator`.
//   - Mutabilidad: nodos y estructuras mutan en sitio; `setLeft`/`setRight`
//     devuelven `void`, así que la fila «Adaptación inmutable» no aplica.
//
// Indicadores de fallo (valores representables, sin pánicos):
//   - **bool**: `insert`, `contains`, `isEmpty`, `addVertex`, `addEdge`,
//     `hasEdge`. Un alta duplicada o una arista repetida devuelven `true`: son
//     éxito y no suman al contador.
//   - **null**: `getNeighbors` de un vértice inexistente.
//
// La búsqueda por etiqueta, la detección de duplicados y la inserción ordenada
// de vecinos se escriben a mano: no se usan `std.mem.indexOf`, `sort` ni
// `contains` de la biblioteca en los pasos internos del algoritmo.

const Allocator = @import("std").mem.Allocator;

pub const TreeNode = struct {
    value: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,

    /// `init(value)` de la especificación: valor fijado y enlaces ausentes.
    pub fn init(value: i32) TreeNode {
        return .{ .value = value, .left = null, .right = null };
    }

    /// Valor del nodo.
    pub fn valueOf(self: *const TreeNode) i32 {
        return self.value;
    }

    /// Enlace izquierdo, o `null` cuando está ausente.
    pub fn leftOf(self: *const TreeNode) ?*TreeNode {
        return self.left;
    }

    /// Enlace derecho, o `null` cuando está ausente.
    pub fn rightOf(self: *const TreeNode) ?*TreeNode {
        return self.right;
    }

    /// Reemplaza el enlace izquierdo con `left`, o lo deja ausente con `null`.
    pub fn setLeft(self: *TreeNode, left: ?*TreeNode) void {
        self.left = left;
    }

    /// Reemplaza el enlace derecho con `right`, o lo deja ausente con `null`.
    pub fn setRight(self: *TreeNode, right: ?*TreeNode) void {
        self.right = right;
    }
};

pub const BinaryTree = struct {
    root: ?*TreeNode,
    count: usize,
    allocator: Allocator,

    /// `init()` de la especificación: raíz ausente y contador a cero.
    pub fn init(allocator: Allocator) BinaryTree {
        return .{ .root = null, .count = 0, .allocator = allocator };
    }

    /// Inserta `value`; un duplicado también es éxito y no crece el tamaño.
    /// Desciende por la invariante del ABB con un bucle, sin recursión.
    pub fn insert(self: *BinaryTree, value: i32) bool {
        if (self.root == null) {
            const node = self.allocator.create(TreeNode) catch return false;
            node.* = TreeNode.init(value);
            self.root = node;
            self.count += 1;
            return true;
        }
        var current = self.root.?;
        while (true) {
            if (value == current.valueOf()) {
                return true;
            }
            if (value < current.valueOf()) {
                if (current.leftOf()) |left| {
                    current = left;
                } else {
                    const node = self.allocator.create(TreeNode) catch return false;
                    node.* = TreeNode.init(value);
                    current.setLeft(node);
                    self.count += 1;
                    return true;
                }
            } else {
                if (current.rightOf()) |right| {
                    current = right;
                } else {
                    const node = self.allocator.create(TreeNode) catch return false;
                    node.* = TreeNode.init(value);
                    current.setRight(node);
                    self.count += 1;
                    return true;
                }
            }
        }
    }

    /// `true` si `value` pertenece al árbol; `false` si no.
    pub fn contains(self: *const BinaryTree, value: i32) bool {
        var current = self.root;
        while (current) |node| {
            if (value == node.valueOf()) {
                return true;
            }
            current = if (value < node.valueOf()) node.leftOf() else node.rightOf();
        }
        return false;
    }

    /// `true` solo si no hay nodos.
    pub fn isEmpty(self: *const BinaryTree) bool {
        return self.count == 0;
    }

    /// Número de valores distintos del árbol.
    pub fn len(self: *const BinaryTree) usize {
        return self.count;
    }
};

/// Vecino del grafo: etiqueta del extremo y enlace al siguiente vecino, en
/// orden creciente y sin duplicados. Interno a `Graph`.
const NeighborNode = struct {
    label: i32,
    next: ?*NeighborNode,
};

/// Vértice del registro canónico: etiqueta, adyacencia y enlace al siguiente
/// vértice. Interno a `Graph`.
const GraphNode = struct {
    value: i32,
    neighbors: ?*NeighborNode,
    next_vertex: ?*GraphNode,

    /// `init(label)` interno: sin vecinos y sin siguiente.
    fn init(label: i32) GraphNode {
        return .{ .value = label, .neighbors = null, .next_vertex = null };
    }
};

/// Búsqueda lineal por etiqueta sobre el registro enlazado.
fn findVertex(vertices: ?*GraphNode, label: i32) ?*GraphNode {
    var current = vertices;
    while (current) |node| {
        if (node.value == label) {
            return node;
        }
        current = node.next_vertex;
    }
    return null;
}

/// Recorrido manual de la adyacencia, sin `indexOf` de la biblioteca.
fn findNeighbor(vertex: *const GraphNode, label: i32) bool {
    var current = vertex.neighbors;
    while (current) |node| {
        if (node.label == label) {
            return true;
        }
        current = node.next;
    }
    return false;
}

/// Inserta `new_node` en la adyacencia manteniendo el orden creciente.
fn insertNeighborSorted(vertex: *GraphNode, new_node: *NeighborNode) void {
    if (vertex.neighbors) |first| {
        if (new_node.label < first.label) {
            new_node.next = first;
            vertex.neighbors = new_node;
            return;
        }
        var previous = first;
        while (previous.next) |next| {
            if (new_node.label < next.label) {
                break;
            }
            previous = next;
        }
        new_node.next = previous.next;
        previous.next = new_node;
        return;
    }
    vertex.neighbors = new_node;
}

pub const Graph = struct {
    vertices: ?*GraphNode,
    vertex_total: usize,
    edges: usize,
    allocator: Allocator,

    /// `init()` de la especificación: registro ausente y contadores a cero.
    pub fn init(allocator: Allocator) Graph {
        return .{ .vertices = null, .vertex_total = 0, .edges = 0, .allocator = allocator };
    }

    /// Registra `label`; un duplicado también es éxito y conserva vecinos.
    pub fn addVertex(self: *Graph, label: i32) bool {
        if (findVertex(self.vertices, label) != null) {
            return true;
        }
        const new_vertex = self.allocator.create(GraphNode) catch return false;
        new_vertex.* = GraphNode.init(label);
        new_vertex.next_vertex = self.vertices;
        self.vertices = new_vertex;
        self.vertex_total += 1;
        return true;
    }

    /// Añade la arista `u → v`; falla si falta un extremo y no muta. Una arista
    /// repetida o un bucle repetido también son éxito, pero no cuentan.
    pub fn addEdge(self: *Graph, u: i32, v: i32) bool {
        const u_vertex = findVertex(self.vertices, u) orelse return false;
        if (findVertex(self.vertices, v) == null) {
            return false;
        }
        if (findNeighbor(u_vertex, v)) {
            return true;
        }
        const new_neighbor = self.allocator.create(NeighborNode) catch return false;
        new_neighbor.* = .{ .label = v, .next = null };
        insertNeighborSorted(u_vertex, new_neighbor);
        self.edges += 1;
        return true;
    }

    /// `true` si la arista `u → v` existe; `false` si no existe o falta un
    /// extremo.
    pub fn hasEdge(self: *const Graph, u: i32, v: i32) bool {
        const u_vertex = findVertex(self.vertices, u) orelse return false;
        return findNeighbor(u_vertex, v);
    }

    /// Vecinos de `u` en orden creciente como copia: slice vacío si el vértice
    /// está aislado y `null` si no existe.
    pub fn getNeighbors(self: *const Graph, u: i32) ?[]i32 {
        const u_vertex = findVertex(self.vertices, u) orelse return null;
        var total: usize = 0;
        var current = u_vertex.neighbors;
        while (current) |node| {
            total += 1;
            current = node.next;
        }
        const result = self.allocator.alloc(i32, total) catch return null;
        var index: usize = 0;
        current = u_vertex.neighbors;
        while (current) |node| {
            result[index] = node.label;
            index += 1;
            current = node.next;
        }
        return result;
    }

    /// `true` solo si no hay vértices.
    pub fn isEmpty(self: *const Graph) bool {
        return self.vertex_total == 0;
    }

    /// Número de vértices registrados.
    pub fn vertexCount(self: *const Graph) usize {
        return self.vertex_total;
    }

    /// Número de aristas registradas.
    pub fn edgeCount(self: *const Graph) usize {
        return self.edges;
    }
};
