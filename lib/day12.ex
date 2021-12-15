defmodule Day12 do
  def solve do
    input = """
    LP-cb
    PK-yk
    bf-end
    PK-my
    end-cb
    BN-yk
    cd-yk
    cb-lj
    yk-bf
    bf-lj
    BN-bf
    PK-cb
    end-BN
    my-start
    LP-yk
    PK-bf
    my-BN
    start-PK
    yk-EP
    lj-BN
    lj-start
    my-lj
    bf-LP
    """

    map =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, fn line, acc ->
        [cave1, cave2] = String.split(line, "-", trim: true)

        acc
        |> Map.update(cave1, MapSet.new([cave2]), fn linked_caves ->
          MapSet.put(linked_caves, cave2)
        end)
        |> Map.update(cave2, MapSet.new([cave1]), fn linked_caves ->
          MapSet.put(linked_caves, cave1)
        end)
      end)

    path = [["start"]]

    part1 = find_paths(path, map, []) |> length()
    IO.puts("Part 1: #{part1}")

    # |> length()
    part2 =
      find_paths2(path, map, [])
      |> Enum.map(&Enum.reverse/1)
      |> length()

    IO.puts("Part 2: #{part2}")
  end

  def find_paths([], _map, finished_paths), do: finished_paths

  def find_paths([path | paths], map, final_paths) do
    next_paths = next_steps(path, map)
    {open_paths, finished_paths} = find_finished_paths(next_paths, [], [])
    find_paths(paths ++ open_paths, map, finished_paths ++ final_paths)
  end

  def next_steps([cave | path], map) do
    next_caves =
      map[cave]
      |> Enum.reject(&(is_small_cave?(&1) and &1 in path))

    for next <- next_caves do
      [next, cave | path]
    end
  end

  def find_finished_paths([], open_paths, finished_paths), do: {open_paths, finished_paths}

  def find_finished_paths([path | paths], open_paths, finished_paths) do
    case path do
      ["end" | _] ->
        find_finished_paths(paths, open_paths, [path | finished_paths])

      _ ->
        find_finished_paths(paths, [path | open_paths], finished_paths)
    end
  end

  def is_small_cave?(cave), do: String.upcase(cave) != cave
  def is_big_cave?(cave), do: String.upcase(cave) == cave

  ## PART 2
  def find_paths2([], _map, finished_paths), do: finished_paths

  def find_paths2([path | paths], map, final_paths) do
    next_paths = next_steps2(path, map)

    next_paths =
      next_paths
      |> Enum.filter(&is_legal_path?/1)

    # IO.inspect(next_paths, label: "legal")

    {open_paths, finished_paths} = find_finished_paths(next_paths, [], [])
    find_paths2(paths ++ open_paths, map, finished_paths ++ final_paths)
  end

  def next_steps2([cave | path], map) do
    next_caves =
      map[cave]
      |> Enum.reject(&(&1 == "start"))

    for next <- next_caves do
      [next, cave | path]
    end

    # end
  end

  def is_legal_path?(path) do
    freqs =
      path
      |> Enum.filter(&is_small_cave?/1)
      |> Enum.frequencies()
      |> Enum.map(fn {_cave, freq} ->
        freq
      end)
      |> Enum.filter(&(&1 >= 2))

    if Enum.any?(freqs, &(&1 > 2)) do
      false
    else
      if Enum.count(freqs, &(&1 == 2)) > 1 do
        false
      else
        true
      end
    end
  end
end
