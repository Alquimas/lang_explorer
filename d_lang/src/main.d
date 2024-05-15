import lexer.lexer;
import utils.utils;
import std.stdio: writeln;

void main(string[] args) {
    if (args.length > 2)
    {
        writeln("Usage: deelox <script>");
    }
    else if (args.length == 2)
    {
        runFile(args[1]);
    }
    else
    {
        runRepl();
    }
}
