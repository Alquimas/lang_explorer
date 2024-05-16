module utils.utils;

import lexer.lexer;
import errors.errors;
import parser.parser;
import parser.nodes;
import lexer.token;
import solver.solver;
import std.stdio: writeln, readln, write;
import std.file: readText;
import std.conv: to;

public static void runFile(const string file) {

    auto source = readText(file);
    Lexer lexed = new Lexer(source);
    try {
        Token[] tokens = lexed.lexInput();
        writeln("\nThe file after the lexing is: \n\n"
        ~ lexed.toString());
        Parser parser = new Parser(tokens);
        write("\nThe parsing tree is: \n\n"
                ~ parser.toString());
        Node* root = parser.parserTokens();
        writeln("That expression evaluates to: "
               ~ to!string(solve(root)));
    } catch (LexingError e) {
        writeln(e.message);
    } catch (ParsingError e) {
        writeln(e.message);
    } catch (DivisionByZero e) {
        writeln(e.message);
    } catch (BadOperands e) {
        writeln(e.message);
    }
}

public static void runRepl() {

    while(true)
    {
        write("> ");
        Lexer lexed = new Lexer(readln());
        try {
            Token[] tokens = lexed.lexInput();
            writeln("\nThe string after the lexing is: \n\n"
                    ~ lexed.toString());
            Parser parser = new Parser(tokens);
            Node* root = parser.parserTokens();
            write("\nThe parsing tree is: \n\n"
                    ~ parser.toString());
            writeln("That expression evaluates to: "
                ~ to!string(solve(root)));
        } catch (LexingError e) {
            writeln(e.message);
        } catch (ParsingError e) {
            writeln(e.message);
        } catch (DivisionByZero e) {
            writeln(e.message);
        } catch (BadOperands e) {
            writeln(e.message);
        }
    }
}
