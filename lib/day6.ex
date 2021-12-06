defmodule Day6 do
  def solve do
    fish = [3, 4, 3, 1, 2]

    fish = [
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      4,
      1,
      2,
      1,
      1,
      4,
      1,
      1,
      1,
      5,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      5,
      1,
      1,
      1,
      1,
      3,
      1,
      1,
      2,
      1,
      2,
      1,
      3,
      3,
      4,
      1,
      4,
      1,
      1,
      3,
      1,
      1,
      5,
      1,
      1,
      1,
      1,
      4,
      1,
      1,
      5,
      1,
      1,
      1,
      4,
      1,
      5,
      1,
      1,
      1,
      3,
      1,
      1,
      5,
      3,
      1,
      1,
      1,
      1,
      1,
      4,
      1,
      1,
      1,
      1,
      1,
      2,
      4,
      1,
      1,
      1,
      1,
      4,
      1,
      2,
      2,
      1,
      1,
      1,
      3,
      1,
      2,
      5,
      1,
      4,
      1,
      1,
      1,
      3,
      1,
      1,
      4,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      4,
      1,
      1,
      4,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      2,
      1,
      1,
      5,
      1,
      1,
      1,
      4,
      1,
      1,
      5,
      1,
      1,
      5,
      3,
      3,
      5,
      3,
      1,
      1,
      1,
      4,
      1,
      1,
      1,
      1,
      1,
      1,
      5,
      3,
      1,
      2,
      1,
      1,
      1,
      4,
      1,
      3,
      1,
      5,
      1,
      1,
      2,
      1,
      1,
      1,
      1,
      1,
      5,
      1,
      1,
      1,
      1,
      1,
      2,
      1,
      1,
      1,
      1,
      4,
      3,
      2,
      1,
      2,
      4,
      1,
      3,
      1,
      5,
      1,
      2,
      1,
      4,
      1,
      1,
      1,
      1,
      1,
      3,
      1,
      4,
      1,
      1,
      1,
      1,
      3,
      1,
      3,
      3,
      1,
      4,
      3,
      4,
      1,
      1,
      1,
      1,
      5,
      1,
      3,
      3,
      2,
      5,
      3,
      1,
      1,
      3,
      1,
      3,
      1,
      1,
      1,
      1,
      4,
      1,
      1,
      1,
      1,
      3,
      1,
      5,
      1,
      1,
      1,
      4,
      4,
      1,
      1,
      5,
      5,
      2,
      4,
      5,
      1,
      1,
      1,
      1,
      5,
      1,
      1,
      2,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      2,
      1,
      1,
      1,
      1,
      1,
      1,
      5,
      1,
      1,
      1,
      1,
      1,
      1,
      3,
      1,
      1,
      2,
      1,
      1
    ]

    IO.puts("Part 1: #{days(80, fish)}")

    part2 =
      fish
      |> create_fish_map()
      |> part2(256)

    IO.puts("Part 2: #{part2}")
  end

  def days(0, fish), do: Enum.count(fish)

  def days(day, fish) do
    days(day - 1, day_passes(fish))
  end

  def day_passes(fish) do
    fish
    |> add_new_fish()
    |> Enum.map(&next_number/1)
  end

  # trigger new fish here!
  def next_number(0), do: 6
  def next_number(number), do: number - 1

  def add_new_fish(fish) do
    new_fish = Enum.count(fish, &(&1 === 0))

    if new_fish > 0 do
      new = for _ <- 1..new_fish, do: 9
      Enum.concat(fish, new)
    else
      fish
    end
  end

  def create_fish_map(fish) do
    %{
      0 => Enum.count(fish, &(&1 == 0)),
      1 => Enum.count(fish, &(&1 == 1)),
      2 => Enum.count(fish, &(&1 == 2)),
      3 => Enum.count(fish, &(&1 == 3)),
      4 => Enum.count(fish, &(&1 == 4)),
      5 => Enum.count(fish, &(&1 == 5)),
      6 => Enum.count(fish, &(&1 == 6)),
      7 => Enum.count(fish, &(&1 == 7)),
      8 => Enum.count(fish, &(&1 == 8))
    }
  end

  def part2(fish, 0) do
    Enum.map(fish, fn {_, value} ->
      value
    end)
    |> Enum.sum()
  end

  def part2(fish, day) do
    part2(go_fish(fish), day - 1)
  end

  def go_fish(fish) do
    fish_0 = Map.get(fish, 0)
    fish_1 = Map.get(fish, 1)
    fish_2 = Map.get(fish, 2)
    fish_3 = Map.get(fish, 3)
    fish_4 = Map.get(fish, 4)
    fish_5 = Map.get(fish, 5)
    fish_6 = Map.get(fish, 6)
    fish_7 = Map.get(fish, 7)
    fish_8 = Map.get(fish, 8)

    fish
    |> Map.put(0, fish_1)
    |> Map.put(1, fish_2)
    |> Map.put(2, fish_3)
    |> Map.put(3, fish_4)
    |> Map.put(4, fish_5)
    |> Map.put(5, fish_6)
    |> Map.put(6, fish_7 + fish_0)
    |> Map.put(7, fish_8)
    |> Map.put(8, fish_0)
  end
end
