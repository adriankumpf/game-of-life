defmodule Game do

  @width 60
  @height 40
  @rate 250

  def start do
    {:ok, pid} = Game.Universe.init(@width, @height)
    :ok = randomly_place_cells(pid)
    loop(pid)
  end

  def randomly_place_cells(pid) do
    for _ <- 0..trunc(@width*@height*0.45) do
      x = :rand.uniform(@width) - 1
      y = :rand.uniform(@height) - 1
      Game.Universe.create_cell(pid, {x, y})
    end
    :ok
  end

  def draw(cells) do
    for y <- 0..@height-1 do
      for x <- 0..@width-1  do
        cells[{x, y}]
        |> to_symbol
        |> String.pad_leading(3)
        |> IO.write
      end
      IO.puts ''
    end
    IO.puts ''
  end

  defp to_symbol(1), do: "O"
  defp to_symbol(_), do: "-"

  def loop(pid) do
    Game.Universe.tick(pid)
    Game.Universe.get_cells(pid) |> draw
    :timer.sleep(@rate)
    loop(pid)
  end
end
