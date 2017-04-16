defmodule Game.Supervisor do
  use Supervisor

  @name GameSupervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    children = [
      worker(Game.Universe, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def create_universe(width, height) do
    Supervisor.start_child(@name, [[width, height]])
  end
end
