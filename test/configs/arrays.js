module.exports = {
  foo: {
    list: ["one", "two", "three"],
    nested: {
      deeper: ["a", "b", "c"]
    },
    merged: ["i", "am", "merged"]
  },
  bar: {
    _extends: "foo",
    list: ["four", "five"],
    nested: {
      deeper: ["d", "e"]
    },
    merged: {
      _merge: ["with", "bar"]
    }
  },
  derp: {
    _extends: "bar",
    list: ["six"],
    nested: {
      deeper: ["f"]
    },
    merged: {
      _merge: ["and", "derp"]
    }
  }
};