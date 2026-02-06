# A Crystal port of the Charmbracelet/harmonica library.
#
# Harmonica provides physics-based animation tools for 2D and 3D applications,
# including spring animations for smooth, realistic motion and projectile
# simulation for particles and projectiles.
#
# ## Spring Animation
#
# Example spring usage:
#
# ```
# # Initialize a spring with framerate, angular frequency, and damping
# spring = Harmonica::Spring.new(Harmonica.fps(60), 6.0, 0.2)
#
# # Update on every frame
# pos = 0.0
# velocity = 0.0
# target_pos = 100.0
# pos, velocity = spring.update(pos, velocity, target_pos)
# ```
#
# ## Projectile Motion
#
# Example projectile usage:
#
# ```
# # Initialize a projectile
# projectile = Harmonica::Projectile.new(
#   Harmonica.fps(60),
#   Harmonica::Point.new(6.0, 100.0, 0.0),
#   Harmonica::Vector.new(2.0, 0.0, 0.0),
#   Harmonica::Vector.new(2.0, -9.81, 0.0)
# )
#
# # Update on every frame
# pos = projectile.update
# ```
module Harmonica
  VERSION = "0.1.0"

  # Returns a time delta for a given number of frames per second.
  #
  # This value can be used as the time delta when initializing a Spring.
  # Game engines often provide the time delta as well, which you should use
  # instead of this function, if possible.
  #
  # ```
  # spring = Spring.new(fps(60), 5.0, 0.2)
  # ```
  def self.fps(n : Int) : Float64
    (1.0 / n.to_f) # seconds per frame for 60 FPS = 1/60
  end
end

require "./harmonica/*"
