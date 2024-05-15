module errors.errors;

import lexer.token;

public class RuntimeError: Exception
{
    public this(string message)
    {
        super(message);
    }
}
