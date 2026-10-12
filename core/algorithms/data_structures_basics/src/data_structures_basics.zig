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
// Adecuaciones de salida de centinela (todavía no hay fallos reales):
//   - **i32 → -1**: `headValue`, `pop`, `peek` y `dequeue`, que son las lecturas
//     que pueden fallar, mientras su cuerpo sea un esqueleto.
//   - **bool → false**: `isEmpty` y `remove`.
//   - **usize → 0**: `len`; el centinela -1 no cabe en un entero sin signo.
//   - **Solo los nodos y los enlaces usan nulo**: `next` es `?*Node` y `null` es la
//     ausencia de enlace. Zig no tiene excepciones: el agotamiento de memoria
//     viaja por el error union `!void` de las inserciones, que es la firma del
//     borrador.
//
// `init` de la especificación: `Node.init(valor)` deja la celda con su valor y sin
// enlace, y `LinkedList.init(allocator)` —igual `Stack` y `Queue`— deja la
// estructura vacía. Los `init` quedan implementados y el resto de los cuerpos son
// esqueletos con el centinela de su tipo: la implementación es el paso 5.
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

    /// Esqueleto: valor de la celda.
    pub fn valueOf(self: *const Node) i32 {
        _ = self;
        return -1;
    }

    /// Esqueleto: enlace a la celda siguiente, o null cuando no hay ninguna.
    pub fn nextOf(self: *const Node) ?*Node {
        _ = self;
        return null;
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

    /// Esqueleto: suelta todos los nodos de la lista. O(n).
    pub fn deinit(self: *LinkedList) void {
        _ = self;
    }

    /// Esqueleto: valor de la cabeza, o -1 cuando la lista está vacía. No muta.
    pub fn headValue(self: *const LinkedList) i32 {
        _ = self;
        return -1;
    }

    /// Esqueleto: true solo si no hay nodos.
    pub fn isEmpty(self: *const LinkedList) bool {
        _ = self;
        return false;
    }

    /// Esqueleto: número de nodos. Es `usize`, así que devuelve 0.
    pub fn len(self: *const LinkedList) usize {
        _ = self;
        return 0;
    }

    /// Esqueleto: inserta al principio. O(1). Falla solo si no hay memoria.
    pub fn insertHead(self: *LinkedList, value: i32) !void {
        _ = self;
        _ = value;
    }

    /// Esqueleto: inserta al final. O(1). Falla solo si no hay memoria.
    pub fn insertTail(self: *LinkedList, value: i32) !void {
        _ = self;
        _ = value;
    }

    /// Esqueleto: borra la primera aparición; false cuando el valor no estaba.
    /// O(n).
    pub fn remove(self: *LinkedList, value: i32) bool {
        _ = self;
        _ = value;
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

    /// Esqueleto: suelta todos los nodos de la pila. O(n).
    pub fn deinit(self: *Stack) void {
        _ = self;
    }

    /// Esqueleto: true solo si no hay nodos.
    pub fn isEmpty(self: *const Stack) bool {
        _ = self;
        return false;
    }

    /// Esqueleto: número de nodos. Es `usize`, así que devuelve 0.
    pub fn len(self: *const Stack) usize {
        _ = self;
        return 0;
    }

    /// Esqueleto: apila sobre la cima. O(1). Falla solo si no hay memoria.
    pub fn push(self: *Stack, value: i32) !void {
        _ = self;
        _ = value;
    }

    /// Esqueleto: desapila el valor de la cima, o -1 cuando está vacía. O(1).
    pub fn pop(self: *Stack) i32 {
        _ = self;
        return -1;
    }

    /// Esqueleto: valor de la cima, o -1 cuando está vacía. No muta.
    pub fn peek(self: *const Stack) i32 {
        _ = self;
        return -1;
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

    /// Esqueleto: suelta todos los nodos de la cola. O(n).
    pub fn deinit(self: *Queue) void {
        _ = self;
    }

    /// Esqueleto: true solo si no hay nodos.
    pub fn isEmpty(self: *const Queue) bool {
        _ = self;
        return false;
    }

    /// Esqueleto: número de nodos. Es `usize`, así que devuelve 0.
    pub fn len(self: *const Queue) usize {
        _ = self;
        return 0;
    }

    /// Esqueleto: encola por el final. O(1). Falla solo si no hay memoria.
    pub fn enqueue(self: *Queue, value: i32) !void {
        _ = self;
        _ = value;
    }

    /// Esqueleto: desencola el valor del frente, o -1 cuando está vacía. O(1).
    pub fn dequeue(self: *Queue) i32 {
        _ = self;
        return -1;
    }

    /// Esqueleto: valor del frente, o -1 cuando está vacía. No muta.
    pub fn peek(self: *const Queue) i32 {
        _ = self;
        return -1;
    }
};
