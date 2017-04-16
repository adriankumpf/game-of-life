defmodule Game.Universe do
  use GenServer

  ### PUBLIC API

  def init(width, height) do
    cells = for x <- 0..width,
                y <- 0..height, into: %{}, do:
              {{x, y}, :dead}

    GenServer.start_link(__MODULE__, cells)
  end

  def get_alive_cells(pid) do
    GenServer.call(pid, :get_alive_cells)
  end

  def create_cell(pid, {_x, _y} = position) do
    GenServer.cast(pid, {:create_cell, position})
  end

  def kill_cell(pid, {_x, _y} = position) do
    GenServer.cast(pid, {:kill_cell, position})
  end

  def tick(pid) do
    GenServer.cast(pid, :tick)
  end

  ### SERVER API

  def init(cells) do
    {:ok, cells}
  end

  def handle_call(:get_alive_cells, _from, cells) do
    {:reply, alive_cell_positions(cells), cells}
  end

  def handle_cast({:create_cell, position}, cells) do
    {:noreply, create(cells, position)}
  end

  def handle_cast({:kill_cell, position}, cells) do
    {:noreply, kill(cells, position)}
  end

  def handle_cast(:tick, cells) do
    {:noreply, do_tick(cells)}
  end

  ### PRIVATE

  defp alive_cell_positions(cells) do
    cells
    |> Enum.filter(fn
        {_, :alive} -> true
        {_, :dead } -> false
       end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sort
  end
  def create(cells, position) do
    Map.put(cells, position, :alive)
  end

  defp kill(cells, position) do
    Map.put(cells, position, :dead)
  end

  defp do_tick(cells) do
    do_tick(Map.to_list(cells), cells, {[], []})
  end

  defp do_tick([], cells, {to_kill, to_create}) do
    cells = Enum.reduce to_kill, cells, &kill(&2, &1)
    cells = Enum.reduce to_create, cells, &create(&2, &1)
    cells
  end
  defp do_tick([{cell, state} | rest], cells, {to_kill, to_create}) do
    case count_neighbours(cell, cells) do
      n when state == :alive and n in [2,3] ->
        do_tick(rest, cells, {to_kill, to_create})
      _ when state == :alive ->
        do_tick(rest, cells, {[cell | to_kill], to_create})
      n when state == :dead and n == 3 ->
        do_tick(rest, cells, {to_kill, [cell | to_create]})
      _ ->
        do_tick(rest, cells, {to_kill, to_create})
    end
  end

  defp count_neighbours({x, y}, cells) do
    neighbours = for xn <- x-1..x+1,
                     yn <- y-1..y+1,
                     xn != x or yn != y, do:
                   {xn, yn}

    Enum.reduce neighbours, 0, fn pos, count ->
      if cells[pos] == :alive, do: count+1, else: count
    end
  end
end
