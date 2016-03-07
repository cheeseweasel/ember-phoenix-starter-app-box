defmodule Starterapp.PageController do
  use Starterapp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
