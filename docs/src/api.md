# API Reference

This document provides detailed information about the functions and types available in SymbolicIntegration.jl.

## Main Functions

### `integrate`

The primary function for symbolic integration.

```julia
integrate(f, x; useQQBar=false, catchNotImplementedError=true, catchAlgorithmFailedError=true)
```

**Parameters:**

- `f`: The integrand expression (SymbolicUtils expression)
- `x`: The integration variable (SymbolicUtils.Sym) 
- `useQQBar::Bool=false`: Whether to use algebraic number field calculations
- `catchNotImplementedError::Bool=true`: Whether to catch and handle NotImplementedError exceptions
- `catchAlgorithmFailedError::Bool=true`: Whether to catch and handle AlgorithmFailedError exceptions

**Returns:**

- A SymbolicUtils expression representing the antiderivative
- If integration fails and error catching is enabled, returns a symbolic integral `∫(f, x)`

**Examples:**

```julia
using SymbolicIntegration, SymbolicUtils
@syms x

# Basic integration
result = integrate(x^2, x)  # Returns x^3/3

# With algebraic numbers
result = integrate(1/(x^2 + x + 1), x, useQQBar=true)

# With error handling disabled (will throw exceptions)
result = integrate(exp(x^2), x, catchNotImplementedError=false)
```

## Specialized Integration Functions

### `TowerOfDifferentialFields`

Constructs a tower of differential fields for transcendental extensions.

```julia
TowerOfDifferentialFields(Hs::Vector{F}) -> K, gs, D
TowerOfDifferentialFields(terms::Vector{Term}) -> K, gs, D
```

**Parameters:**

- `Hs`: Vector of rational functions representing field extensions
- `terms`: Vector of Term objects representing transcendental functions

**Returns:**

- `K`: The constructed differential field
- `gs`: Vector of generators 
- `D`: The derivation on the field

This is primarily an internal function used by the integration algorithm.

### `transform_mpoly_to_tower`

Transform multivariate polynomial elements to tower field elements.

```julia
transform_mpoly_to_tower(f, gs) -> f1
```

**Parameters:**

- `f`: Element in multivariate polynomial ring
- `gs`: Vector of generators from TowerOfDifferentialFields

**Returns:**

- Corresponding element in the tower field

## Types

### Exception Types

#### `NotImplementedError`

```julia
struct NotImplementedError <: Exception
    msg::String
end
```

Thrown when the integrand contains unsupported functions or structures.

**Common Causes:**
- Algebraic functions (sqrt, non-integer powers)
- Unsupported transcendental functions
- Complex nested structures

#### `AlgorithmFailedError`

```julia
struct AlgorithmFailedError <: Exception
    msg::String
end
```

Thrown when the integration algorithm encounters internal failures.

**Common Causes:**
- Numerical instability in algebraic computations
- Timeout in complex differential equation solving
- Memory exhaustion for large expressions

#### `AlgebraicNumbersInvolved`

```julia
struct AlgebraicNumbersInvolved <: Exception end
```

Internal exception used to trigger automatic switching to algebraic number computations.

### Term Types

#### `Term`

```julia
abstract type Term end
```

Base type for representing transcendental function terms in the differential field tower.

#### `IdTerm`

```julia
struct IdTerm <: Term
    arg::RingElement
end
```

Represents identity terms (typically the base variable).

#### `FunctionTerm`

```julia
struct FunctionTerm <: Term
    op        # Function operation (exp, log, tan, atan)
    coeff::RingElement
    arg::RingElement
end
```

Represents transcendental function terms with coefficients and arguments.

## Internal Functions

### Expression Analysis

#### `analyze_expr`

```julia
analyze_expr(f, x::SymbolicUtils.Sym) -> p, funs, vars, args
analyze_expr(f, funs, vars, args, tanArgs, expArgs) -> processed_expression
```

Analyzes symbolic expressions and prepares them for integration by:
- Identifying transcendental functions
- Building function hierarchies
- Converting trigonometric and hyperbolic functions to standard forms

### Field Operations

#### `height`

```julia
height(K::Field) -> Int
```

Computes the height of a differential field (number of transcendental extensions).

#### `subst_tower`

```julia
subst_tower(f, vars) -> symbolic_expression
subst_tower(f, vars, h::Int) -> symbolic_expression
```

Substitutes tower field elements back into symbolic expressions.

