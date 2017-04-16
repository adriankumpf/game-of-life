defmodule Game.UniverseTest do
  use ExUnit.Case

  alias Game.Universe

  test "creating a universe" do
    {:ok, pid} = Universe.init(10, 10)
    assert get_alive_cells(pid) == []
  end

  test "create a cell" do
    {:ok, pid} = Universe.init(10, 10)
    :ok = Universe.create_cell(pid, {0, 0})
    assert get_alive_cells(pid) == [{0, 0}]
  end

  test "killing a cell" do
    {:ok, pid} = Universe.init(10, 10)
    :ok = Universe.create_cell(pid, {0, 0})
    assert get_alive_cells(pid) == [{0, 0}]
    :ok = Universe.kill_cell(pid, {0, 0})
    assert get_alive_cells(pid) == []
  end

  test "when ticking the univse living cells with fewer than two neighbours die" do
    {:ok, pid} = Universe.init(10, 10)
    create_cells(pid, [{1, 1}, {2, 2}])
    assert get_alive_cells(pid) == [{1, 1}, {2, 2}]
    :ok = Universe.tick(pid)
    assert get_alive_cells(pid) == []
  end

  test "when ticking the univse living cells two or three neighbours live on" do
    {:ok, pid} = Universe.init(10, 10)
    create_cells(pid, [{1, 0}, {2, 1}, {1, 2} ])
    assert get_alive_cells(pid) == [{1, 0}, {1, 2}, {2, 1}]
    :ok = Universe.tick(pid)
    assert get_alive_cells(pid) == [{1, 1}, {2, 1}]
  end

  test "when ticking the univse living cells with more than three neighbours die" do
    {:ok, pid} = Universe.init(10, 10)
    create_cells(pid, [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 2}])
    assert get_alive_cells(pid) == [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 2}]
    :ok = Universe.tick(pid)
    assert get_alive_cells(pid) == [{0, 0}, {0, 1}, {1, 2}, {2, 1}]
  end

  test "when ticking the univse dead cells with exactly three neighbours becomes alive" do
    {:ok, pid} = Universe.init(10, 10)
    create_cells(pid, [{0, 0}, {2, 0}, {2, 2}])
    assert get_alive_cells(pid) == [{0, 0}, {2, 0}, {2, 2}]
    :ok = Universe.tick(pid)
    assert get_alive_cells(pid) == [{1, 1}]
  end

  defp create_cells(pid, cells) do
    Enum.each cells, &Universe.create_cell(pid, &1)
  end

  defp get_alive_cells(pid) do
    Universe.get_cells(pid)
    |> Map.to_list
    |> Enum.filter(fn
        {_, 1} -> true
        {_, 0} -> false
       end)
    |> Enum.map(fn {pos, _} -> pos end)
    |> Enum.sort
  end
end
