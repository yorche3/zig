// data_structures_basics — Node, lista enlazada, pila y cola.
//
// Especificación: 06_Data_Structures_Basics
//
// Contrato: un único tipo de celda, `Node`, compartido por las tres estructuras
// (`LinkedList`, `Stack` y `Queue`); cada una guarda sus propios punteros y su
// contador y no delega en `LinkedList`. El valor de la celda se fija al
// construirla y el enlace se reengancha escribiendo el campo `next`.
// Las tres estructuras piden un `Allocator` en `init` y lo sueltan en `deinit`,
// porque en Zig la celda se reserva en el montón.
//
// Indicadores de fallo (valores representables, sin excepciones):
//   - **i32 → -1**: `headValue`, `pop`, `peek` y `dequeue` cuando la estructura
//     está vacía; `valueOf` y `len` devuelven su valor real.
//   - **bool → false**: `remove` cuando el valor no estaba.
//   - **Solo los nodos y los enlaces usan nulo**: `next` es `?*Node` y `null` es la
//     ausencia de enlace. Zig no tiene excepciones: el agotamiento de memoria
//     viaja por el error union `!void` de las inserciones, que es la firma del
//     borrador.
//
// Mutabilidad y memoria: las tres estructuras mutan en sitio y reservan cada celda
// con el `Allocator` que reciben en `init`, así que cada escenario trabaja con una
// instancia, la usa y la suelta con `deinit` (que recorre la cadena y libera las
// celdas).
//
// Complejidad: O(1) en `headValue`, `insertHead`, `insertTail`, `push`, `pop`,
// `peek`, `enqueue`, `dequeue`, `isEmpty` y `len` —las estructuras guardan sus
// punteros (cabeza/cola, cima, frente/final) y su contador— y O(n) en `remove` y
// en los `deinit`, como pide la especificación.
//
// Nombres: `camelCase` como el borrador (`insertHead`, `isEmpty`, `headValue`,
// `nextOf`). El borrador de `Node` declaraba el campo `value` y **también** un
// método `value()`; Zig los rechaza (`error: duplicate struct member name
// 'value'`), así que el lector del valor se llama `valueOf`, en paralelo a
// `nextOf`.

const std = @import("std");
const Allocator = std.mem.Allocator;

// ---------------------------------------------------------------------------
// Node
// ---------------------------------------------------------------------------

/// Celda enlazada compartida por LinkedList, Stack y Queue.
/// El valor se fija al construirla; el enlace es mutable.
pub const Node = struct {
    value: i32,
    next: ?*Node,

    /// Crea la celda con `value` y el enlace ausente (el `init` de la
    /// especificación). Queda implementado: es el estado inicial del contrato.
    pub fn init(value: i32) Node {
        return .{
            .value = value,
            .next = null,
        };
    }

    /// Valor de la celda. No muta.
    pub fn valueOf(self: *const Node) i32 {
        return self.value;
    }

    /// Enlace a la celda siguiente, o null cuando no hay ninguna.
    pub fn nextOf(self: *const Node) ?*Node {
        return self.next;
    }
};

// ---------------------------------------------------------------------------
// LinkedList
// ---------------------------------------------------------------------------

/// Lista enlazada simple construida desde cero sobre Node.
pub const LinkedList = struct {
    head: ?*Node,
    tail: ?*Node,
    count: usize,
    allocator: Allocator,

    /// Crea una lista vacía: sin enlaces y con el contador a cero (el `init` de la
    /// especificación). Queda implementado: es el estado inicial del contrato.
    pub fn init(allocator: Allocator) LinkedList {
        return .{
            .head = null,
            .tail = null,
            .count = 0,
            .allocator = allocator,
        };
    }

    /// Suelta todos los nodos de la lista. O(n).
    pub fn deinit(self: *LinkedList) void {
        var current = self.head;
        while (current) |node| {
            const next = node.next;
            self.allocator.destroy(node);
            current = next;
        }
        self.head = null;
        self.tail = null;
        self.count = 0;
    }

    /// Valor de la cabeza, o -1 cuando la lista está vacía. No muta.
    pub fn headValue(self: *const LinkedList) i32 {
        const head = self.head orelse return -1;
        return head.value;
    }

    /// true solo si no hay nodos.
    pub fn isEmpty(self: *const LinkedList) bool {
        return self.head == null;
    }

    /// Número de nodos. O(1) sobre el contador.
    pub fn len(self: *const LinkedList) usize {
        return self.count;
    }

    /// Inserta al principio. O(1). Falla solo si no hay memoria.
    pub fn insertHead(self: *LinkedList, value: i32) !void {
        const new_head = try self.allocator.create(Node);
        new_head.* = Node{
            .value = value,
            .next = self.head,
        };
        self.head = new_head;
        if (self.tail == null) {
            self.tail = new_head;
        }
        self.count += 1;
    }

    /// Inserta al final. O(1). Falla solo si no hay memoria.
    pub fn insertTail(self: *LinkedList, value: i32) !void {
        const new_rear = try self.allocator.create(Node);
        new_rear.* = Node{
            .value = value,
            .next = null,
        };
        if (self.tail) |tail| {
            tail.next = new_rear;
        } else {
            self.head = new_rear;
        }
        self.tail = new_rear;
        self.count += 1;
    }

    /// Borra la primera aparición; false cuando el valor no estaba. O(n).
    pub fn remove(self: *LinkedList, value: i32) bool {
        var current = self.head;
        var prev: ?*Node = null;
        while (current) |node| {
            if (node.value == value) {
                if (prev) |p| {
                    p.next = node.next;
                } else {
                    self.head = node.next;
                }
                if (self.tail == node) {
                    self.tail = prev;
                }
                self.allocator.destroy(node);
                self.count -= 1;
                return true;
            }
            prev = current;
            current = node.next;
        }
        return false;
    }
};

