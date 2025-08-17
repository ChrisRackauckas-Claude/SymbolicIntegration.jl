# Getting Started

## Installation

SymbolicIntegration.jl can be installed using the Julia package manager:

```julia
julia> using Pkg
julia> Pkg.add("SymbolicIntegration")
```

Or in package mode (press `]` in the Julia REPL):

```julia
pkg> add SymbolicIntegration
```

## Basic Usage

After installation, load the package along with SymbolicUtils.jl for symbolic variable creation:

```julia
using SymbolicIntegration, SymbolicUtils

# Create symbolic variables
@syms x

# Integrate a simple polynomial
integrate(x^2, x)  # Returns (1//3)*(x^3)
```

## Dependencies

SymbolicIntegration.jl builds on several key packages in the Julia ecosystem:

- **[SymbolicUtils.jl](https://symbolicutils.juliasymbolics.org/)**: Provides the symbolic expression system and user interface
- **[AbstractAlgebra.jl](https://nemocas.github.io/AbstractAlgebra.jl/dev/)**: Generic computer algebra algorithms  
- **[Nemo.jl](https://nemocas.github.io/Nemo.jl/dev/)**: Fast calculations with algebraic numbers

## System Requirements

- Julia 1.10 or later
- Compatible with Linux, macOS, and Windows