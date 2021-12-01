defmodule Day1 do
  def solve do
    depths =
      File.read!("inputs/day1_input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    IO.puts("part 1 -> #{part1(depths)}")
    IO.puts("part 2 -> #{part2(depths)}")
  end

  def part1(depths) do
    count_increases(depths)
  end

  def part2(depths) do
    calc_windows(depths, [])
    |> count_increases()
  end

  def count_increases(depths) do
    Enum.zip([hd(depths) | depths], depths)
    |> Enum.reduce(0, fn {x, y}, acc ->
      if y > x do
        acc + 1
      else
        acc
      end
    end)
  end

  def calc_windows([one, two, three | tail], windows) do
    calc_windows([two, three | tail], [one + two + three | windows])
  end

  def calc_windows(_, windows), do: Enum.reverse(windows)
end
