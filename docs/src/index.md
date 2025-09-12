# SymbolicIntegration.jl Documentation

Welcome to the documentation for **SymbolicIntegration.jl**, a Julia package that provides implementations of symbolic integration algorithms.

## Overview

SymbolicIntegration.jl implements algorithms from the renowned book:

> Manuel Bronstein, [Symbolic Integration I: Transcendental Functions](https://link.springer.com/book/10.1007/b138171), 2nd ed, Springer 2005

The package provides a comprehensive set of reference implementations for symbolic integration of rational functions and integrands involving transcendental elementary functions such as `exp`, `log`, `sin`, `cos`, `tan`, etc.

## Key Features

- **Rational Function Integration**: Complete support for integrating rational functions
- **Transcendental Functions**: Integration of expressions involving `exp`, `log`, trigonometric, and hyperbolic functions
- **Multiple Integration Methods**: Automatic method selection based on integrand structure
- **Symbolic Computation**: Built on top of SymbolicUtils.jl for symbolic manipulation
- **Algebraic Number Support**: Optional support for calculations with algebraic numbers via Nemo.jl

## Architecture

The package is structured as follows:

- **Frontend**: User interface through SymbolicUtils.jl
- **Backend**: Generic algorithms implemented using AbstractAlgebra.jl
- **Algebraic Numbers**: Optional support via Nemo.jl for advanced cases

## Current Limitations

- Integrands involving algebraic functions like `sqrt` and non-integer powers are not currently supported
- The package is in early development and may not run stably in all situations
- No warranty is provided

## Quick Start

```julia
using SymbolicIntegration, SymbolicUtils

@syms x
f = (x^3 + x^2 + x + 2)//(x^4 + 3*x^2 + 2)
integrate(f, x)
```

For detailed examples and usage patterns, see the [Getting Started Tutorial](tutorials/getting_started.md).

## Installation

Since the package is not yet registered, install it directly from GitHub:

```julia
using Pkg
Pkg.add(PackageSpec(url="https://github.com/HaraldHofstaetter/SymbolicIntegration.jl"))
```

## Getting Help

- Browse the [Tutorials](tutorials/getting_started.md) for step-by-step guides
- Check the [API Reference](api.md) for detailed function documentation
- View the source code on [GitHub](https://github.com/HaraldHofstaetter/SymbolicIntegration.jl)