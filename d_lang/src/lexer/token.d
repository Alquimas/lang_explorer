module lexer.token;

import std.conv: to;

/**
 * A type from a token
 */
enum TokenType {
    // Single char
    SUM_SIGN, MINUS_SIGN, MUL_SIGN, DIV_SIGN,
    LEFT_PAREN, RIGHT_PAREN,

    // Two char
    POW_SIGN,

    // Literal
    NUMBER,

    EOF
}

/**
 * A token composed from a TokenType and two values.
 * Params:
 *  type = the type of the token.
 *  value = value from the token. it's zero
 *          if the token is not from the NUMBER type.
 *  line = the line where the token was read.
 */
public struct Token {
    public TokenType type;
    public int value;
    public int line;

    public this (TokenType type, int value, int line) {
        this.type = type;
        this.value = value;
        this.line = line;
    }

    /**
     * Returns the token as a string.
     * Returns:
     *  A string representation from the Token.
     */
    public string toString() const {
        auto lit = "";

        with(TokenType) switch(type) {
            case NUMBER:
                lit = to!string(value);
                break;
            default:
                break;
        }

        return to!string(type) ~ "(" ~ lit ~ ")";
    }
}
