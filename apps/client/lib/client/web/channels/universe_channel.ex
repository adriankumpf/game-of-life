defmodule Client.Web.UniverseChannel do
  use Phoenix.Channel

  def join("universe:default", _auth, socket) do
    {:ok, socket}
  end

  def handle_in("init", %{"width" => width, "height" => height}, socket) do
    Universe.init(width, height)
    push socket, "cells", Universe.cells()
    {:noreply, socket}
  end
end
