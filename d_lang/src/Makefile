SRCS := main.d lexer/lexer.d lexer/token.d errors/errors.d utils/utils.d utils/stack.d parser/nodes.d parser/parser.d
OBJS := $(SRCS:.d=.o)

main: $(SRCS)
	dmd $^ -of=main.out

.PHONY: all clean

all: main

clean:
	rm -f main.out $(OBJS)
