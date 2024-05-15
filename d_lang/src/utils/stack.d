import std.array;
import std.stdio: writeln;

struct StackNode(T) {
    T value;
    StackNode!T* next;

    this(T value) {
        this.value = value;
        next = null;
    }
}

class Stack(T) {
    private StackNode!T* top;

public:
    this() {
        top = null;
    }

    void push(T value) {
        auto tmp = new StackNode!T(value);
        tmp.next = top;
        top = tmp;
    }

    T pop() {
        if(this.empty()) {
            throw new Exception("Empty Stack!");
        }
        T value = top.value;
        auto tempNode = top;
        top = top.next;
        object.destroy(tempNode);
        return value;
    }

    T peek() {
        if(this.empty()) {
            throw new Exception("Empty Stack!");
        }
        return top.value;
    }

    bool empty() {
        return top is null;
    }
}
