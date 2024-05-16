module solver.solver;

import std.math.operations : isClose;
import std.math.traits : isNaN;
import parser.nodes;
import lexer.token;
import errors.errors;

double solve(Node* node) {
    with(NodeType) switch (node.type) {
        case ROOT:
            return solve(node.right);
        case BINARY:
            with(TokenType) switch(node.value.type) {
                case SUM_SIGN:
                    return solve(node.left)
                        + solve(node.right);
                case MUL_SIGN:
                    return solve(node.left)
                        * solve(node.right);
                case MINUS_SIGN:
                    return solve(node.left)
                        - solve(node.right);
                case DIV_SIGN:
                    if(isClose(solve(node.right), 0.0)) {
                        throw new DivisionByZero();
                    } else {
                        return cast(double)solve(node.left)
                            / cast(double)solve(node.right);
                    }
                case POW_SIGN:
                    auto res = solve(node.left)
                        ^^ solve(node.right);
                    if(isNaN(res)) {
                        throw new BadOperands("Exponentiation");
                    } else {
                        return res;
                    }
                default:
                    throw new Exception("Unexpected error");
            }
            break;
        case UNARY:
            with(TokenType) switch(node.value.type) {
                case SUM_SIGN:
                    return solve(node.right);
                case MINUS_SIGN:
                    return -1 * solve(node.right);
                default:
                    throw new Exception("Unexpected error");
            }
            break;
        case PAR_EXPR:
            return solve(node.right);
        case SINGLE:
            return solve(node.right);
        case TERMINAL:
            return node.value.value;
        default:
            // If the implentation is correct
            // this error is impossible.
            throw new Exception("Unexpected error");
    }
}
