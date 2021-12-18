module day06
  using LinearAlgebra

  function solve()::Nothing
    timers = parse.(Int, split(readline(".input/day06"), ','))
    timers = [count(timers .== i) for i in 0:8]

    matrix = circshift(Matrix(1I, 9, 9), -1)
    matrix[7, 1] = 1

    answer₁ = matrix^80  * timers |> sum
    answer₂ = matrix^256 * timers |> sum

    println("day06: $answer₁ $answer₂")
  end
end
