# Crystal Port Plan for Harmonica

## Overview

Port the entire `harmonica_go` library (spring animations and projectile physics) to Crystal while maintaining functional equivalence and following Crystal idioms.

## Source Analysis

**Go Library Components:**

1. **Spring** (`spring.go`) - Damped harmonic oscillator
   - `FPS()` helper function
   - `Spring` struct with coefficients
   - `NewSpring()` constructor with three damping cases
   - `Update()` method returns new position/velocity

2. **Projectile** (`projectile.go`) - Physics-based projectile motion
   - `Point` and `Vector` structs
   - `Projectile` struct with position, velocity, acceleration
   - `Gravity` and `TerminalGravity` constants
   - `NewProjectile()` constructor
   - `Update()`, `Position()`, `Velocity()`, `Acceleration()` methods

3. **Tests** (`projectile_test.go`) - Example-based tests
   - No spring tests in Go repo (only projectile tests)

4. **Examples** (`examples/`) - Particle and spring demos
   - Particle: Terminal projectile animation
   - Spring: TUI and OpenGL demonstrations

## Architecture Decisions

- **Module structure**: `Harmonica` top-level module
- **Naming**: Follow Crystal conventions (snake_case methods, CamelCase classes)
  - `Harmonica::Spring.new` instead of `NewSpring`
  - `spring.update` instead of `spring.Update`
- **File organization**: Split by component
  - `src/harmonica/spring.cr`
  - `src/harmonica/projectile.cr`
  - `src/harmonica.cr` (main module file)
- **Type design**:
  - `Spring` as immutable struct (value type) - coefficients computed once
  - `Projectile` as mutable class (matches Go's pointer semantics)
  - `Point` and `Vector` as structs
- **Math precision**: Use `Float64::EPSILON` for machine epsilon
- **API compatibility**: Maintain same behavior, adapt naming to Crystal idioms

## Implementation Tasks

### Phase 1: Project Structure

1. Create directory structure:
   - `src/harmonica/`
   - `spec/harmonica/`
2. Update `src/harmonica.cr` as main module file with re-exports
3. Update `shard.yml` with proper metadata and version

### Phase 2: Spring Implementation (`src/harmonica/spring.cr`)

1. **Core types**:
   - Define `Harmonica::Spring` struct with `pos_pos_coef`, `pos_vel_coef`, `vel_pos_coef`, `vel_vel_coef`
2. **Helper functions**:
   - Implement `Harmonica.fps(n)` returning `Float64` (equivalent to Go's `FPS()`)
   - Define `EPSILON = Float64::EPSILON` or compute via `Math.next_after`
3. **Constructor**:
   - `Spring.new(delta_time : Float64, angular_frequency : Float64, damping_ratio : Float64)`
   - Port the three damping cases exactly from Go:
     - Over-damped (`damping_ratio > 1.0 + epsilon`)
     - Under-damped (`damping_ratio < 1.0 - epsilon`)
     - Critically-damped (default case)
   - Include bounds checking: `angular_frequency.max(0.0)`, `damping_ratio.max(0.0)`
   - Handle zero angular frequency case (returns identity coefficients)
4. **Update method**:
   - `Spring#update(pos : Float64, vel : Float64, equilibrium_pos : Float64) -> {Float64, Float64}`
   - Same algorithm: compute in equilibrium relative space, apply coefficients

### Phase 3: Projectile Implementation (`src/harmonica/projectile.cr`)

1. **Core types**:
   - `Point` struct with `x, y, z : Float64` fields
   - `Vector` struct with `x, y, z : Float64` fields
   - `Projectile` class with `@pos : Point`, `@vel : Vector`, `@acc : Vector`, `@delta_time : Float64`
2. **Constants**:
   - `Gravity = Vector.new(0, -9.81, 0)`
   - `TerminalGravity = Vector.new(0, 9.81, 0)`
3. **Constructor**:
   - `Projectile.new(delta_time : Float64, initial_position : Point, initial_velocity : Vector, initial_acceleration : Vector)`
4. **Methods**:
   - `#update` -> `Point` (mutates internal state)
   - `#position`, `#velocity`, `#acceleration` getters

### Phase 4: Test Porting

1. **Spring tests** (create new - no Go tests exist):
   - `spec/harmonica/spring_spec.cr`
   - Test all three damping cases with known values
   - Verify convergence behavior
   - Test edge cases (zero frequency, negative inputs clamped)
2. **Projectile tests** (port from Go):
   - `spec/harmonica/projectile_spec.cr`
   - Port `TestNew`, `TestUpdate`, `TestUpdateGravity`
   - Maintain same test values and thresholds (`equalityThreshold = 1e-2`)
   - Convert Go test tables to Crystal `it` blocks
   - Use `approx` matcher for floating-point comparisons

### Phase 5: Documentation & Examples

1. Add Crystal docs to all public methods
2. Update README with Crystal usage examples
3. Add module documentation to `src/harmonica.cr`
4. Consider adding simple example scripts (optional)

### Phase 6: Quality Gates

1. Run `crystal tool format --check`
2. Run `ameba --fix` then `ameba` to verify
3. Run `crystal spec` - all tests must pass
4. Run `rumdl fmt .` for markdown formatting

## Key Challenges & Considerations

1. **Floating-point precision**: Crystal may produce slightly different results than Go
   - Use same epsilon comparison strategy
   - Accept small differences within threshold (1e-2 for tests)
   - Consider using `Math.next_after` for epsilon computation
2. **Mutability**: Projectile must be mutable to match Go behavior
   - Use class instead of struct for `Projectile`
   - `#update` mutates internal state
3. **Math functions**: Ensure `Math.exp`, `Math.sqrt`, `Math.cos`, `Math.sin` match Go's `math` package
4. **Error handling**: Go library has no error returns; Crystal should use assertions or raise on invalid inputs?
   - Clamp negative values to 0.0 (as Go does with `math.Max`)
5. **Performance**: Spring coefficients are precomputed; maintain same optimization
   - Struct is immutable and reusable for multiple springs

## Success Criteria

1. All Go functionality ported to Crystal
2. Tests pass with same assertions (within floating-point tolerance)
3. Code follows Crystal idioms and passes quality gates
4. API is intuitive for Crystal developers while maintaining compatibility with Go library's concepts
5. Ready for use in Crystal applications requiring spring animations or projectile physics

## Next Steps

1. Begin with Phase 1 (Project Structure)
2. Implement Spring (Phase 2) - core algorithm
3. Implement Projectile (Phase 3) - simpler component
4. Write tests (Phase 4) to verify correctness
5. Add documentation and run quality gates (Phases 5-6)
