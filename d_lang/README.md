## Description

A LALR Parser written in D for the following grammar:

```
S -> E
E -> E + F
E -> E - F
E -> F
F -> F * G
F -> F / G
F -> G
G -> - G
G -> + G
G -> H
I -> ( E )
H -> I
H -> I ^ H
I -> NUMBER
```

It alsos prints the derivation tree using the same logic of the `tree` command for linux to build the tree: When the tree expands, the upmost nodes are equivalent to the leftmost nodes on the default representation.

I used the `dmd` compiler for `D lang`. You can find more about [here](https://dlang.org/download.html).

## Running

You can run `make` inside the `src/` folder to create the `main.out`. You can run it with a file as argument or interactively, but the option with the file is bugged.
