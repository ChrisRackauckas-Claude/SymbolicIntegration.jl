# Method Selection in SymbolicIntegration.jl

This tutorial explains how SymbolicIntegration.jl automatically selects and applies different integration methods based on the structure of your integrand.

## Overview of Integration Methods

SymbolicIntegration.jl implements several key algorithms from Manuel Bronstein's book "Symbolic Integration I: Transcendental Functions". The package automatically analyzes your integrand and selects the appropriate method.

## Automatic Method Selection

The integration process follows these steps:

1. **Expression Analysis**: Parse and classify the integrand structure
2. **Tower Construction**: Build a differential field tower for transcendental extensions
3. **Algorithm Selection**: Choose the appropriate integration algorithm
4. **Result Construction**: Transform the result back to symbolic form

## Method Categories

### 1. Rational Function Integration

**When Applied**: For integrands that are ratios of polynomials.

```julia
using SymbolicIntegration, SymbolicUtils
@syms x

# Pure rational function - uses rational function algorithms
f1 = (x^3 + 2*x^2 + x + 1) / (x^4 + 3*x^2 + 2)
result1 = integrate(f1, x)
println("Rational method: ", result1)
```

**Algorithm Details**:
- Partial fraction decomposition
- Integration of simple fractions
- Handling of repeated roots

### 2. Logarithmic Integration

**When Applied**: For integrands involving logarithmic functions or their derivatives.

```julia
# Logarithmic derivative form - uses logarithmic integration
f2 = (2*x + 1) / (x^2 + x + 1)
result2 = integrate(f2, x)
println("Logarithmic method: ", result2)

# Direct logarithmic integrand
f3 = 1 / (x * log(x))
result3 = integrate(f3, x)
println("Direct log integration: ", result3)
```

**Key Concepts**:
- Recognizes logarithmic derivative patterns: `f'/f` → `log(f)`
- Handles nested logarithms
- Applies Risch structure theorems

### 3. Exponential Integration

**When Applied**: For integrands containing exponential functions.

```julia
# Exponential integrand - uses exponential algorithms
f4 = exp(x) / (1 + exp(x))
result4 = integrate(f4, x)
println("Exponential method: ", result4)

# Multiple exponentials
f5 = (exp(2*x) + exp(x)) / (exp(x) + 1)
result5 = integrate(f5, x)
println("Multiple exponentials: ", result5)
```

**Algorithm Features**:
- Handles exponential-polynomial combinations
- Manages exponential towers of different arguments
- Applies Risch differential equation solving

### 4. Trigonometric Integration

**When Applied**: For integrands involving trigonometric functions.

```julia
# Trigonometric integrand - uses Weierstrass substitution and extensions
f6 = 1 / (1 + 2*cos(x))
result6 = integrate(f6, x)
println("Trigonometric method: ", result6)

# Mixed trigonometric
f7 = sin(x) / (1 + cos(x)^2)
result7 = integrate(f7, x)
println("Mixed trigonometric: ", result7)
```

**Internal Transformations**:
- Converts `sin`, `cos` to half-angle `tan` substitutions
- Handles multiple angles through rational multiples
- Applies complex exponential methods when needed

## Understanding the Selection Process

### Expression Classification

The package analyzes expressions using these criteria:

```julia
# Example showing different classifications

# 1. Pure rational - classified immediately
rational_expr = (x^2 + 1) / (x^3 + x)

# 2. Contains log - triggers logarithmic path
log_expr = log(x) / x

# 3. Contains exp - triggers exponential path  
exp_expr = exp(x^2) * x

# 4. Contains trig - triggers trigonometric path
trig_expr = tan(x) / (1 + tan(x)^2)

# Integration automatically selects appropriate method for each
integrate(rational_expr, x)
integrate(log_expr, x)     
integrate(exp_expr, x)
integrate(trig_expr, x)
```

### Tower of Differential Fields

For transcendental functions, the package constructs a tower:

```julia
# This integrand requires multiple extensions
complex_expr = exp(x) * log(exp(x) + 1) / x

# The algorithm automatically builds:
# Base field: ℚ(x)
# Extension 1: ℚ(x)(exp(x))  
# Extension 2: ℚ(x)(exp(x))(log(exp(x) + 1))
# Then integrates in the resulting field
result = integrate(complex_expr, x)
```