### Utility Functions

#### `convolution`

```julia
convolution(a::Vector, b::Vector, s::Int; output_size::Int=0) -> Vector
```

Computes convolution of coefficient vectors, used in trigonometric integration.

#### `tan2sincos`

```julia
tan2sincos(f, arg, vars, h::Int=0) -> symbolic_expression
```

Converts rational functions in tangent to expressions in sine and cosine.

## Constants and Symbols

### Special Symbols

```julia
@syms ∫(f, x)  # Symbolic integral notation
@syms Root(x::qqbar)  # Algebraic number root notation
```

## Configuration

### Backend Selection

The package automatically selects computational backends:

- **Base Ring**: `Nemo.QQ` (rational numbers) or `Nemo.QQBar` (algebraic numbers)
- **Polynomial Rings**: `AbstractAlgebra.jl` generic polynomial implementations
- **Field Extensions**: Automated based on transcendental function requirements

### Logging and Debugging

Enable detailed logging to understand integration process:

```julia
using Logging

# Set debug level logging
logger = ConsoleLogger(stdout, Logging.Debug)
with_logger(logger) do
    result = integrate(your_expression, x)
end
```

## Performance Considerations

### Memory Usage

- Large polynomial degrees can consume significant memory
- Complex transcendental towers require more computational resources
- Algebraic number calculations (`useQQBar=true`) are more expensive

### Computational Complexity

| Integration Type | Typical Complexity | Notes |
|------------------|-------------------|-------|
| Rational Functions | O(d³) where d is degree | Most efficient |
| Single Exponential | O(d⁴) | Moderate complexity |
| Single Logarithm | O(d³) | Similar to rational |
| Trigonometric | O(d⁴) | Depends on argument complexity |
| Mixed Transcendental | Exponential in tower height | Most expensive |

### Optimization Tips

1. **Simplify First**: Use `SymbolicUtils.simplify()` before integration
2. **Break Down Complex Expressions**: Integrate terms separately when possible
3. **Avoid Deep Nesting**: Minimize nested transcendental functions
4. **Use Rational Coefficients**: Prefer exact rational arithmetic

## Error Handling Best Practices

### Robust Integration Code

```julia
function safe_integrate(f, x; verbose=false)
    try
        # First attempt with standard settings
        result = integrate(f, x)
        verbose && println("Integration successful")
        return result
        
    catch e
        if e isa NotImplementedError
            verbose && println("Function not supported: ", e.msg)
            return ∫(f, x)  # Return symbolic form
            
        elseif e isa AlgorithmFailedError
            verbose && println("Algorithm failed, trying with algebraic numbers: ", e.msg)
            try
                # Retry with algebraic numbers
                return integrate(f, x, useQQBar=true)
            catch e2
                verbose && println("Algebraic number attempt failed: ", e2.msg)
                return ∫(f, x)
            end
            
        else
            # Unexpected error
            rethrow(e)
        end
    end
end
```

### Common Error Scenarios

1. **Unsupported Functions**: Algebraic functions, special functions
2. **Complex Arguments**: Highly nested expressions  
3. **Numerical Issues**: Very large or very small coefficients
4. **Memory Exhaustion**: Extremely high-degree polynomials

## Examples by Function Category

### Supported Function Classes

```julia
# Rational functions - Always supported
integrate(x^3 / (x^2 + 1), x)

# Exponential functions - Well supported
integrate(x * exp(x^2), x)

# Logarithmic functions - Well supported  
integrate(1 / (x * log(x)), x)

# Trigonometric functions - Supported via transformations
integrate(sin(x) / (1 + cos(x)), x)

# Hyperbolic functions - Converted to exponential
integrate(tanh(x), x)
```

### Function Limitations

```julia
# These will return symbolic integrals:
integrate(sqrt(x), x)        # Algebraic function
integrate(exp(x^2), x)       # Non-elementary
integrate(sin(x)/x, x)       # Special integral
```

## Version Information

This API reference is for SymbolicIntegration.jl based on:
- Manuel Bronstein's "Symbolic Integration I: Transcendental Functions"
- AbstractAlgebra.jl backend for generic algorithms
- SymbolicUtils.jl frontend for expression handling
- Nemo.jl for algebraic number computations

For the latest updates and changes, see the [GitHub repository](https://github.com/HaraldHofstaetter/SymbolicIntegration.jl).