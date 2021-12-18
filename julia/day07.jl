module day07
  using Statistics

  # triangular numbers
  △(x) = x * (x + 1) / 2

  function solve()::Nothing
    xs = parse.(Int, split(readline(".input/day07"), ','))
    x̃ = median(xs)
    μ = mean(xs)

    # https://reddit.com/r/adventofcode/comments/rav728/comment/hnkvnzr/
    μ′ = round(μ + 1/2 - count(xs .< μ)/length(xs))

    answer₁ = xs .- x̃ .|> abs |> sum |> Int
    answer₂ = xs .- μ′ .|> abs .|> △ |> sum |> Int

    println("day07: $answer₁ $answer₂")
  end
end
