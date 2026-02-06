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

### Spring Animation

Harmonica provides physics-based spring animations for smooth, realistic motion.

```crystal
# Initialize a spring with framerate, angular frequency, and damping values.
spring = Harmonica::Spring.new(Harmonica.fps(60), 6.0, 0.5)

# A thing we want to animate.
sprite = {
  x: 0.0,
  x_velocity: 0.0,
  y: 0.0,
  y_velocity: 0.0
}

# Where we want to animate it.
target_x = 50.0
target_y = 100.0

# Animate!
loop do
  sprite[:x], sprite[:x_velocity] = spring.update(sprite[:x], sprite[:x_velocity], target_x)
  sprite[:y], sprite[:y_velocity] = spring.update(sprite[:y], sprite[:y_velocity], target_y)
  sleep 1.0 / 60
end
```

### Projectile Motion

Harmonica also provides simple projectile physics for particles and projectiles.

```crystal
# Initialize a projectile with position, velocity, and acceleration.
projectile = Harmonica::Projectile.new(
  Harmonica.fps(60),
  Harmonica::Point.new(6.0, 100.0, 0.0),
  Harmonica::Vector.new(2.0, 0.0, 0.0),
  Harmonica::Vector.new(2.0, -9.81, 0.0)
)

# Update on every frame.
loop do
  pos = projectile.update
  # Use position...
  sleep 1.0 / 60
end
```

### Gravity Constants

For convenience, Harmonica provides gravity vectors for common coordinate systems:

```crystal
# Standard gravity (origin at bottom-left)
Harmonica::Gravity           # => Vector(0, -9.81, 0)

# Terminal gravity (origin at top-left)
Harmonica::TerminalGravity   # => Vector(0, 9.81, 0)
```

## Settings

`Harmonica::Spring.new` takes three values:

* **Time Delta:** the time step to operate on. Game engines typically provide a way to determine the time delta, however if that's not available you can simply set the framerate with the included `Harmonica.fps` utility function. Make sure the framerate you set here matches your actual framerate.
* **Angular Velocity:** this translates roughly to the speed. Higher values are faster.
* **Damping Ratio:** the springiness of the animation, generally between `0` and `1`, though it can go higher. Lower values are springier. For details, see below.

## Damping Ratios

The damping ratio affects the motion in one of three different ways depending on how it's set.

### Under-Damping

A spring is under-damped when its damping ratio is less than `1`. An under-damped spring reaches equilibrium the fastest, but overshoots and will continue to oscillate as its amplitude decays over time.

### Critical Damping

A spring is critically-damped the damping ratio is exactly `1`. A critically damped spring will reach equilibrium as fast as possible without oscillating.

### Over-Damping

A spring is over-damped the damping ratio is greater than `1`. An over-damped spring will never oscillate, but reaches equilibrium at a slower rate than a critically damped spring.

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

✅ **Complete** - All functionality from the Go harmonica library has been ported to Crystal:

* Spring animations with all damping cases (over-damped, critically damped, under-damped)
* Projectile physics with Point/Vector types
* Gravity constants for common coordinate systems
* Full test coverage matching Go behavior

The port follows Crystal idioms while maintaining API compatibility with the original Go library.

## Original Project

This is a port of [charmbracelet/harmonica](https://github.com/charmbracelet/harmonica), a Go library created by [Charm](https://charm.sh/). The original project is a fairly straightforward port of Ryan Juckett's excellent damped simple harmonic oscillator originally written in C++ in 2008 and published in 2012.

## Acknowledgements

This library is a fairly straightforward port of [Ryan Juckett][juckett]'s excellent damped simple harmonic oscillator originally written in C++ in 2008 and published in 2012. [Ryan's writeup][writeup] on the subject is fantastic.

[juckett]: https://www.ryanjuckett.com/
[writeup]: https://www.ryanjuckett.com/damped-springs/

## Feedback

We'd love to hear your thoughts on this project. Feel free to drop us a note!

* [Twitter](https://twitter.com/charmcli)
* [The Fediverse](https://mastodon.social/@charmcli)
* [Discord](https://charm.sh/chat)

## License

[MIT](https://github.com/dsisnero/harmonica/raw/main/LICENSE)

***

Part of [Charm](https://charm.sh).

<a href="https://charm.sh/"><img alt="The Charm logo" src="https://stuff.charm.sh/charm-badge.jpg" width="400"></a>

Charm热爱开源 • Charm loves open source