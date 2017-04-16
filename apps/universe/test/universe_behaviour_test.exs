defmodule Universe.BehaviourTest do
  use ExUnit.Case

  alias Universe.Behaviour, as: Universe

  test "creating a universe" do
    assert Universe.init(10, 10) |> get_alive_cells == []
  end

  test "create a cell" do
    alive_cells = Universe.init(10, 10)
                  |> Universe.create({0, 0})
                  |> get_alive_cells
    assert alive_cells == [{0, 0}]
  end

  test "killing a cell" do
    u_before = Universe.init(10, 10)
               |> Universe.create({0, 0})
    u_after = u_before
              |> Universe.kill( {0, 0})

    assert get_alive_cells(u_before) == [{0, 0}]
    assert get_alive_cells(u_after) == []
  end

  test "when ticking the univse living cells with fewer than two neighbours die" do
    u_before = Universe.init(10, 10)
               |> creates([{1, 1}, {2, 2}])
    u_after = Universe.tick(u_before)

    assert get_alive_cells(u_before) == [{1, 1}, {2, 2}]
    assert get_alive_cells(u_after) == []
  end

  test "when ticking the univse living cells two or three neighbours live on" do
    u_before = Universe.init(10, 10)
               |> creates([{1, 0}, {2, 1}, {1, 2} ])
    u_after = Universe.tick(u_before)

    assert get_alive_cells(u_before) == [{1, 0}, {1, 2}, {2, 1}]
    assert get_alive_cells(u_after) == [{1, 1}, {2, 1}]
  end

  test "when ticking the univse living cells with more than three neighbours die" do
    u_before = Universe.init(10, 10)
               |> creates([{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 2}])
    u_after = Universe.tick(u_before)

    assert get_alive_cells(u_before) == [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 2}]
    assert get_alive_cells(u_after) == [{0, 0}, {0, 1}, {1, 2}, {2, 1}]
  end

  test "when ticking the univse dead cells with exactly three neighbours becomes alive" do
    u_before = Universe.init(10, 10)
               |> creates([{0, 0}, {2, 0}, {2, 2}])
    u_after = Universe.tick(u_before)

    assert get_alive_cells(u_before) == [{0, 0}, {2, 0}, {2, 2}]
    assert get_alive_cells(u_after) == [{1, 1}]
  end

  defp creates(universe, cells) do
    Enum.reduce cells, universe, &Universe.create(&2, &1)
  end

  defp get_alive_cells(universe) do
    universe
    |> Map.to_list
    |> Enum.filter(fn
                     {_, 1} -> true
                     {_, 0} -> false
    end)
    |> Enum.map(fn {pos, _} -> pos end)
    |> Enum.sort
  end
end
