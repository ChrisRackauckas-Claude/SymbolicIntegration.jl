# Advanced Integration Examples

This tutorial demonstrates advanced usage of SymbolicIntegration.jl with complex integrands and sophisticated integration techniques.

## Complex Rational Functions

### Partial Fraction Decomposition

```julia
using SymbolicIntegration, SymbolicUtils
@syms x

# Complex rational function requiring partial fraction decomposition
f1 = (x^4 + 2*x^3 + 3*x^2 + 4*x + 5) / ((x^2 + 1)^2 * (x^2 + 2*x + 2))
result1 = integrate(f1, x)
println("Complex rational: ", result1)

# High-degree denominator
f2 = (x^6 + x^4 + x^2 + 1) / (x^8 + 4*x^6 + 6*x^4 + 4*x^2 + 1)
result2 = integrate(f2, x)
println("High-degree rational: ", result2)
```

### Rational Functions with Repeated Roots

```julia
# Repeated linear factors
f3 = (2*x^3 + 3*x^2 + x + 1) / ((x + 1)^3 * (x - 2)^2)
result3 = integrate(f3, x)

# Repeated irreducible quadratic factors
f4 = (x^3 + x + 1) / ((x^2 + x + 1)^2 * (x^2 + 2)^2)
result4 = integrate(f4, x)
```

## Transcendental Function Integration

### Nested Logarithms

```julia
# Simple nested logarithm
f5 = 1 / (x * log(x) * log(log(x)))
result5 = integrate(f5, x)
println("Nested log: ", result5)

# Logarithm of rational function
f6 = (2*x + 1) / ((x^2 + x + 1) * log(x^2 + x + 1))
result6 = integrate(f6, x)
```

### Multiple Exponential Arguments

```julia
# Different exponential arguments
f7 = (exp(2*x) + exp(x) + 1) / (exp(3*x) + exp(2*x) + exp(x))
result7 = integrate(f7, x)

# Exponential with polynomial argument
f8 = x^2 * exp(x^3 + 2*x) 
result8 = integrate(f8, x)

# Mixed exponential and logarithmic
f9 = exp(x) * log(exp(x) + 1) / (exp(x) + 1)
result9 = integrate(f9, x)
```

### Complex Trigonometric Integrands

```julia
# Multiple trigonometric functions
f10 = (sin(2*x) + cos(3*x)) / (1 + sin(x) * cos(x))
result10 = integrate(f10, x)

# Rational function of trigonometric functions
f11 = (3*sin(x) + 2*cos(x)) / (sin(x) + cos(x) + 1)
result11 = integrate(f11, x)

# Higher-order trigonometric
f12 = tan(x)^3 / (1 + tan(x)^2)^2
result12 = integrate(f12, x)
```

## Integration with Algebraic Numbers

### Enabling Algebraic Number Support

```julia
# Functions requiring algebraic number calculations
f13 = 1 / (x^2 + x + 1)  # Involves complex roots
result13a = integrate(f13, x, useQQBar=false)  # Standard approach
result13b = integrate(f13, x, useQQBar=true)   # With algebraic numbers

println("Without ℚ̄: ", result13a)
println("With ℚ̄: ", result13b)

# More complex algebraic case
f14 = x / (x^4 + x^2 + 1)
result14 = integrate(f14, x, useQQBar=true)
```

### Automatic Algebraic Number Detection

```julia
# The package may automatically switch to algebraic numbers
f15 = 1 / (x^3 + x + 1)  # Cubic polynomial with complex roots
try
    result15 = integrate(f15, x)
    println("Algebraic auto-detection: ", result15)
catch e
    if e isa AlgebraicNumbersInvolved
        println("Switching to algebraic numbers...")
        result15 = integrate(f15, x, useQQBar=true)
    end
end
```

## Error Handling and Partial Integration

### Graceful Error Handling

```julia
# Function that may not be integrable in elementary terms
f16 = exp(x^2)  # Gaussian integral - not elementary

result16 = integrate(f16, x, 
    catchNotImplementedError=true,
    catchAlgorithmFailedError=true)
println("Non-elementary: ", result16)  # Should return ∫(exp(x^2), x)
```

### Partial Integration Results

```julia
# Functions that integrate partially
f17 = (x^2 + exp(x^3)) / (x + 1)

# May return: integrated_part + ∫(non_integrable_part, x)
result17 = integrate(f17, x)
println("Partial result: ", result17)
```

## Performance Optimization Examples

### Breaking Down Complex Expressions

```julia
# Instead of integrating this complex expression directly:
complex_f = (x^3*exp(2*x) + x^2*log(x^2+1) + sin(x)*cos(x)) / (x^2 + 1)

# Break it down into manageable parts:
term1 = x^3*exp(2*x) / (x^2 + 1)
term2 = x^2*log(x^2+1) / (x^2 + 1)  
term3 = sin(x)*cos(x) / (x^2 + 1)

# Integrate separately for better performance and error isolation
result_term1 = integrate(term1, x)
result_term2 = integrate(term2, x)
result_term3 = integrate(term3, x)

total_result = result_term1 + result_term2 + result_term3
```

