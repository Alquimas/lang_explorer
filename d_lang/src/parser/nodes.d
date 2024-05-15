module parser.nodes;

import lexer.token;

enum NodeType {
    ROOT,
    BINARY,
    UNARY,
    PAR_EXPR,
    SINGLE,
    TERMINAL
}

enum Production {
    S, E, F, G, H, I
}

public struct Node {
    NodeType type;
    Production prod;
    Token value;
    Node* left;
    Node* right;

    public this (NodeType type, Production prod, Token value, Node* left, Node* right)
    {
        this.type = type;
        this.prod = prod;
        this.value = value;
        this.left = left;
        this.right = right;
    }
}
