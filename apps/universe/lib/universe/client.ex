defmodule Universe.Client do

  @width 15
  @height 15
  @rate 250

  def start do
    {:ok, _pid} = Universe.init(@width, @height)
    randomly_place_cells()
    loop()
  end

  def randomly_place_cells do
    for _ <- 0..trunc(@width*@height*0.45) do
      x = :rand.uniform(@width) - 1
      y = :rand.uniform(@height) - 1
      Universe.create([x, y])
    end
  end

  def draw(cells) do
    for y <- 0..@height-1 do
      for x <- 0..@width-1  do
        cells[[x, y]]
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

  def loop do
    Universe.tick()
    Universe.cells() |> draw
    :timer.sleep(@rate)
    loop()
  end
end
