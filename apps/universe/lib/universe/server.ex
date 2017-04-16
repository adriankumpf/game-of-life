defmodule Universe.Server do
  use GenServer

  alias Universe.Behaviour

  ### PUBLIC API

  def init(width, height) do
    GenServer.start_link(__MODULE__, Behaviour.init(width, height))
  end

  def cells(pid) do
    GenServer.call(pid, :cells)
  end

  def create(pid, {_x, _y} = position) do
    GenServer.cast(pid, {:create, position})
  end

  def kill(pid, {_x, _y} = position) do
    GenServer.cast(pid, {:kill, position})
  end

  def tick(pid) do
    GenServer.cast(pid, :tick)
  end

  ### SERVER API

  def init(cells) do
    {:ok, cells}
  end

  def handle_call(:cells, _from, cells) do
    {:reply, cells, cells}
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
