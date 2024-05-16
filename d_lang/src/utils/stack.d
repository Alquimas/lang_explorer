import std.array;
import std.stdio: writeln;

/**
 * A node from the stack. It stores a value from the type T
 * And a pointer to another StackNode.
 */
private struct StackNode(T) {
    T value;
    StackNode!T* next;

    this(T value) {
        this.value = value;
        next = null;
    }
}

/**
 * A simple implementation of a LIFO - Last In First Out - storage.
 */
class Stack(T) {
    private StackNode!T* top;

public:
    this() {
        top = null;
    }

    /**
     * Pushes a value in the top of the stack.
     */
    void push(T value) {
        auto tmp = new StackNode!T(value);
        tmp.next = top;
        top = tmp;
    }

    /**
     * Removes and returns the value in the top of the stack.
     * Throws:
     *  If the stack is empty, using this method will
     *  throw a exception.
     */
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

    /**
     * Returns the value in the top of the stack.
     * Throws:
     *  If the stack is empty, using this method will
     *  throw a exception.
     */
    T peek() {
        if(this.empty()) {
            throw new Exception("Empty Stack!");
        }
        return top.value;
    }

    /**
     * Returns true when the stack is empty and false otherwise.
     */
    bool empty() {
        return top is null;
    }
}
