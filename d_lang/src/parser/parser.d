module parser.parser;

import parser.nodes;
import stack;
import lexer.token;

enum Act {
    // Shift
    S00, S01, S02, S03, S04,
    S05, S06, S07, S08, S09,
    S10, S11, S12, S13, S14,
    S15, S16, S17, S18, S19,
    S20, S21, S22, S23,

    // Reduce
    R00, R01, R02, R03, R04,
    R05, R06, R07, R08, R09,
    R10, R11, R12, R13,

    ACC,
    ERR
}

enum Goto {
    G00, G01, G02, G03, G04,
    G05, G06, G07, G08, G09,
    G10, G11, G12, G13, G14,
    G15, G16, G17, G18, G19,
    G20, G21, G22, G23, ZZZ
}

enum ReduceType {
    RED_TO_ROOT,
    RED_TO_BINARY,
    RED_TO_UNARY,
    RED_TO_SINGLE,
    RED_TO_PAREXP
}

public struct ReduceEntry {
    Production prod;
    ReduceType type;
}

    /*[ SUM    , MINUS  , MUL    , DIV    , OPENPAR,
      CLOSPAR, POW,   , NUMBER , EOF     */
const Act[][] actTable = [
    [ Act.S05, Act.S04, Act.ERR, Act.ERR, Act.S08, /*00*/
    Act.ERR, Act.ERR, Act.S09, Act.ERR ],
    [ Act.S10, Act.S11, Act.ERR, Act.ERR, Act.ERR, /*01*/
    Act.ERR, Act.ERR, Act.ERR, Act.ACC ],
    [ Act.R03, Act.R03, Act.S12, Act.S13, Act.ERR, /*02*/
    Act.R03, Act.ERR, Act.ERR, Act.R03 ],
    [ Act.R06, Act.R06, Act.R06, Act.R06, Act.ERR, /*03*/
    Act.R06, Act.ERR, Act.ERR, Act.R06 ],
    [ Act.S05, Act.S04, Act.ERR, Act.ERR, Act.S08, /*04*/
    Act.ERR, Act.ERR, Act.S09, Act.ERR ],
    [ Act.S05, Act.S04, Act.ERR, Act.ERR, Act.S08, /*05*/
    Act.ERR, Act.ERR, Act.S09, Act.ERR ],
    [ Act.R09, Act.R09, Act.R09, Act.R09, Act.ERR, /*06*/
    Act.R09, Act.ERR, Act.ERR, Act.R09 ],
    [ Act.R11, Act.R11, Act.R11, Act.R11, Act.ERR, /*07*/
    Act.R11, Act.S16, Act.ERR, Act.R11 ],
    [ Act.S05, Act.S04, Act.ERR, Act.ERR, Act.S08, /*08*/
    Act.ERR, Act.ERR, Act.S09, Act.ERR ],
    [ Act.R13, Act.R13, Act.R13, Act.R13, Act.ERR, /*09*/
    Act.R13, Act.R13, Act.ERR, Act.R13 ],
    [ Act.S05, Act.S04, Act.ERR, Act.ERR, Act.S08, /*10*/
    Act.ERR, Act.ERR, Act.S09, Act.ERR ],
    [ Act.S05, Act.S04, Act.ERR, Act.ERR, Act.S08, /*11*/
    Act.ERR, Act.ERR, Act.S09, Act.ERR ],
    [ Act.S05, Act.S04, Act.ERR, Act.ERR, Act.S08, /*12*/
    Act.ERR, Act.ERR, Act.S09, Act.ERR ],
    [ Act.S05, Act.S04, Act.ERR, Act.ERR, Act.S08, /*13*/
    Act.ERR, Act.ERR, Act.S09, Act.ERR ],
    [ Act.R07, Act.R07, Act.R07, Act.R07, Act.ERR, /*14*/
    Act.R07, Act.ERR, Act.ERR, Act.R07 ],
    [ Act.R08, Act.R08, Act.R08, Act.R08, Act.ERR, /*15*/
    Act.R08, Act.ERR, Act.ERR, Act.R08 ],
    [ Act.ERR, Act.ERR, Act.ERR, Act.ERR, Act.S08, /*16*/
    Act.ERR, Act.ERR, Act.S09, Act.ERR ],
    [ Act.S10, Act.S11, Act.ERR, Act.ERR, Act.ERR, /*17*/
    Act.S23, Act.ERR, Act.ERR, Act.ERR ],
    [ Act.R01, Act.R01, Act.S12, Act.S13, Act.ERR, /*18*/
    Act.R01, Act.ERR, Act.ERR, Act.R01 ],
    [ Act.R02, Act.R02, Act.S22, Act.S23, Act.ERR, /*19*/
    Act.R02, Act.ERR, Act.ERR, Act.R02 ],
    [ Act.R04, Act.R04, Act.R04, Act.R04, Act.ERR, /*20*/
    Act.R04, Act.ERR, Act.ERR, Act.R04 ],
    [ Act.R05, Act.R05, Act.R05, Act.R05, Act.ERR, /*21*/
    Act.R05, Act.ERR, Act.ERR, Act.R05 ],
    [ Act.R12, Act.R12, Act.R12, Act.R12, Act.ERR, /*22*/
    Act.R12, Act.ERR, Act.ERR, Act.R12 ],
    [ Act.R10, Act.R10, Act.R10, Act.R10, Act.ERR, /*23*/
    Act.R10, Act.R10, Act.ERR, Act.R10 ],
];
    /*S,      , E       , F       , G       , H       , I        */
