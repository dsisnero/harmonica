# harmonica

A Crystal port of [charmbracelet/harmonica](https://github.com/charmbracelet/harmonica), a simple, efficient spring animation library for smooth, natural motion.

This library provides damped spring animations for smooth, natural motion in Crystal applications. It's framework-agnostic and works well in 2D, 3D, and terminal contexts.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     harmonica:
       github: dsisnero/harmonica
   ```

2. Run `shards install`

## Usage

```crystal
require "harmonica"
```

TODO: Write usage instructions here

## Development

This is a direct port from the Go implementation. The original source code is available in the `harmonica_go/` submodule. To contribute:

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Run the quality gates before committing:

```bash
make format     # Check Crystal formatting
make lint       # Run linter (ameba)
make test       # Run tests
make markdown   # Format markdown files
```

## Porting Status

This library is a work-in-progress port of the Go harmonica library. The goal is to maintain API compatibility while following Crystal idioms.

## Original Project

This is a port of [charmbracelet/harmonica](https://github.com/charmbracelet/harmonica), a Go library created by [Charm](https://charm.sh/). The original project is a fairly straightforward port of Ryan Juckett's excellent damped simple harmonic oscillator originally written in C++ in 2008 and published in 2012.

## Contributing

1. Fork it (<https://github.com/dsisnero/harmonica/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [your-name-here](https://github.com/dsisnero) - creator and maintainer