// ---------------------------------------------------------------------------
// Stack
// ---------------------------------------------------------------------------

/// Pila LIFO construida desde cero sobre Node.
pub const Stack = struct {
    top: ?*Node,
    count: usize,
    allocator: Allocator,

    /// Crea una pila vacía: sin cima y con el contador a cero (el `init` de la
    /// especificación). Queda implementado: es el estado inicial del contrato.
    pub fn init(allocator: Allocator) Stack {
        return .{
            .top = null,
            .count = 0,
            .allocator = allocator,
        };
    }

    /// Suelta todos los nodos de la pila. O(n).
    pub fn deinit(self: *Stack) void {
        var current = self.top;
        while (current) |node| {
            const next = node.next;
            self.allocator.destroy(node);
            current = next;
        }
        self.top = null;
        self.count = 0;
    }

    /// true solo si no hay nodos.
    pub fn isEmpty(self: *const Stack) bool {
        return self.top == null;
    }

    /// Número de nodos. O(1) sobre el contador.
    pub fn len(self: *const Stack) usize {
        return self.count;
    }

    /// Apila sobre la cima. O(1). Falla solo si no hay memoria.
    pub fn push(self: *Stack, value: i32) !void {
        const new_top = try self.allocator.create(Node);
        new_top.* = Node{
            .value = value,
            .next = self.top,
        };
        self.top = new_top;
        self.count += 1;
    }

    /// Desapila el valor de la cima, o -1 cuando está vacía. O(1).
    pub fn pop(self: *Stack) i32 {
        if (self.top) |node| {
            self.top = node.next;
            self.count -= 1;
            const value = node.value;
            self.allocator.destroy(node);
            return value;
        } else {
            return -1;
        }
    }

    /// Valor de la cima, o -1 cuando está vacía. No muta.
    pub fn peek(self: *const Stack) i32 {
        if (self.top) |node| {
            return node.value;
        } else {
            return -1;
        }
    }
};

// ---------------------------------------------------------------------------
// Queue
// ---------------------------------------------------------------------------

/// Cola FIFO construida desde cero sobre Node.
pub const Queue = struct {
    front: ?*Node,
    rear: ?*Node,
    count: usize,
    allocator: Allocator,

    /// Crea una cola vacía: sin frente, sin final y con el contador a cero (el
    /// `init` de la especificación). Queda implementado: es el estado inicial del
    /// contrato.
    pub fn init(allocator: Allocator) Queue {
        return .{
            .front = null,
            .rear = null,
            .count = 0,
            .allocator = allocator,
        };
    }

    /// Suelta todos los nodos de la cola. O(n).
    pub fn deinit(self: *Queue) void {
        var current = self.front;
        while (current) |node| {
            const next = node.next;
            self.allocator.destroy(node);
            current = next;
        }
        self.front = null;
        self.rear = null;
        self.count = 0;
    }

    /// true solo si no hay nodos.
    pub fn isEmpty(self: *const Queue) bool {
        return self.front == null;
    }

    /// Número de nodos. O(1) sobre el contador.
    pub fn len(self: *const Queue) usize {
        return self.count;
    }

    /// Encola por el final. O(1). Falla solo si no hay memoria.
    pub fn enqueue(self: *Queue, value: i32) !void {
        const new_node = try self.allocator.create(Node);
        new_node.* = Node{
            .value = value,
            .next = null,
        };
        if (self.rear) |rear_node| {
            rear_node.next = new_node;
        } else {
            self.front = new_node;
        }
        self.rear = new_node;
        self.count += 1;
    }

    /// Desencola el valor del frente, o -1 cuando está vacía. O(1).
    pub fn dequeue(self: *Queue) i32 {
        if (self.front) |front_node| {
            self.front = front_node.next;
            if (self.front == null) {
                self.rear = null;
            }
            self.count -= 1;
            const value = front_node.value;
            self.allocator.destroy(front_node);
            return value;
        } else {
            return -1;
        }
    }

    /// Valor del frente, o -1 cuando está vacía. No muta.
    pub fn peek(self: *const Queue) i32 {
        if (self.front) |front_node| {
            return front_node.value;
        } else {
            return -1;
        }
    }
};