const Goto[][] gotoTable = [
    [ Goto.ZZZ, Goto.G01, Goto.G02, Goto.G03, Goto.G06, Goto.G07 ], /*00*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ ], /*01*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ ], /*02*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ ], /*03*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.G14, Goto.G06, Goto.G07 ], /*04*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.G15, Goto.G06, Goto.G07 ], /*05*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ ], /*06*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ ], /*07*/
    [ Goto.ZZZ, Goto.G17, Goto.G02, Goto.G03, Goto.G06, Goto.G07 ], /*08*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ ], /*09*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.G18, Goto.G03, Goto.G06, Goto.G07 ], /*10*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.G19, Goto.G03, Goto.G06, Goto.G07 ], /*11*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.G20, Goto.G06, Goto.G07 ], /*12*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.G21, Goto.G06, Goto.G07 ], /*13*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ ], /*14*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ ], /*15*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.G22, Goto.G07 ], /*16*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ ], /*17*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ ], /*18*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ ], /*19*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ ], /*20*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ ], /*21*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ ], /*22*/
    [ Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ, Goto.ZZZ ], /*23*/
];

const ReduceEntry[] reduceTable = [
    {Production.S, ReduceType.RED_TO_ROOT},
    {Production.E, ReduceType.RED_TO_BINARY},
    {Production.E, ReduceType.RED_TO_BINARY},
    {Production.E, ReduceType.RED_TO_SINGLE},
    {Production.F, ReduceType.RED_TO_BINARY},
    {Production.F, ReduceType.RED_TO_BINARY},
    {Production.F, ReduceType.RED_TO_SINGLE},
    {Production.G, ReduceType.RED_TO_UNARY},
    {Production.G, ReduceType.RED_TO_UNARY},
    {Production.G, ReduceType.RED_TO_SINGLE},
    {Production.I, ReduceType.RED_TO_PAREXP},
    {Production.H, ReduceType.RED_TO_SINGLE},
    {Production.H, ReduceType.RED_TO_BINARY},
    {Production.I, ReduceType.RED_TO_SINGLE}
];

import std.stdio: writeln;

public class Parser {
    Stack!(Node*) symbols = new Stack!(Node*);
    Stack!int states = new Stack!int;
    Node* root = new Node(NodeType.ROOT, Production.S, Token(TokenType.EOF, 0, 0), null, null);
    Token[] tokens = [];

    this(Token[] tokens) {
        this.tokens = tokens;
    }

