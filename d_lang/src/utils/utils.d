module utils.utils;

import lexer.lexer;
import errors.errors;
import parser.parser;
import lexer.token;
import std.stdio: writeln, readln, write;
import std.file: readText;

public static void runFile(const string file) {

    auto source = readText(file);
    Lexer lexed = new Lexer(source);
    try {
        lexed.lexInput();
        writeln(lexed.toString());
    } catch (RuntimeError e) {
        writeln("Caught exception:", e.message);
    }
}

public static void runRepl() {

    while(true)
    {
        write("> ");
        Lexer lexed = new Lexer(readln());
        try {
            Token[] tokens = lexed.lexInput();
            writeln(lexed.toString());
            Parser parser = new Parser(tokens);
            parser.parserTokens();
            writeln(parser.toString());
        } catch (RuntimeError e) {
            writeln("Caught exception: ", e.message);
        }
    }
}
