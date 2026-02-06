# This file defines a simplified damped harmonic oscillator, colloquially
# known as a spring. This is ported from Ryan Juckett’s simple damped harmonic
# motion, originally written in C++.
#
# Example usage:
#
# ```
# # Run once to initialize.
# spring = Harmonica::Spring.new(Harmonica.fps(60), 6.0, 0.2)
#
# # Update on every frame.
# pos = 0.0
# velocity = 0.0
# target_pos = 100.0
# pos, velocity = spring.update(pos, velocity, target_pos)
# ```
#
# For background on the algorithm see:
# https://www.ryanjuckett.com/damped-springs/
#
# Copyright (c) 2008-2012 Ryan Juckett
# Ported to Go by Charmbracelet, Inc. in 2021.
# Ported to Crystal by Dominic Sisneros in 2025.
module Harmonica
  # Spring contains a cached set of motion parameters that can be used to
  # efficiently update multiple springs using the same time step, angular
  # frequency and damping ratio.
  #
  # To use a Spring call `.new` with the time delta (animation frame length),
  # frequency, and damping parameters, cache the result, then call
  # `#update` to update position and velocity values for each spring that needs
  # updating.
  #
  # Example:
  #
  # ```
  # # First precompute spring coefficients based on your settings:
  # delta_time = Harmonica.fps(60)
  # spring = Spring.new(delta_time, 5.0, 0.2)
  #
  # # Then, in your update loop:
  # x, x_vel = spring.update(x, x_vel, 10) # update the X position
  # y, y_vel = spring.update(y, y_vel, 20) # update the Y position
  # ```
  struct Spring
    # Position coefficient for position
    getter pos_pos_coef : Float64
    # Velocity coefficient for position
    getter pos_vel_coef : Float64
    # Position coefficient for velocity
    getter vel_pos_coef : Float64
    # Velocity coefficient for velocity
    getter vel_vel_coef : Float64

    # Epsilon value for floating-point comparisons
    private EPSILON = Float64::EPSILON

    # Initializes a new Spring, computing the parameters needed to
    # simulate a damped spring over a given period of time.
    #
    # The *delta_time* is the time step to advance; essentially the framerate.
    #
    # The *angular_frequency* is the angular frequency of motion, which affects
    # the speed.
    #
    # The *damping_ratio* is the damping ratio of motion, which determines the
    # oscillation, or lack thereof. There are three categories of damping ratios:
    #
    # - Damping ratio > 1: over-damped.
    # - Damping ratio = 1: critically-damped.
    # - Damping ratio < 1: under-damped.
    #
    # An over-damped spring will never oscillate, but reaches equilibrium at
    # a slower rate than a critically damped spring.
    #
    # A critically damped spring will reach equilibrium as fast as possible
    # without oscillating.
    #
    # An under-damped spring will reach equilibrium the fastest, but also
    # overshoots it and continues to oscillate as its amplitude decays over time.
    def initialize(delta_time : Float64, angular_frequency : Float64, damping_ratio : Float64)
      # Keep values in a legal range.
      angular_frequency = Math.max(0.0, angular_frequency)
      damping_ratio = Math.max(0.0, damping_ratio)

      # If there is no angular frequency, the spring will not move and we can
      # return identity.
      if angular_frequency < EPSILON
        @pos_pos_coef = 1.0
        @pos_vel_coef = 0.0
        @vel_pos_coef = 0.0
        @vel_vel_coef = 1.0
        return
      end

      if damping_ratio > 1.0 + EPSILON
        # Over-damped.
        za = -angular_frequency * damping_ratio
        zb = angular_frequency * Math.sqrt(damping_ratio * damping_ratio - 1.0)
        z1 = za - zb
        z2 = za + zb

        e1 = Math.exp(z1 * delta_time)
        e2 = Math.exp(z2 * delta_time)

        inv_two_zb = 1.0 / (2.0 * zb) # = 1 / (z2 - z1)

        e1_over_two_zb = e1 * inv_two_zb
        e2_over_two_zb = e2 * inv_two_zb

        z1e1_over_two_zb = z1 * e1_over_two_zb
        z2e2_over_two_zb = z2 * e2_over_two_zb

        @pos_pos_coef = e1_over_two_zb * z2 - z2e2_over_two_zb + e2
        @pos_vel_coef = -e1_over_two_zb + e2_over_two_zb

        @vel_pos_coef = (z1e1_over_two_zb - z2e2_over_two_zb + e2) * z2
        @vel_vel_coef = -z1e1_over_two_zb + z2e2_over_two_zb
      elsif damping_ratio < 1.0 - EPSILON
        # Under-damped.
        omega_zeta = angular_frequency * damping_ratio
        alpha = angular_frequency * Math.sqrt(1.0 - damping_ratio * damping_ratio)

        exp_term = Math.exp(-omega_zeta * delta_time)
        cos_term = Math.cos(alpha * delta_time)
        sin_term = Math.sin(alpha * delta_time)

        inv_alpha = 1.0 / alpha

        exp_sin = exp_term * sin_term
        exp_cos = exp_term * cos_term
        exp_omega_zeta_sin_over_alpha = exp_term * omega_zeta * sin_term * inv_alpha

        @pos_pos_coef = exp_cos + exp_omega_zeta_sin_over_alpha
        @pos_vel_coef = exp_sin * inv_alpha

        @vel_pos_coef = -exp_sin * alpha - omega_zeta * exp_omega_zeta_sin_over_alpha
        @vel_vel_coef = exp_cos - exp_omega_zeta_sin_over_alpha
      else
        # Critically damped.
        exp_term = Math.exp(-angular_frequency * delta_time)
        time_exp = delta_time * exp_term
        time_exp_freq = time_exp * angular_frequency

        @pos_pos_coef = time_exp_freq + exp_term
        @pos_vel_coef = time_exp

        @vel_pos_coef = -angular_frequency * time_exp_freq
        @vel_vel_coef = -time_exp_freq + exp_term
      end
    end

    # Updates position and velocity values against a given target value.
    # Call this after calling `.new` to update values.
    def update(pos : Float64, vel : Float64, equilibrium_pos : Float64) : Tuple(Float64, Float64)
      old_pos = pos - equilibrium_pos # update in equilibrium relative space
      old_vel = vel

      new_pos = old_pos * @pos_pos_coef + old_vel * @pos_vel_coef + equilibrium_pos
      new_vel = old_pos * @vel_pos_coef + old_vel * @vel_vel_coef

      {new_pos, new_vel}
    end
  end
end
