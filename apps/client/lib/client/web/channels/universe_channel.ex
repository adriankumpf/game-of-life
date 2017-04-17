defmodule Client.Web.UniverseChannel do
  use Phoenix.Channel

  def join("universe:default", _auth, socket) do
    {:ok, socket}
  end

  def handle_in("init", %{"width" => width, "height" => height}, socket) do
    Universe.init(width, height)
    for _ <- 0..trunc(width*height*0.25) do
      x = :rand.uniform(width) - 1
      y = :rand.uniform(height) - 1
      Universe.create([x, y])
    end
    push socket, "cells",  %{cells: Universe.alive_cells()}
    {:noreply, socket}
  end

  def handle_in("tick", _params, socket) do
    Universe.tick()
    push socket, "cells",  %{cells: Universe.alive_cells()}
    {:noreply, socket}
  end
end
