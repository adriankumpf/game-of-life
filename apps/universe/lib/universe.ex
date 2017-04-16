defmodule Universe do

  alias Universe.Server

  defdelegate init(width, height), to: Server
  defdelegate create(pid, pos),    to: Server
  defdelegate kill(pid, pos),      to: Server
  defdelegate cells(pid),          to: Server
  defdelegate tick(pid),           to: Server
end
