defmodule Day3 do
  def solve do
    # Test input...
    # input = [
    #   "00100",
    #   "11110",
    #   "10110",
    #   "10111",
    #   "10101",
    #   "01111",
    #   "00111",
    #   "11100",
    #   "10000",
    #   "11001",
    #   "00010",
    #   "01010"
    # ]

    input =
      File.read!("inputs/day3_input.txt")
      |> String.split("\n", trim: true)

    IO.puts("Part 1: #{gamma(input) * epsilon(input)}")

    input =
      input
      |> Enum.map(&String.split(&1, "", trim: true))

    IO.puts("Part 2: #{oxygen_generator(input, 0) * co2_scrubber(input, 0)}")
  end

  def gamma(input) do
    input
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.frequencies(&1))
    |> Enum.map(fn %{"0" => zeros, "1" => ones} ->
      if ones > zeros do
        1
      else
        0
      end
    end)
    |> Enum.join()
    |> Integer.parse(2)
    |> elem(0)
  end

  def epsilon(input) do
    input
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.frequencies(&1))
    |> Enum.map(fn %{"0" => zeros, "1" => ones} ->
      if ones < zeros do
        1
      else
        0
      end
    end)
    |> Enum.join()
    |> Integer.parse(2)
    |> elem(0)
  end

  def oxygen_generator([result], _index) do
    result
    |> Enum.join()
    |> Integer.parse(2)
    |> elem(0)
  end

  def oxygen_generator(numbers, index) do
    bit = most_common_at_n(numbers, index)

    numbers
    |> Enum.filter(&(Enum.at(&1, index) == bit))
    |> oxygen_generator(index + 1)
  end

  def co2_scrubber([result], _index) do
    result
    |> Enum.join()
    |> Integer.parse(2)
    |> elem(0)
  end

  def co2_scrubber(numbers, index) do
    bit = least_common_at_n(numbers, index)

    numbers
    |> Enum.filter(&(Enum.at(&1, index) == bit))
    |> co2_scrubber(index + 1)
  end

  def most_common_at_n(numbers, n) do
    %{"0" => zeros, "1" => ones} =
      numbers
      |> Enum.map(&Enum.at(&1, n))
      |> Enum.frequencies()

    cond do
      zeros > ones -> "0"
      ones > zeros -> "1"
      true -> "1"
    end
  end

  def least_common_at_n(numbers, n) do
    %{"0" => zeros, "1" => ones} =
      numbers
      |> Enum.map(&Enum.at(&1, n))
      |> Enum.frequencies()

    cond do
      zeros < ones -> "0"
      ones < zeros -> "1"
      true -> "0"
    end
  end
end
