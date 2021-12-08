defmodule Day8 do
  def solve do
    input = """
    be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb |fdgacbe cefdb cefbgd gcbe
    edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec |fcgedb cgb dgebacf gc
    fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef |cg cg fdcagb cbg
    fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega |efabcd cedba gadfec cb
    aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga |gecf egdcabf bgf bfgea
    fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf |gebdcfa ecba ca fadegcb
    dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf |cefg dcbef fcge gbcadfe
    bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd |ed bcgafe cdgba cbgef
    egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg |gbdfcae bgc cg cgb
    gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc |fgae cfgab fg bagce
    """

    input = File.read!("inputs/day8_input.txt")

    part1 =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [_first, second] = String.split(line, "|", trim: true)

        String.split(second, " ", trim: true)
      end)
      |> List.flatten()
      |> Enum.filter(fn digit ->
        String.length(digit) == 2 or
          String.length(digit) == 4 or
          String.length(digit) == 3 or
          String.length(digit) == 7
      end)
      |> Enum.count()

    IO.puts("Part 1: #{part1}")

    part2 =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [signals, digits] = String.split(line, "|", trim: true)

        signals =
          signals
          |> String.split(" ", trim: true)
          |> Enum.map(&String.split(&1, "", trim: true))

        digits =
          digits
          |> String.split(" ", trim: true)
          |> Enum.map(&String.split(&1, "", trim: true))
          |> Enum.map(&MapSet.new/1)

        {signals, digits}
      end)
      |> Enum.map(&calc_number/1)
      |> Enum.sum()

    IO.puts("Part 2: #{part2}")
  end

  def calc_number({signals, digits}) do
    signals = indentify_signals(signals)

    digits
    |> Enum.map(fn digit ->
      Map.get(signals, digit)
    end)
    |> Enum.join()
    |> String.to_integer()
  end

  def indentify_signals(signals) do
    one = Enum.find(signals, &(length(&1) == 2))
    four = Enum.find(signals, &(length(&1) == 4))
    seven = Enum.find(signals, &(length(&1) == 3))
    eight = Enum.find(signals, &(length(&1) == 7))

    six_zero_nine = Enum.filter(signals, &(length(&1) == 6))

    # six can't contain both elements from one
    six =
      six_zero_nine
      |> Enum.reject(fn candidate ->
        [one1, one2] = one
        Enum.member?(candidate, one1) and Enum.member?(candidate, one2)
      end)
      |> hd

    zero_nine = Enum.reject(six_zero_nine, &(&1 == six))

    # nine must contain all signals from four
    nine =
      zero_nine
      |> Enum.find(fn x ->
        MapSet.subset?(MapSet.new(four), MapSet.new(x))
      end)

    zero = Enum.reject(zero_nine, &(&1 == nine)) |> hd

    two_three_five = Enum.filter(signals, &(length(&1) == 5))

    # five is a subset of six
    five =
      two_three_five
      |> Enum.find(fn x ->
        MapSet.subset?(MapSet.new(x), MapSet.new(six))
      end)

    two_three = Enum.reject(two_three_five, &(&1 == five))

    # one is a subset of three
    three =
      two_three
      |> Enum.find(fn x ->
        MapSet.subset?(MapSet.new(one), MapSet.new(x))
      end)

    two = Enum.reject(two_three, &(&1 == three)) |> hd

    %{
      MapSet.new(zero) => 0,
      MapSet.new(one) => 1,
      MapSet.new(two) => 2,
      MapSet.new(three) => 3,
      MapSet.new(four) => 4,
      MapSet.new(five) => 5,
      MapSet.new(six) => 6,
      MapSet.new(seven) => 7,
      MapSet.new(eight) => 8,
      MapSet.new(nine) => 9
    }
  end
end
