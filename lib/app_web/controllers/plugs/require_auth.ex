defmodule AppWeb.Plugs.RequireAuth do
  use AppWeb, :controller

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be log in")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end