### Simplification Before Integration

```julia
# Simplify expressions when possible
using SymbolicUtils

f18 = (exp(x) * (exp(x) + 1)^2) / (exp(2*x) + 2*exp(x) + 1)

# Simplify first
simplified_f18 = simplify(f18)
println("Original: ", f18)
println("Simplified: ", simplified_f18)

# Then integrate
result18 = integrate(simplified_f18, x)
```

## Real-World Application Examples

### Physics: Oscillator Problems

```julia
# Damped harmonic oscillator response
ω, γ = 2.0, 0.1  # Natural frequency and damping
f_oscillator = exp(-γ*x) * sin(ω*x) / (1 + x^2)
result_oscillator = integrate(f_oscillator, x)
```

### Engineering: Signal Processing

```julia
# Fourier-related integral
a, b = 1.0, 2.0
f_signal = (a*cos(b*x) + sin(b*x)) / (1 + x^4)
result_signal = integrate(f_signal, x)
```

### Mathematics: Special Function Integrals

```julia
# Integrals leading to inverse trigonometric functions
f_arctan = 1 / (1 + x^4)
result_arctan = integrate(f_arctan, x)

# Integrals involving logarithmic derivatives
f_log_deriv = (6*x^2 + 2*x) / (2*x^3 + x^2 + 1)
result_log_deriv = integrate(f_log_deriv, x)
```

## Testing and Verification

### Verifying Integration Results

```julia
using SymbolicUtils: Differential

# Verify integration by differentiation
f_test = x^3 * exp(x^2)
integral_result = integrate(f_test, x)

# Differentiate to check
D = Differential(x)
derivative_check = expand_derivatives(D(integral_result))
simplified_check = simplify(derivative_check)

println("Original function: ", f_test)
println("Derivative of integral: ", simplified_check)
println("Match: ", simplify(f_test - simplified_check) == 0)
```

### Numerical Verification

```julia
# For verification, you can also check numerically
using QuadGK

f_numeric = x -> x^2 * exp(x)
integral_symbolic = integrate(x^2 * exp(x), x)

# Evaluate at bounds (example: definite integral from 0 to 1)  
x_val = 1.0
symbolic_at_1 = substitute(integral_symbolic, Dict(x => x_val))
symbolic_at_0 = substitute(integral_symbolic, Dict(x => 0.0))
symbolic_definite = symbolic_at_1 - symbolic_at_0

# Compare with numerical integration
numerical_definite, _ = quadgk(f_numeric, 0, 1)
println("Symbolic definite: ", symbolic_definite)
println("Numerical definite: ", numerical_definite)
```

## Advanced Error Analysis

### Systematic Error Testing

```julia
# Test suite for various integration challenges
test_functions = [
    x^3 + 2*x^2 + x + 1,                    # Polynomial
    (x^2 + 1) / (x^3 + x),                  # Rational
    exp(x) / (1 + exp(x)),                   # Exponential
    sin(x) / (1 + cos(x)^2),                 # Trigonometric
    1 / (x * log(x)),                        # Logarithmic
    exp(x^2),                                # Non-elementary
    sqrt(x^2 + 1),                           # Algebraic (unsupported)
]

for (i, f) in enumerate(test_functions)
    try
        result = integrate(f, x)
        println("Test $i successful: ", result)
    catch e
        println("Test $i failed: ", typeof(e), " - ", e.msg)
    end
end
```

### Memory and Performance Monitoring

```julia
# Monitor performance for large expressions
using BenchmarkTools

large_polynomial = sum(x^i for i in 1:20) / sum(x^i for i in 1:15)

@time result_large = integrate(large_polynomial, x)
@benchmark integrate($large_polynomial, $x)
```

## Future Directions and Limitations

### Current Limitations

```julia
# These cases are not yet supported:
unsupported_cases = [
    sqrt(x^2 + 1),           # Algebraic functions
    x^(1//3),                # Non-integer powers  
    abs(x),                  # Absolute value
    sign(x),                 # Sign function
    floor(x),                # Step functions
]

# The package will return symbolic integrals for these
for f in unsupported_cases
    result = integrate(f, x)
    println("Unsupported: ", f, " → ", result)
end
```

### Working Around Limitations

```julia
# Sometimes you can work around limitations:

# Instead of sqrt(x^2 + a^2), use substitution results when known
# Instead of |x|, use x for x > 0 and -x for x < 0 separately
# For step functions, integrate piecewise

# Example: manual handling of absolute value
# ∫|x|dx = ∫x dx (x≥0) + ∫(-x) dx (x<0) = x²/2 (x≥0) + (-x²/2) (x<0)
```

## Summary

This tutorial covered advanced integration scenarios including:

- Complex rational functions with repeated roots
- Nested transcendental functions
- Algebraic number requirements
- Error handling strategies
- Performance optimization techniques
- Real-world applications
- Verification methods

For the most up-to-date capabilities and limitations, always refer to the [API Reference](../api.md) and test with your specific use cases.