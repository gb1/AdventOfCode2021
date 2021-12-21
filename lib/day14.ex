defmodule Day14 do
  def solve do
    input = """
    CFFPOHBCVVNPHCNBKVNV

    KO -> F
    CV -> H
    CF -> P
    FK -> B
    BN -> P
    VN -> K
    BC -> H
    OP -> S
    HS -> V
    HK -> N
    CC -> F
    CK -> V
    OC -> S
    SN -> C
    PK -> H
    BB -> S
    PO -> F
    HF -> K
    BV -> P
    HP -> F
    VF -> H
    BP -> H
    CH -> C
    KN -> O
    NP -> F
    FS -> F
    BH -> B
    VB -> P
    OS -> S
    KK -> O
    SO -> P
    NB -> O
    PS -> O
    KV -> O
    CS -> P
    PN -> O
    HB -> V
    NF -> P
    SC -> S
    NH -> N
    HV -> K
    FN -> V
    KS -> P
    BO -> C
    KP -> V
    OK -> B
    OV -> P
    CN -> C
    SB -> H
    VP -> C
    HC -> P
    FB -> F
    VS -> K
    PH -> C
    VC -> H
    KH -> B
    SH -> B
    BK -> N
    SP -> P
    SF -> B
    OO -> B
    VH -> K
    PP -> C
    FV -> P
    KC -> P
    CO -> S
    NO -> O
    FO -> K
    SK -> O
    ON -> K
    VO -> H
    VV -> H
    CP -> P
    FC -> B
    FP -> N
    FH -> C
    KF -> F
    PB -> C
    NN -> K
    SS -> O
    CB -> C
    HH -> S
    FF -> S
    KB -> N
    HO -> O
    BF -> N
    PV -> K
    OB -> B
    OH -> N
    VK -> V
    NV -> H
    SV -> F
    NC -> P
    OF -> V
    NS -> V
    PF -> N
    HN -> K
    BS -> S
    NK -> H
    PC -> O
    """

    [template_src, insertions_src] = String.split(input, "\n\n", trim: true)

    template = String.split(template_src, "", trim: true)

    insertions =
      insertions_src
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, " -> ", trim: true))
      |> Map.new(fn [key, value] -> {String.split(key, "", trim: true), value} end)

    substitute(template, insertions, [])

    frequencies =
      steps(10, template, insertions)
      |> Enum.frequencies()
      |> Enum.map(fn {_key, value} ->
        value
      end)
      |> Enum.sort(:desc)

    part1 = List.first(frequencies) - List.last(frequencies)
    IO.puts("Part 1: #{part1}")

    ## PART 2
    ## Create a map of pairs from the template

    template =
      Enum.chunk_every(template, 2, 1)
      # remove solo end chunk
      |> Enum.reject(&(length(&1) == 1))
      |> Enum.reduce(%{}, fn [char1, char2], acc ->
        key = {char1, char2}
        value = Map.get(acc, key)

        if value do
          Map.put(acc, key, value + 1)
        else
          Map.put(acc, key, 1)
        end
      end)

    insertions =
      insertions_src
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, " -> ", trim: true))
      |> Enum.map(fn [target, replace] ->
        [char1, char2] = String.split(target, "", trim: true)
        [{char1, char2}, replace]
      end)

    # store a frequeny map of chars
    freqs =
      template_src
      |> String.split("", trim: true)
      |> Enum.frequencies()

    Agent.start_link(fn -> freqs end, name: :cache)

    go(40, template, insertions)

    frequencies =
      Agent.get(:cache, & &1)
      |> Enum.map(fn {_key, value} ->
        value
      end)
      |> Enum.sort(:desc)

    part2 = List.first(frequencies) - List.last(frequencies)
    IO.puts("Part 2: #{part2}")
  end

  ## Part 2

  def go(0, template, insertions) do
    template
  end

  def go(count, template, insertions) do
    go(count - 1, sub(insertions, template, template, []), insertions)
  end

  def remove_matches([], polymer), do: polymer

  def remove_matches([{pair, amount} | rest], polymer) do
    remove_matches(rest, Map.update(polymer, pair, nil, &(&1 - amount)))
  end

  def sub([], _template, polymer, matches) do
    remove_matches(matches, polymer)
  end

  def sub([[{char1, char2}, replace] | rest], template, polymer, matches) do
    match = Map.get(template, {char1, char2})

    if !is_nil(match) and match != 0 do
      # increase the {x,m}, {m, y} counts by current * match
      polymer =
        polymer
        |> Map.update({char1, replace}, match, fn current ->
          case current do
            0 -> match
            _ -> match + current
          end
        end)
        |> Map.update({replace, char2}, match, fn current ->
          case current do
            0 -> match
            _ -> match + current
          end
        end)

      Agent.update(:cache, &Map.update(&1, replace, match, fn x -> x + match end))

      sub(rest, template, polymer, [{{char1, char2}, match} | matches])
    else
      sub(rest, template, polymer, matches)
    end
  end

  def decrement(template, []), do: template

  def decrement(template, [decrement | rest]) do
    decrement(Map.update(template, decrement, nil, &(&1 - 1)), rest)
  end

  def increment(template, []), do: template

  def increment(template, [increment | rest]) do
    increment(Map.update(template, increment, 1, &(&1 + 1)), rest)
  end

  ## Part 1 naive approach
  def steps(0, template, _insertions), do: template

  def steps(count, template, insertions) do
    steps(count - 1, substitute(template, insertions, []), insertions)
  end

  def substitute([char1, char2 | rest], insertions, result) do
    match = Map.get(insertions, [char1, char2])

    if match do
      substitute([char2 | rest], insertions, [match, char1 | result])
    else
      substitute([char2 | rest], insertions, [char1 | result])
    end
  end

  def substitute([last], _, result), do: Enum.reverse([last | result])
end
