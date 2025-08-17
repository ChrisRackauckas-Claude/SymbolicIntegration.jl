using Documenter, SymbolicIntegration

makedocs(
    sitename="SymbolicIntegration.jl",
    modules=[SymbolicIntegration],
    clean=true,
    doctest=true,
    linkcheck=false,
    checkdocs=:none,
    format=Documenter.HTML(
        assets=String[],
        canonical="https://symbolicintegration.juliasymbolics.org/stable/",
        analytics = "G-6NLF2W4VR1",
    ),
    pages=[
        "Home" => "index.md",
        "Manual" => [
            "manual/getting_started.md",
            "manual/basic_usage.md",
            "manual/rational_functions.md",
            "manual/transcendental_functions.md",
        ],
        "API Reference" => "api.md",
    ],
)

deploydocs(
    repo="github.com/JuliaSymbolics/SymbolicIntegration.jl.git",
    target="build",
    devbranch="main",
    push_preview=true,
)