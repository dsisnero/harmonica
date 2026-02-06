# This file defines simple physics projectile motion.
#
# Example usage:
#
# ```
# # Run once to initialize.
# projectile = Harmonica::Projectile.new(
#   Harmonica.fps(60),
#   Harmonica::Point.new(6.0, 100.0, 0.0),
#   Harmonica::Vector.new(2.0, 0.0, 0.0),
#   Harmonica::Vector.new(2.0, -9.81, 0.0)
# )
#
# # Update on every frame.
# pos = projectile.update
# ```
#
# For background on projectile motion see:
# https://en.wikipedia.org/wiki/Projectile_motion
module Harmonica
  # Represents a point containing the X, Y, Z coordinates of the point on a plane.
  struct Point
    getter x : Float64
    getter y : Float64
    getter z : Float64

    def initialize(@x : Float64, @y : Float64, @z : Float64 = 0.0)
    end
  end

  # Represents a vector carrying a magnitude and a direction. We represent the
  # vector as a point from the origin (0, 0) where the magnitude is the
  # Euclidean distance from the origin and the direction is the direction to
  # the point from the origin.
  struct Vector
    getter x : Float64
    getter y : Float64
    getter z : Float64

    def initialize(@x : Float64, @y : Float64, @z : Float64 = 0.0)
    end
  end

  # Gravity is a utility vector that represents gravity in 2D and 3D contexts,
  # assuming that your coordinate plane looks like in 2D or 3D:
  #
  #   y             y ±z
  #   │             │ /
  #   │             │/
  #   └───── ±x     └───── ±x
  #
  # (i.e. origin is located in the bottom-left corner)
  Gravity = Vector.new(0, -9.81, 0)

  # TerminalGravity is a utility vector that represents gravity where the
  # coordinate plane's origin is on the top-right corner.
  TerminalGravity = Vector.new(0, 9.81, 0)

  # Projectile is the representation of a projectile that has a position on
  # a plane, an acceleration, and velocity.
  class Projectile
    getter position : Point
    getter velocity : Vector
    getter acceleration : Vector
    getter delta_time : Float64

    # Creates a new projectile. It accepts a frame rate and initial
    # values for position, velocity, and acceleration.
    def initialize(
      @delta_time : Float64,
      initial_position : Point,
      initial_velocity : Vector,
      initial_acceleration : Vector,
    )
      @position = initial_position
      @velocity = initial_velocity
      @acceleration = initial_acceleration
    end

    # Updates the position and velocity values for the given projectile.
    # Call this after calling `.new` to update values.
    def update : Point
      @position = Point.new(
        @position.x + (@velocity.x * @delta_time),
        @position.y + (@velocity.y * @delta_time),
        @position.z + (@velocity.z * @delta_time)
      )

      @velocity = Vector.new(
        @velocity.x + (@acceleration.x * @delta_time),
        @velocity.y + (@acceleration.y * @delta_time),
        @velocity.z + (@acceleration.z * @delta_time)
      )

      @position
    end
  end
end
