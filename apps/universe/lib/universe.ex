defmodule Universe do

  alias Universe.Server

  defdelegate init(width, height), to: Server
  defdelegate alive_cells,         to: Server
  defdelegate create(pos),         to: Server
  defdelegate kill(pos),           to: Server
  defdelegate cells,               to: Server
  defdelegate tick,                to: Server
end
