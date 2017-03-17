module twigd.utils.Set;

import std.array;

class Set(E) {
/+
    private E[] items;

    bool isEmpty() {
        return items.empty();
    }

    bool contains(Object o) {

    }

    void add(E e) {
        items ~= e;
    }

    bool remove(E e) {
        if (this.empty) {
            throw new Exception("Empty Stack.");
        }

        auto top = items.back;
        items.popBack();
        return top;
    }+/

    void clear() {

    }
}
/+
unittest {
    auto stack = new Stack!int();
    stack.push(10);
    stack.push(20);
    assert(stack.pop() == 20);
    assert(stack.pop() == 10);
    assert(stack.empty());
}+/