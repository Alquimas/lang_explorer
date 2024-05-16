module errors.errors;

import lexer.token;
import std.conv: to;

public class LexingError: Exception
{
    public this(char unexpected_char, int line)
    {
        super("Error while lexing:\n"
                        ~ "    Unexpected character '"
                        ~ unexpected_char
                        ~ "' found at line "
                        ~ to!string(line));
    }
}

public class ParsingError: Exception
{
    public this(Token unexpected_token, int line)
    {
        super("Error while parsing:\n"
                ~ "    Unexpected token '"
                ~ unexpected_token.toString()
                ~ "' found at line "
                ~ to!string(line));
    }
}

public class DivisionByZero: Exception
{
    public this () {
        super("Error: Division by zero found");
    }
}

public class BadOperands: Exception
{
    public this(string operation) {
        super("Error: Bad operands for: " ~ operation);
    }
}
