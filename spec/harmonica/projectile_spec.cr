require "../spec_helper"

module Harmonica
  describe Projectile do
    # Floating point comparison threshold from Go tests
    equality_threshold = 1e-2

    describe ".new" do
      it "initializes with given position, velocity, and acceleration" do
        x = 8.0
        y = 20.0
        z = 0.0

        projectile = Projectile.new(
          fps(60),
          Point.new(x, y, z),
          Vector.new(1.0, 1.0, 0.0),
          Vector.new(0.0, 9.81, 0.0)
        )

        pos = projectile.update

        # After one frame (1/60 second) with velocity (1,1,0)
        expected_x = x + 1.0 * (1.0 / 60)
        expected_y = y + 1.0 * (1.0 / 60)
        pos.x.should be_close(expected_x, equality_threshold)
        pos.y.should be_close(expected_y, equality_threshold)
      end
    end

    describe "#update" do
      it "updates position correctly with zero acceleration" do
        projectile = Projectile.new(
          fps(60),
          Point.new(0.0, 0.0, 0.0),
          Vector.new(5.0, 5.0, 0.0),
          Vector.new(0.0, 0.0, 0.0)
        )

        # Coordinates expected after each second (60 frames)
        expected_coordinates = [
          Point.new(5.0, 5.0, 0.0),
          Point.new(10.0, 10.0, 0.0),
          Point.new(15.0, 15.0, 0.0),
          Point.new(20.0, 20.0, 0.0),
          Point.new(25.0, 25.0, 0.0),
          Point.new(30.0, 30.0, 0.0),
          Point.new(35.0, 35.0, 0.0),
        ]

        expected_coordinates.each do |expected|
          # Update 60 times (one second worth of frames at 60 FPS)
          60.times do
            projectile.update
          end

          vel = projectile.velocity
          vel.x.should be_close(5.0, equality_threshold)
          vel.y.should be_close(5.0, equality_threshold)
          vel.z.should be_close(0.0, equality_threshold)

          pos = projectile.position
          pos.x.should be_close(expected.x, equality_threshold)
          pos.y.should be_close(expected.y, equality_threshold)
        end
      end

      it "updates position correctly with gravity (TerminalGravity)" do
        projectile = Projectile.new(
          fps(60),
          Point.new(0.0, 0.0, 0.0),
          Vector.new(5.0, 5.0, 0.0),
          TerminalGravity
        )

        # Coordinates expected after each second (60 frames) with gravity
        expected_coordinates = [
          Point.new(5.0, 9.82, 0.0),
          Point.new(10.0, 29.46, 0.0),
          Point.new(15.0, 58.90, 0.0),
          Point.new(20.0, 98.15, 0.0),
          Point.new(25.0, 147.22, 0.0),
          Point.new(30.0, 206.09, 0.0),
          Point.new(35.0, 274.77, 0.0),
        ]

        expected_coordinates.each do |expected|
          # Update 60 times (one second worth of frames at 60 FPS)
          60.times do
            projectile.update
          end

          acc = projectile.acceleration
          acc.y.should be_close(TerminalGravity.y, equality_threshold)

          pos = projectile.position
          pos.x.should be_close(expected.x, equality_threshold)
          pos.y.should be_close(expected.y, equality_threshold)
        end
      end
    end

    describe "constants" do
      it "has Gravity constant" do
        Gravity.should be_a(Vector)
        Gravity.x.should eq(0.0)
        Gravity.y.should eq(-9.81)
        Gravity.z.should eq(0.0)
      end

      it "has TerminalGravity constant" do
        TerminalGravity.should be_a(Vector)
        TerminalGravity.x.should eq(0.0)
        TerminalGravity.y.should eq(9.81)
        TerminalGravity.z.should eq(0.0)
      end
    end

    describe Point do
      it "creates a point with x, y, z coordinates" do
        point = Point.new(1.0, 2.0, 3.0)
        point.x.should eq(1.0)
        point.y.should eq(2.0)
        point.z.should eq(3.0)
      end

      it "defaults z to 0.0" do
        point = Point.new(1.0, 2.0)
        point.z.should eq(0.0)
      end
    end

    describe Vector do
      it "creates a vector with x, y, z components" do
        vector = Vector.new(1.0, 2.0, 3.0)
        vector.x.should eq(1.0)
        vector.y.should eq(2.0)
        vector.z.should eq(3.0)
      end

      it "defaults z to 0.0" do
        vector = Vector.new(1.0, 2.0)
        vector.z.should eq(0.0)
      end
    end
  end
end
