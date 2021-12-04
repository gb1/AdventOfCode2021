defmodule Day4 do
  def solve do
    input =
      File.read!("inputs/day4_input.txt")
      |> String.split("\n", trim: true)

    [numbers | boards] = input

    numbers = String.split(numbers, ",", trim: true)

    boards =
      boards
      |> Enum.chunk_every(5)
      |> Enum.map(&make_board/1)

    play(numbers, boards)
  end

  def play([], _boards), do: :done

  def play([number | tail], boards) do
    # remove number from boards
    boards =
      Enum.map(boards, fn board ->
        {lines, rows} = board

        lines =
          Enum.map(lines, fn line ->
            Enum.reject(line, &(&1 == number))
          end)

        rows =
          Enum.map(rows, fn row ->
            Enum.reject(row, &(&1 == number))
          end)

        {lines, rows}
      end)

    # check for a winner - Part 1
    Enum.each(boards, fn board ->
      {house, winning_board} = house?(board)

      if house do
        if !Process.get(:winner) do
          # Part 1
          IO.puts(total_board(winning_board) * String.to_integer(number))
          Process.put(:winner, total_board(winning_board) * String.to_integer(number))
        end

        IO.puts(total_board(winning_board) * String.to_integer(number))
      end
    end)

    # remove winning boards from game for Part 2
    boards =
      boards
      |> Enum.reject(fn board ->
        {house, _} = house?(board)
        house
      end)

    play(tail, boards)
  end

  def total_board({lines, _}) do
    List.flatten(lines)
    |> Enum.map(&String.to_integer(&1))
    |> Enum.sum()
  end

  def house?(board) do
    {lines, rows} = board

    winning_line =
      Enum.any?(lines, fn x ->
        x == []
      end)

    winning_row =
      Enum.any?(rows, fn x ->
        x == []
      end)

    {winning_line or winning_row, board}
  end

  def make_board(board) do
    lines = Enum.map(board, &String.split(&1, " ", trim: true))

    [
      [l1_1, l1_2, l1_3, l1_4, l1_5],
      [l2_1, l2_2, l2_3, l2_4, l2_5],
      [l3_1, l3_2, l3_3, l3_4, l3_5],
      [l4_1, l4_2, l4_3, l4_4, l4_5],
      [l5_1, l5_2, l5_3, l5_4, l5_5]
    ] = lines

    rows = [
      [l1_1, l2_1, l3_1, l4_1, l5_1],
      [l1_2, l2_2, l3_2, l4_2, l5_2],
      [l1_3, l2_3, l3_3, l4_3, l5_3],
      [l1_4, l2_4, l3_4, l4_4, l5_4],
      [l1_5, l2_5, l3_5, l4_5, l5_5]
    ]

    {lines, rows}
  end
end
