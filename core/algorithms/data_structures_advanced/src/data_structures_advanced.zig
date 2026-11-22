const Allocator = @import("std").mem.Allocator;

pub const TreeNode = struct {
    value: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,

    pub fn init(_: i32) TreeNode {
        return .{ .value = 0, .left = null, .right = null };
    }

    pub fn valueOf(_: *const TreeNode) i32 {
        return 0;
    }

    pub fn leftOf(_: *const TreeNode) ?*TreeNode {
        return null;
    }

    pub fn rightOf(_: *const TreeNode) ?*TreeNode {
        return null;
    }

    pub fn setLeft(_: *TreeNode, _: ?*TreeNode) void {}

    pub fn setRight(_: *TreeNode, _: ?*TreeNode) void {}
};

pub const BinaryTree = struct {
    root: ?*TreeNode,
    count: usize,
    allocator: Allocator,

    pub fn init(allocator: Allocator) BinaryTree {
        return .{ .root = null, .count = 0, .allocator = allocator };
    }

    pub fn insert(_: *BinaryTree, _: i32) bool {
        return false;
    }

    pub fn contains(_: *const BinaryTree, _: i32) bool {
        return false;
    }

    pub fn isEmpty(_: *const BinaryTree) bool {
        return false;
    }

    pub fn len(_: *const BinaryTree) usize {
        return 0;
    }
};

const NeighborNode = struct {
    label: i32,
    next: ?*NeighborNode,
};

const GraphNode = struct {
    value: i32,
    neighbors: ?*NeighborNode,
    next_vertex: ?*GraphNode,

    fn init(_: i32) GraphNode {
        return .{ .value = 0, .neighbors = null, .next_vertex = null };
    }
};

pub const Graph = struct {
    vertices: ?*GraphNode,
    vertex_total: usize,
    edges: usize,
    allocator: Allocator,

    pub fn init(allocator: Allocator) Graph {
        return .{ .vertices = null, .vertex_total = 0, .edges = 0, .allocator = allocator };
    }

    pub fn addVertex(_: *Graph, _: i32) bool {
        return false;
    }

    pub fn addEdge(_: *Graph, _: i32, _: i32) bool {
        return false;
    }

    pub fn hasEdge(_: *const Graph, _: i32, _: i32) bool {
        return false;
    }

    pub fn getNeighbors(_: *const Graph, _: i32) ?[]i32 {
        return null;
    }

    pub fn isEmpty(_: *const Graph) bool {
        return false;
    }

    pub fn vertexCount(_: *const Graph) usize {
        return 0;
    }

    pub fn edgeCount(_: *const Graph) usize {
        return 0;
    }
};
