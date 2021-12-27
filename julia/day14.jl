module day14
  using LinearAlgebra

  const Element = Char
  const Pair = Tuple{Element, Element}
  const Index = Int
  const Count = Int

  function solve()::Nothing
    input = readlines(".input/day14")
    start = input[1]
    rules = [(r[1], r[2], r[7]) for r ∈ @view input[3:end]]

    to_pair = Dict{Index, Pair}()
    to_index = Dict{Pair, Index}()
    to_insert = Dict{Pair, Element}()
    for (index, (a, b, insert)) ∈ enumerate(rules)
      to_pair[index] = (a, b)
      to_index[(a, b)] = index
      to_insert[(a, b)] = insert
    end

    pairs = zip(start, @view start[2:end])
    pair_indices = map(pair -> to_index[pair], pairs)
    pair_index_counts = [count(pair_indices .== i) for i ∈ 1:length(rules)]

    M = zeros(Count, length(rules), length(rules))
    for (index, (a, b)) ∈ to_pair
      insert = to_insert[(a, b)]
      M[to_index[(a, insert)], index] = 1
      M[to_index[(insert, b)], index] = 1
    end

    function count_elements(pair_index_counts::Vector{Count})::Dict{Element, Count}
      elements = Dict{Element, Count}()
      for el ∈ start
        elements[el] = get(elements, el, 0) + 1
      end
      for (index, count) ∈ enumerate(pair_index_counts)
        el, _ = to_pair[index]
        elements[el] = get(elements, el, 0) + count
      end
      elements
    end

    function most_least_common_diff(elements::Dict{Element, Count})::Count
      min, max = extrema(values(elements))
      max - min
    end

    answer₁ = M^10 * pair_index_counts |> count_elements |> most_least_common_diff
    answer₂ = M^40 * pair_index_counts |> count_elements |> most_least_common_diff

    println("day14: $answer₁ $answer₂")
  end
end
