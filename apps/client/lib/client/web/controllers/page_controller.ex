defmodule Client.Web.PageController do
  use Client.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
