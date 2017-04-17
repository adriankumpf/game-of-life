defmodule Universe.Behaviour do
  use GenServer

  @alive 1
  @dead  0

  def init(width, height)  do
    for x <- 0..width-1,
        y <- 0..height-1, into: %{}, do:
      {[x, y], @dead}
  end

  def create(cells, position) do
    Map.put(cells, position, @alive)
  end

  def kill(cells, position) do
    Map.put(cells, position, @dead)
  end

  def tick(cells) do
    tick(Map.to_list(cells), cells, {[], []})
  end
  def tick([], cells, {to_kill, to_create}) do
    cells = Enum.reduce to_kill, cells, &kill(&2, &1)
    cells = Enum.reduce to_create, cells, &create(&2, &1)
    cells
  end
  def tick([{cell, state} | rest], cells, {to_kill, to_create}) do
    case count_neighbours(cell, cells) do
      nc when state == @alive and not nc in [2,3] ->
        tick(rest, cells, {[cell | to_kill], to_create})
      nc when state == @dead and nc == 3 ->
        tick(rest, cells, {to_kill, [cell | to_create]})
      _ ->
        tick(rest, cells, {to_kill, to_create})
    end
  end

  defp count_neighbours([x, y], cells) do
    neighbours = for xn <- x-1..x+1,
                     yn <- y-1..y+1,
                     xn != x or yn != y, do:
                   [xn, yn]

    do_count_neighbours(neighbours, cells, 0)
  end

  defp do_count_neighbours([], _cells, sum), do: sum
  defp do_count_neighbours(_, _, sum) when sum > 3, do: :greater_three
  defp do_count_neighbours([n | rest], cells, sum) do
    do_count_neighbours(rest, cells, sum + Map.get(cells, n, 0))
  end

  def get_alive_cells(cells) do
    cells
    |> Enum.filter(fn
      {_, 1} -> true
      {_, 0} -> false
    end)
    |> Enum.map(fn {[x, y], _} ->
      %{x: x, y: y}
    end)
  end
end
