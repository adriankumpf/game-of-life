defmodule Game.UniverseTest do
  use ExUnit.Case

  alias Game.Universe

  test "creating a universe" do
    {:ok, pid} = Universe.init(10, 10)
    assert Universe.get_alive_cells(pid) == []
  end

  test "create a cell" do
    {:ok, pid} = Universe.init(10, 10)
    :ok = Universe.create_cell(pid, {0, 0})
    assert Universe.get_alive_cells(pid) == [{0, 0}]
  end

  test "killing a cell" do
    {:ok, pid} = Universe.init(10, 10)
    :ok = Universe.create_cell(pid, {0, 0})
    assert Universe.get_alive_cells(pid) == [{0, 0}]
    :ok = Universe.kill_cell(pid, {0, 0})
    assert Universe.get_alive_cells(pid) == []
  end

  test "when ticking the univse living cells with fewer than two neighbours die" do
    {:ok, pid} = Universe.init(10, 10)
    :ok = Universe.create_cell(pid, {1, 1})
    :ok = Universe.create_cell(pid, {2, 2})
    assert Universe.get_alive_cells(pid) == [{1, 1}, {2, 2}]
    :ok = Universe.tick(pid)
    assert Universe.get_alive_cells(pid) == []
  end

  test "when ticking the univse living cells two or three neighbours live on" do
    {:ok, pid} = Universe.init(10, 10)
    :ok = Universe.create_cell(pid, {1, 0})
    :ok = Universe.create_cell(pid, {2, 1})
    :ok = Universe.create_cell(pid, {1, 2})
    assert Universe.get_alive_cells(pid) == [{1, 0}, {1, 2}, {2, 1}]
    :ok = Universe.tick(pid)
    assert Universe.get_alive_cells(pid) == [{1, 1}, {2, 1}]
  end

  test "when ticking the univse living cells with more than three neighbours die" do
    {:ok, pid} = Universe.init(10, 10)
    :ok = Universe.create_cell(pid, {0, 0})
    :ok = Universe.create_cell(pid, {0, 1})
    :ok = Universe.create_cell(pid, {1, 1})
    :ok = Universe.create_cell(pid, {2, 0})
    :ok = Universe.create_cell(pid, {2, 2})
    assert Universe.get_alive_cells(pid) == [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 2}]
    :ok = Universe.tick(pid)
    assert Universe.get_alive_cells(pid) == [{0, 0}, {0, 1}, {1, 2}, {2, 1}]
  end

  test "when ticking the univse dead cells with exactly three neighbours becomes alive" do
    {:ok, pid} = Universe.init(10, 10)
    :ok = Universe.create_cell(pid, {0, 0})
    :ok = Universe.create_cell(pid, {2, 0})
    :ok = Universe.create_cell(pid, {2, 2})
    assert Universe.get_alive_cells(pid) == [{0, 0}, {2, 0}, {2, 2}]
    :ok = Universe.tick(pid)
    assert Universe.get_alive_cells(pid) == [{1, 1}]
  end
end