    void parserTokens() {
        states.push(0);
        Act nextStep = Act.ACC;
        int elemCounter = 0;
        Token elem;
        while(true) {
            elem = tokens[elemCounter];
            nextStep = actTable[states.peek()][cast(int)elem.type];
            if(nextStep == Act.ACC) {
                root.type = NodeType.ROOT;
                root.prod = Production.S;
                root.right = symbols.pop();
                break;
            }
            if(nextStep == Act.ERR) {
                throw new Exception("Error while parsing!");
            }
            if(cast(int)nextStep <= cast(int)Act.S23) {

                states.push(cast(int*)nextStep);
                Node* tNode = new Node(NodeType.TERMINAL, Production.S, elem, null, null);
                elemCounter += 1;
                symbols.push(tNode);
            } else {

                ReduceEntry redType = reduceTable[(cast(int)nextStep) - cast(int)Act.R00];

                with(ReduceType) switch(redType.type) {
                    case RED_TO_BINARY:
                        {
                            Node* right = symbols.pop();
                            states.pop();
                            Node* op = symbols.pop();
                            states.pop();
                            Node* left = symbols.pop();
                            states.pop();
                            Node* newNode = new Node(NodeType.BINARY, redType.prod, op.value, left, right);
                            symbols.push(newNode);

                        }
                        break;

                    case RED_TO_SINGLE:
                        {
                            Node* right = symbols.pop();
                            states.pop();
                            Node* newNode =
                                new Node(NodeType.SINGLE, redType.prod, right.value, null, right);
                            symbols.push(newNode);
                        }
                        break;

                    case RED_TO_UNARY:
                        {
                            Node* right = symbols.pop();
                            states.pop();
                            Node* op = symbols.pop();
                            states.pop();

                            Node* newNode =
                                new Node(NodeType.UNARY, redType.prod, op.value, null, right);
                            symbols.push(newNode);
                        }
                        break;

                    case RED_TO_PAREXP:
                        {
                            Node* rightPar = symbols.pop();
                            states.pop();
                            Node* midNode = symbols.pop();
                            states.pop();
                            Node* leftPar = symbols.pop();
                            states.pop();

                            Node* newNode =
                                new Node(NodeType.PAR_EXPR, redType.prod, rightPar.value, leftPar, midNode);
                            symbols.push(newNode);
                        }
                        break;
                    default:
                        throw new Exception("Unexpected error");
                }
                int newState = cast(int)gotoTable[cast(int)states.peek()][cast(int)redType.prod];
                states.push(newState);
            }
        }
    }

import std.conv: to;

    override string toString() const {
        string res = "";
        res ~= to!string(root.prod);
        res ~= "\n\\--";
        res ~= printNode(root.right, "   ");
        res ~= "\n";
        return res;
    }

    private string printNode(const Node* node, const string prefix) const {
        if(node is null) {
            return "";
        }
        string res = "";
        with(NodeType) switch (node.type) {
            case BINARY:
                {
                    res ~= to!string(node.prod);
                    res ~= "\n";
                    res ~= prefix;
                    res ~= "+--";
                    res ~= printNode(node.left, prefix ~ "|  ");
                    res ~= prefix;
                    res ~= "+--";
                    res ~= node.value.toString;
                    res ~= "\n";
                    res ~= prefix;
                    res ~= "\\--";
                    res ~= printNode(node.right, prefix ~ "   ");
                    return res;
                }
                break;
            case UNARY:
                {
                    res ~= to!string(node.prod);
                    res ~= "\n";
                    res ~= prefix;
                    res ~= "+--";
                    res ~= node.value.toString();
                    res ~= "\n";
                    res ~= prefix;
                    res ~= "\\--";
                    res ~= printNode(node.right, prefix ~ "   ");
                    return res;
                }
                break;
            case PAR_EXPR:
                {
                    res ~= to!string(node.prod);
                    res ~= "\n";
                    res ~= prefix;
                    res ~= "+--(\n";
                    res ~= prefix;
                    res ~= "+--";
                    res ~= printNode(node.right, prefix ~ "|  ");
                    res ~= prefix;
                    res ~= "\\--)\n";
                    return res;
                }
                break;
            case SINGLE:
                {
                    res ~= to!string(node.prod);
                    res ~= "\n";
                    res ~= prefix;
                    res ~= "\\--";
                    res ~= printNode(node.right, prefix ~ "   ");
                    return res;
                }
                break;
            case TERMINAL:
                {
                    res ~= node.value.toString();
                    res ~= "\n";
                    return res;
                }
                break;
            default:
                return "error while printing";
        }
    }

}
