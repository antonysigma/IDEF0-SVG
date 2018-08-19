## What's IDEF0-SVG
Produce [IDEF0](https://en.wikipedia.org/wiki/IDEF0) process diagrams from a simple DSL.

The DSL is a list of statements of the form `Subject predicate Object` where `Subject` and `Object` are both space-separated camel-cased nouns, and `predicate` is one of:

* `receives` indicating an Input
* `respects` indicating a Control
* `produces` indicating an Output
* `requires` indicating a Mechanism
* `is composed of` indicating a nested Process

For example, a DSL representation of IDEF0 (aka ICOM) might look like:

```
Process receives Input
Process respects Control
Process produces Output
Process requires Mechanism
```

There are some more samples in ... wait for it ... `samples`.

The code itself is a few shell scripts in `bin` wrapped around some Ruby code in `lib` providing DSL parsing, SVG generation, and an ad-hoc informally-specified bug-ridden slow implementation of half a constraint solver.

## Some things to do

* All the `#TODO`s in the code
* Some tests wouldn't go astray
* Revisit the [building blocks](https://en.wikipedia.org/wiki/IDEF0#IDEF0_Building_blocks) and see what else we need to implement
* Sharing external concepts (they appear twice currently)
* Resizing of boxes based on text length (abstraction text vs label)

## License

This software is released under the [MIT License](https://opensource.org/licenses/MIT).