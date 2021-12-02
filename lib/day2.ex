defmodule Day2 do
  def solve do
    instructions =
      File.read!("inputs/day2_input.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn x ->
        [direction, count] = String.split(x, " ")
        {direction, String.to_integer(count)}
      end)

    IO.puts("Part 1: #{process(instructions, {0, 0})}")
    IO.puts("Part 2: #{aim(instructions, {0, 0}, 0)}")
    "🎅"
  end

  def process([], {x, y}), do: x * y
  def process([{"down", count} | tail], {x, y}), do: process(tail, {x, y + count})
  def process([{"up", count} | tail], {x, y}), do: process(tail, {x, y - count})
  def process([{"forward", count} | tail], {x, y}), do: process(tail, {x + count, y})

  def aim([], {x, y}, _aim), do: x * y
  def aim([{"down", count} | tail], {x, y}, aim), do: aim(tail, {x, y}, aim + count)
  def aim([{"up", count} | tail], {x, y}, aim), do: aim(tail, {x, y}, aim - count)

  def aim([{"forward", count} | tail], {x, y}, aim) do
    aim(tail, {x + count, y + aim * count}, aim)
  end
end
