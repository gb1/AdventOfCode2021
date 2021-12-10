defmodule Day10 do
  def solve do
    input = """
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    """

    input = File.read!("inputs/day10_input.txt")

    part1 =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse/1)
      |> calc_score(0)

    IO.puts("Part 1: #{part1}")

    scores =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse/1)
      |> Enum.filter(fn {result, _line} ->
        result == :incomplete
      end)
      |> Enum.map(fn {:incomplete, incomplete_string} ->
        incomplete_string
        |> autocomplete()
        |> score_autocomplete(0)
      end)
      |> Enum.sort()

    part2 = Enum.at(scores, (length(scores) - 1) |> div(2))

    IO.puts("Part 2: #{part2}")
  end

  def parse(line) do
    cond do
      line === "" ->
        :valid

      valid?(line) ->
        line
        |> String.replace("()", "")
        |> String.replace("{}", "")
        |> String.replace("[]", "")
        |> String.replace("<>", "")
        |> parse()

      true ->
        if contains_only_open_brackets?(line) do
          {:incomplete, line}
        else
          {:expected, expected_char(line)}
        end
    end
  end

  def calc_score([], total), do: total

  def calc_score([line_result | results], total) do
    calc_score(results, total + score(line_result))
  end

  def score({:expected, ")"}), do: 3
  def score({:expected, "]"}), do: 57
  def score({:expected, "}"}), do: 1197
  def score({:expected, ">"}), do: 25137
  def score(_), do: 0

  # a valid line must contain a pair
  def valid?(line) do
    String.contains?(line, "()") or
      String.contains?(line, "{}") or
      String.contains?(line, "[]") or
      String.contains?(line, "<>")
  end

  def contains_only_open_brackets?(line) do
    has_closing_bracket =
      String.contains?(line, ")") or
        String.contains?(line, "}") or
        String.contains?(line, "]") or
        String.contains?(line, ">")

    !has_closing_bracket
  end

  def expected_char(line) do
    closing_brackets = [")", "}", "]", ">"]

    String.split(line, "", trim: true)
    |> Enum.chunk_every(2, 1)
    |> Enum.find(fn [_a, b] ->
      Enum.member?(closing_brackets, b)
    end)
    |> List.last()
  end

  def autocomplete(input) when is_bitstring(input) do
    autocomplete(String.split(input, "", trim: true), [])
  end

  def autocomplete([], result), do: result

  def autocomplete([char | tail], result) do
    autocomplete(tail, [matching(char) | result])
  end

  def matching("("), do: ")"
  def matching("{"), do: "}"
  def matching("["), do: "]"
  def matching("<"), do: ">"

  def score_autocomplete([], score), do: score

  def score_autocomplete([bracket | tail], score) do
    score_autocomplete(
      tail,
      score * 5 + bracket_score(bracket)
    )
  end

  def bracket_score(")"), do: 1
  def bracket_score("}"), do: 3
  def bracket_score("]"), do: 2
  def bracket_score(">"), do: 4
end
