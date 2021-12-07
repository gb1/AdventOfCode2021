defmodule Day7 do
  def solve do
    input = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]

    input =
      File.read!("inputs/day7_input.txt")
      |> String.replace("\n", "")
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    max = Enum.max(input)
    min = Enum.min(input)

    part1 =
      for n <- min..max do
        Enum.map(input, &Kernel.abs(&1 - n))
        |> Enum.sum()
      end
      |> Enum.min()

    IO.puts("Part 1: #{part1}")

    part2 =
      for n <- min..max do
        Enum.map(input, fn x ->
          diff = Kernel.abs(x - n)

          if diff > 0 do
            1..diff
            |> Enum.to_list()
            |> Enum.sum()
          else
            0
          end
        end)
        |> Enum.sum()
      end
      |> Enum.min()

    IO.puts("Part 2: #{part2}")
  end
end