## Method-Specific Parameters

### Algebraic Number Fields

Some integrands require algebraic number computations:

```julia
# May trigger algebraic number requirement internally
f = 1 / (x^2 + x + 1)
result = integrate(f, x)

# Force algebraic numbers from the start
result_qqbar = integrate(f, x, useQQBar=true)
```

### Error Handling Strategies

Control method fallback behavior:

```julia
f = complex_integrand

# Catch method failures and return symbolic form
safe_result = integrate(f, x, 
    catchNotImplementedError=true,
    catchAlgorithmFailedError=true)
```

## Advanced Method Selection Examples

### 1. Automatic Hyperbolic Conversion

```julia
# Hyperbolic functions automatically convert to exponential form
f = sinh(x) / (1 + cosh(x))

# Internally becomes: (exp(x) - exp(-x))/2 / (1 + (exp(x) + exp(-x))/2)
# Then uses exponential integration methods
result = integrate(f, x)
```

### 2. Trigonometric Transformations

```julia
# sin/cos automatically use half-angle substitutions
f = sin(x) / (1 + cos(x))

# Internally becomes: 2*tan(x/2)/(1 + tan(x/2)^2) / (1 + (1 - tan(x/2)^2)/(1 + tan(x/2)^2))
# Then uses rational function methods on tan(x/2)
result = integrate(f, x)
```

### 3. Multiple Function Types

```julia
# Mixed integrand triggers multiple method coordination
f = exp(x) * sin(x) / (1 + log(x))

# The algorithm:
# 1. Identifies exp(x), sin(x), log(x) components
# 2. Builds appropriate differential field tower
# 3. Coordinates multiple integration techniques
# 4. May return partial results with symbolic integrals
result = integrate(f, x)
```

## Debugging Method Selection

### Verbose Analysis

To understand which methods are being applied, you can examine the integrand structure:

```julia
# Enable logging to see method selection
using Logging
logger = ConsoleLogger(stdout, Logging.Debug)

with_logger(logger) do
    result = integrate(your_function, x)
end
```

### Common Method Patterns

| Expression Type | Method Used | Example |
|----------------|-------------|---------|
| `P(x)/Q(x)` | Rational function | `x/(x^2+1)` |
| `f'(x)/f(x)` | Logarithmic | `2x/(x^2+1)` |
| `P(x)exp(Q(x))` | Exponential | `x*exp(x^2)` |
| `R(sin,cos)` | Trigonometric | `1/(1+sin(x))` |
| `Mixed` | Tower methods | `exp(x)*log(x)` |

## Limitations and Fallbacks

### Unsupported Cases

When automatic method selection fails:

```julia
# Algebraic functions (not yet supported)
f1 = sqrt(x^2 + 1)  # Returns ∫(sqrt(x^2 + 1), x)

# Non-elementary integrals  
f2 = exp(x^2)       # Returns ∫(exp(x^2), x)

# Complex nested structures
f3 = exp(exp(x))    # May return ∫(exp(exp(x)), x)
```

### Method Selection Override

Currently, the package doesn't provide manual method selection, but you can influence it:

```julia
# Simplify expressions to guide method selection
f_original = complex_expression

# Break into parts that favor specific methods
f_rational = rational_part
f_transcendental = transcendental_part

result = integrate(f_rational, x) + integrate(f_transcendental, x)
```

## Performance Considerations

### Method Efficiency

Different methods have varying computational costs:

1. **Rational functions**: Generally fastest
2. **Logarithmic**: Moderate complexity
3. **Exponential**: Can be expensive for complex towers
4. **Trigonometric**: Moderate to expensive depending on arguments
5. **Mixed**: Most expensive, requires coordination

### Optimization Tips

```julia
# Prefer simpler forms when possible
# Instead of:
f1 = exp(2*x) / (1 + exp(x))

# Consider rewriting as:
f2 = exp(x) * exp(x) / (1 + exp(x))
# Or even better, let the package handle exp(2*x) automatically

result = integrate(f1, x)  # Package handles this efficiently anyway
```

## Next Steps

- Explore [Advanced Examples](advanced_examples.md) to see complex method coordination
- Check the [API Reference](../api.md) for technical details on integration functions
- Study the source code for algorithm implementations