defmodule Universe.Server do
  use GenServer

  alias Universe.Behaviour

  @name UniverseServer

  ### PUBLIC API

  def init(width, height) do
    GenServer.start_link(__MODULE__, Behaviour.init(width, height), name: @name)
  end

  def cells do
    GenServer.call(@name, :cells)
  end

  def alive_cells do
    GenServer.call(@name, :alive_cells)
  end

  def create([_x, _y] = position) do
    GenServer.cast(@name, {:create, position})
  end

  def kill([_x, _y] = position) do
    GenServer.cast(@name, {:kill, position})
  end

  def tick do
    GenServer.cast(@name, :tick)
  end

  ### SERVER API

  def init(cells) do
    {:ok, cells}
  end

  def handle_call(:cells, _from, cells) do
    {:reply, cells, cells}
  end

  def handle_call(:alive_cells, _from, cells) do
    {:reply, Behaviour.get_alive_cells(cells), cells}
  end

  def handle_cast({:create, position}, cells) do
    {:noreply, Behaviour.create(cells, position)}
  end

  def handle_cast({:kill, position}, cells) do
    {:noreply, Behaviour.kill(cells, position)}
  end

  def handle_cast(:tick, cells) do
    {:noreply, Behaviour.tick(cells)}
  end
end
