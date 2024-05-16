module parser.nodes;

import lexer.token;

/**
 * The type of a node.
 *
 * The possible types are:
 * - ROOT
 * - BINARY
 * - UNARY
 * - PAR_EXPR
 * - SINGLE
 * - TERMINAL
 */
enum NodeType {
    ROOT,
    BINARY,
    UNARY,
    PAR_EXPR,
    SINGLE,
    TERMINAL
}

/**
 * The type of a production rule.
 *
 * The possible types are:
 * - S
 * - E
 * - F
 * - G
 * - H
 * - I
 */
enum Production {
    S, E, F, G, H, I
}

/**
 * A node from the AST.
 * Params:
 *  type = A NodeType than specifies the type from the node.
 *  prod = A Production than specifies the production from the node.
 *  value = A Token than stores the value from the node.
 *  left = A Node* than points to the node on the left.
 *  right = A Node* than points to the node on the right.
 * See_Also:
 *  Read the fuctions than create the specific types of nodes and
 *  how each field is filled in each case. Sometimes the fields
 *  receive a nonessential value, this means than that field
 *  is not supposed to be used.
 */
public struct Node {
    NodeType type;
    Production prod;
    Token value;
    Node* left;
    Node* right;

    public this (NodeType type,
            Production prod,
            Token value,
            Node* left,
            Node* right)
    {
        this.type = type;
        this.prod = prod;
        this.value = value;
        this.left = left;
        this.right = right;
    }
}

/**
 * Returns:
 *  A Node* from the ROOT type.
 *
 * This node is filled with:
 * - type is ROOT.
 * - prod is S.
 * - value is a nonessential Token.
 * - left is always null.
 * - right is filled with another Node.
 */
public Node* createRoot() {
    return new Node(NodeType.ROOT,
            Production.S,
            Token(TokenType.EOF, 0, 0),
            null,
            null,);
}

/**
 * Returns:
 *  A Node* from the TERMINAL type.
 *
 * Params:
 *  value = A token stored in the node
 *
 * This node is filled with:
 * - type is TERMINAL.
 * - prod is a nonessential production.
 * - value is the value passed as argument.
 * - left is always null.
 * - right is always null.
 */
public Node* createTerminal(Token value) {
    return new Node(NodeType.TERMINAL,
            Production.S,
            value,
            null,
            null);
}

/**
 * Returns:
 *  a Node* from the BINARY type.
 *
 * Params:
 *  prod = The production than derives this Node.
 *  value = The Token with the Binary operation of this Node.
 *  left = The Node with the left operand of this operation.
 *  right = The Node with the right operand of this operation.
 *
 * This node is filled with:
 * - type is BINARY
 * - prod is the prod passed as argument.
 * - value is the value passed as argument.
 * - left is the left Node passed as argument.
 * - right is the right Node passed as argument.
 */
public Node* createBinary(Production prod,
        Token value,
        Node* left,
        Node* right)
{
    return new Node(NodeType.BINARY,
            prod,
            value,
            left,
            right);
}

/**
 * Returns:
 *  a Node* from the SINGLE type.
 *
 * Params:
 *  prod = The production than derives this Node.
 *  right = The Node than follows from this one.
 *
 * This node is filled with:
 * - type is SINGLE
 * - prod is the prod passed as argument.
 * - value is a nonessential value.
 * - left is always null.
 * - right is the right Node passed as argument.
 */
public Node* createSingle(Production prod,
        Node* right)
{
    return new Node(NodeType.SINGLE,
            prod,
            Token(TokenType.EOF, 0, 0),
            null,
            right);
}

/**
 * Returns:
 *  a Node* from the UNARY type.
 *
 * Params:
 *  prod = The production than derives this Node.
 *  prod = The Token with the Unary operation from this Node.
 *  right = The Node than stores the operand from this Node.
 *
 * This node is filled with:
 * - type is UNARY.
 * - prod is the prod passed as argument.
 * - value is the value passed as argument.
 * - left is always null.
 * - right is the right Node passed as argument.
 */
public Node* createUnary(Production prod,
        Token value,
        Node* right)
{
    return new Node(NodeType.UNARY,
            prod,
            value,
            null,
            right);
}

/**
 * Returns:
 *  a Node* from the PAR_EXPR type.
 *
 * Params:
 *  prod = The production than derives this Node.
 *  right = The Node than stores what is inside the parentheses.
 *
 * This node is filled with:
 * - type is PAR_EXPR.
 * - prod is the prod passed as argument.
 * - value is a nonessential value.
 * - left is always null.
 * - right is the right Node passed as argument.
 */
public Node* createParExp(Production prod,
        Node* right)
{
    return new Node(NodeType.PAR_EXPR,
            prod,
            Token(TokenType.EOF, 0, 0),
            null,
            right);
}
