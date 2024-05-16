module lexer.lexer;

import lexer.token;
import errors.errors;

/**
 * The lexer class. It receives a string as input and convert
 * it to a array of tokens using the lexInput() method.
 * Params:
 *  _source = a string with the input to be lexed.
 */
class Lexer {
    private string _source;
    private Token[] _tokens = [ ];
    private int _start = 0;
    private int _current = 0;
    private int _line = 1;

    public this(string source) {
        this._source = source;
    }

    /**
     * The lexer main function. Generates a array of Tokens from a source file.
     * Returns:
     *  A Array of lexed tokens.
     * Throws:
     *  <b>LexingError</b> if it finds a character than cant be lexed.
     */
    public Token[] lexInput() {
        _tokens = [ ];

        while(!isAtEnd()) {
            _start = _current;
            scanToken();
        }
        _tokens ~= Token(TokenType.EOF, 0, _line);
        return _tokens;
    }

    /**
     * Verify if the current pointer reached the end of the file
     */
    private bool isAtEnd() {
        return _current >= _source.length;
    }

    /**
     * Advance current by one and returns the value than current where
     * pointing before.
     **/
    private char advance() {
        _current++;
        return _source[_current - 1];
    }

    /**
     * Verify if some char matches the current pointed char. Returns false
     * and don't increase current if
     * isAtEnd() is true, i.e., the current pointer reached the end of the file.
     * Returns true and increase the current pointer otherwise.
     */
    private bool match(char expected) {
        if(isAtEnd()) {
            return false;
        }

        if(_source[_current] != expected) {
            return false;
        }

        _current++;
        return true;
    }

    /**
     * Returns the char pointed by current or EOF if it has reached the end of
     * the file.
     */
    private char peek() {
        if(isAtEnd()) {
            return '\0';
        }

        return _source[_current];
    }

    /**
     * Returns true if the char is a digit.
     */
    private bool isDigit(const char c) {
        return c >= '0' && c <= '9';
    }

    /**
     * Scan all numbers starting from the _start pointer and adds a NUMBER
     * Token at the end.
     */
    private void scanNumber() {
        int _result = _source[_start] - '0';
        while(isDigit(peek())) {
            _result = 10 * _result + (_source[_current] - '0');
            advance();
        }

        addToken(TokenType.NUMBER, _result);
    }

    /**
     * scan the next Token in the source string, and add it to the tokens list.
     * Throws:
     *  <b>RuntimeError</b> if it finds a character than cant be lexed.
     */
    private void scanToken() {
        const c = advance();

        with (TokenType) switch (c) {
            case '(': addToken(LEFT_PAREN); break;
            case ')': addToken(RIGHT_PAREN); break;
            case '*':
                if(match('*')) {
                    addToken(POW_SIGN);
                } else {
                    addToken(MUL_SIGN);
                }
                break;
            case '+': addToken(SUM_SIGN); break;
            case '-': addToken(MINUS_SIGN); break;
            case '/': addToken(DIV_SIGN); break;
            case '0': .. case '9':
                scanNumber();
                break;

            // Ignore whitespaces
            case ' ': case '\t': break;

            case '\n':
                _line += 1;
                break;

            default:
                throw new LexingError(c, _line);
        }
    }

    /**
     * Adds a token to the _tokens list
     */
    private void addToken(TokenType type) {
        _tokens ~= Token(type, 0, _line);
    }

    /**
     * Adds a token to the _tokens list
     */
    private void addToken(TokenType type, int value) {
        _tokens ~= Token(type, value, _line);
    }

    /**
     * Returns the _tokens inside the lexer object as a string.
     */
    override string toString() const {
        auto lex_string = "";
        int aline = 1;

        lex_string ~= _tokens[0].toString();

        for(int i = 1; i < _tokens.length; i++) {
            if(_tokens[i].line > aline) {
                lex_string ~= '\n';
                aline = _tokens[i].line;
            } else {
                lex_string ~= ' ';
            }
            lex_string ~= _tokens[i].toString();
        }

        return lex_string;
    }
}
