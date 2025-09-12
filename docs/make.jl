using Documenter
using SymbolicIntegration

makedocs(
    modules = [SymbolicIntegration],
    sitename = "SymbolicIntegration.jl",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true"
    ),
    pages = [
        "Home" => "index.md",
        "Tutorials" => [
            "Getting Started" => "tutorials/getting_started.md",
            "Method Selection" => "tutorials/method_selection.md",
            "Advanced Examples" => "tutorials/advanced_examples.md"
        ],
        "API Reference" => "api.md"
    ]
)

deploydocs(
    repo = "github.com/HaraldHofstaetter/SymbolicIntegration.jl.git"
)