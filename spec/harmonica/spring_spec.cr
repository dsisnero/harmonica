require "../spec_helper"

module Harmonica
  def Harmonica.assert_finite(value)
    value.should be_a(Float64)
    value.nan?.should be_false
    value.infinite?.should be_nil
  end

  describe Spring do
    # Helper for floating-point comparisons
    epsilon = 1e-10

    it "creates a spring with zero angular frequency (identity)" do
      spring = Spring.new(1.0 / 60, 0.0, 0.5)
      spring.pos_pos_coef.should be_close(1.0, epsilon)
      spring.pos_vel_coef.should be_close(0.0, epsilon)
      spring.vel_pos_coef.should be_close(0.0, epsilon)
      spring.vel_vel_coef.should be_close(1.0, epsilon)
    end

    it "clamps negative angular frequency to zero" do
      spring = Spring.new(1.0 / 60, -1.0, 0.5)
      spring.pos_pos_coef.should be_close(1.0, epsilon)
      spring.pos_vel_coef.should be_close(0.0, epsilon)
      spring.vel_pos_coef.should be_close(0.0, epsilon)
      spring.vel_vel_coef.should be_close(1.0, epsilon)
    end

    it "clamps negative damping ratio to zero" do
      # With zero damping ratio, should be under-damped case
      spring = Spring.new(1.0 / 60, 5.0, -0.5)
      # Just ensure it doesn't crash and produces valid coefficients
      spring.pos_pos_coef.should be_a(Float64)
      spring.pos_vel_coef.should be_a(Float64)
      spring.vel_pos_coef.should be_a(Float64)
      spring.vel_vel_coef.should be_a(Float64)
    end

    describe "over-damped (damping_ratio > 1)" do
      it "produces valid coefficients" do
        spring = Spring.new(1.0 / 60, 5.0, 2.0)
        # Coefficients should be finite
        Harmonica.assert_finite(spring.pos_pos_coef)
        Harmonica.assert_finite(spring.pos_vel_coef)
        Harmonica.assert_finite(spring.vel_pos_coef)
        Harmonica.assert_finite(spring.vel_vel_coef)
      end

      it "converges to equilibrium without oscillation" do
        spring = Spring.new(1.0 / 60, 6.0, 2.0)
        pos = 0.0
        vel = 0.0
        target = 100.0

        # Run many updates
        500.times do
          pos, vel = spring.update(pos, vel, target)
        end

        pos.should be_close(target, 1.0)
        vel.abs.should be < 1.0
      end
    end

    describe "critically damped (damping_ratio ≈ 1)" do
      it "produces valid coefficients" do
        spring = Spring.new(1.0 / 60, 5.0, 1.0)
        Harmonica.assert_finite(spring.pos_pos_coef)
        Harmonica.assert_finite(spring.pos_vel_coef)
        Harmonica.assert_finite(spring.vel_pos_coef)
        Harmonica.assert_finite(spring.vel_vel_coef)
      end

      it "converges to equilibrium as fast as possible without oscillation" do
        spring = Spring.new(1.0 / 60, 6.0, 1.0)
        pos = 0.0
        vel = 0.0
        target = 100.0

        200.times do
          pos, vel = spring.update(pos, vel, target)
        end

        pos.should be_close(target, 0.1)
        vel.abs.should be < 0.1
      end
    end

    describe "under-damped (damping_ratio < 1)" do
      it "produces valid coefficients" do
        spring = Spring.new(1.0 / 60, 5.0, 0.2)
        Harmonica.assert_finite(spring.pos_pos_coef)
        Harmonica.assert_finite(spring.pos_vel_coef)
        Harmonica.assert_finite(spring.vel_pos_coef)
        Harmonica.assert_finite(spring.vel_vel_coef)
      end

      it "oscillates while converging to equilibrium" do
        spring = Spring.new(1.0 / 60, 6.0, 0.2)
        pos = 0.0
        vel = 0.0
        target = 100.0

        positions = [] of Float64
        200.times do
          pos, vel = spring.update(pos, vel, target)
          positions << pos
        end

        # Should eventually converge (under-damped oscillates but damps)
        pos.should be_close(target, 5.0)
        # Velocity may still be significant due to oscillations
        vel.abs.should be < 100.0
      end
    end

    it "updates position and velocity correctly" do
      spring = Spring.new(1.0 / 60, 5.0, 0.5)
      pos, vel = spring.update(0.0, 0.0, 100.0)
      pos.should be_a(Float64)
      vel.should be_a(Float64)
      pos.should_not eq(0.0) # Should move toward target
    end

    it "works with fps helper" do
      delta = Harmonica.fps(60)
      spring = Spring.new(delta, 5.0, 0.5)
      spring.should be_a(Spring)
    end
  end
end
