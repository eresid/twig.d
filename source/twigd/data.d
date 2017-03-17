module twigd.data;

import std.variant : Variant;

struct Data {

	private Variant[string] data;

    @property
    Variant opDispatch(string name)() const {
        return name in data ? data[name] : Variant.init;
    }

    @property
    void opDispatch(string name, T)(T val) {
        data[name] = val;
    }
}

version(unittest) {
    import std.stdio : writeln;
}

unittest {
    Data data = Data();
    data.name = "Eugene";
    data.age = 27;

    assert(data.name.hasValue);
    assert(data.age.hasValue);
    assert(!data.day.hasValue);

    assert(data.name == "Eugene");
    assert(data.age == 27);
}

