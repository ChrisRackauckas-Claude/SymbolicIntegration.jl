# Getting Started with SymbolicIntegration.jl

This tutorial will guide you through the basics of using SymbolicIntegration.jl to perform symbolic integration of various mathematical expressions.

## Installation

First, install the package directly from GitHub:

```julia
using Pkg
Pkg.add(PackageSpec(url="https://github.com/HaraldHofstaetter/SymbolicIntegration.jl"))
```

## Basic Setup

Start by loading the required packages:

```julia
using SymbolicIntegration, SymbolicUtils

# Define symbolic variables
@syms x
```

## Your First Integration

Let's start with a simple rational function:

```julia
# Define the integrand
f = (x^3 + x^2 + x + 2) / (x^4 + 3*x^2 + 2)

# Integrate
result = integrate(f, x)
println(result)  # (1//2)*log(2 + x^2) + atan(x)
```

## Understanding the Output

The result `(1//2)*log(2 + x^2) + atan(x)` shows:
- `//` represents exact rational numbers (1//2 = 1/2)
- `log` represents natural logarithm
- `atan` represents arctangent function

## Types of Integrands Supported

### 1. Rational Functions

SymbolicIntegration.jl excels at integrating rational functions (ratios of polynomials):

```julia
# Simple rational function
f1 = 1 / (x^2 + 1)
integrate(f1, x)  # atan(x)

# More complex rational function
f2 = (2*x^3 - x^2 + 4*x - 1) / (x^4 + x^2 + 1)
integrate(f2, x)
```

### 2. Logarithmic Functions

Integration of expressions involving logarithms:

```julia
# Simple logarithmic integrand
f3 = 1 / (x * log(x))
integrate(f3, x)  # log(log(x))

# More complex case
f4 = (1 + log(x)) / (x * log(x)^2)
integrate(f4, x)
```

### 3. Exponential Functions

Expressions involving exponential functions:

```julia
# Basic exponential
f5 = exp(x) / (1 + exp(x))
integrate(f5, x)

# Exponential with rational function
f6 = x * exp(x^2)
integrate(f6, x)
```

### 4. Trigonometric Functions

Integration of trigonometric expressions:

```julia
# Simple trigonometric function
f7 = 1 / (1 + 2*cos(x))
result7 = integrate(f7, x)
println(result7)

# Mixed trigonometric and rational
f8 = sin(x) / (1 + cos(x)^2)
integrate(f8, x)
```

### 5. Hyperbolic Functions

Hyperbolic functions are automatically converted to exponential form:

```julia
# Hyperbolic sine
f9 = sinh(x) / (1 + cosh(x))
integrate(f9, x)

# Hyperbolic tangent
f10 = tanh(x)
integrate(f10, x)
```

## Working with Parameters

You can control the integration process using optional parameters:

### Using Algebraic Numbers

For integrands requiring algebraic number calculations:

```julia
# Enable algebraic numbers explicitly
f = 1 / sqrt(x^2 + 2)  # Note: algebraic functions not fully supported yet
# result = integrate(f, x, useQQBar=true)
```

### Error Handling Options

Control how the integrator handles errors:

```julia
# Catch implementation errors and return symbolic form
result = integrate(f, x, catchNotImplementedError=true)

# Catch algorithm failures  
result = integrate(f, x, catchAlgorithmFailedError=true)
```

## Understanding Integration Results

### Successful Integration

When integration succeeds, you get a symbolic expression:

```julia
f = x^2 * exp(x)
result = integrate(f, x)  # Returns symbolic result
```

### Partial Integration

Sometimes integration returns a mix of integrated and non-integrated parts:

```julia
# This might return: integrated_part + ∫(remaining_part, x)
f = complex_expression
result = integrate(f, x)
```

### Non-integrable Cases

When integration fails, the function returns the symbolic integral:

```julia
f = exp(x^2)  # Non-elementary integral
result = integrate(f, x)  # Returns ∫(exp(x^2), x)
```

## Common Patterns and Tips

### 1. Simplifying Complex Expressions

Break down complex expressions into simpler parts when possible:

```julia
# Instead of integrating a complex sum at once
f_complex = (x^2 + sin(x) + exp(x)) / (x + 1)

# Consider integrating term by term
f1 = x^2 / (x + 1)
f2 = sin(x) / (x + 1)  
f3 = exp(x) / (x + 1)

result = integrate(f1, x) + integrate(f2, x) + integrate(f3, x)
```

### 2. Checking Results

Always verify your integration results by differentiation:

```julia
using SymbolicUtils: Differential

f = x^3 + 2*x^2 + x + 1
integral_result = integrate(f, x)

# Check by differentiating
D = Differential(x)
derivative = expand_derivatives(D(integral_result))
println("Original: ", f)
println("Derivative of integral: ", derivative)
```

### 3. Working with Substitutions

For complex arguments, the package automatically handles substitutions:

```julia
# These are handled automatically through internal transformations
f1 = exp(2*x)      # Handled as exp(x)^2
f2 = sin(3*x)      # Converted using trigonometric identities
f3 = tan(x/2)      # Used in half-angle substitutions
```

## Next Steps

Now that you understand the basics:

1. Explore [Method Selection](method_selection.md) to understand how the package chooses integration algorithms
2. Check out [Advanced Examples](advanced_examples.md) for complex integration problems
3. Read the [API Reference](../api.md) for detailed function documentation

## Troubleshooting

### Common Issues

1. **NotImplementedError**: The integrand contains unsupported functions or structures
2. **AlgorithmFailedError**: The algorithm couldn't complete the integration
3. **AlgebraicNumbersInvolved**: Try setting `useQQBar=true`

### Getting Help

If you encounter issues:
- Check that your expression uses supported functions
- Try simplifying the integrand
- Enable algebraic numbers with `useQQBar=true`
- Review the error message for specific guidance

```julia
# Example of handling errors gracefully
try
    result = integrate(f, x)
    println("Integration successful: ", result)
catch e
    if e isa NotImplementedError
        println("This integrand is not supported: ", e.msg)
    elseif e isa AlgorithmFailedError
        println("Algorithm failed: ", e.msg)
    else
        rethrow(e)
    end
end
```