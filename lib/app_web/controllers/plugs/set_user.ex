defmodule AppWeb.Plugs.SetUser do
  import Plug.Conn

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && App.Auth.get_user!(user_id) ->
        assign(conn, :user, user)

      true ->
        assign(conn, :user, nil)
    end

    # user = App.Auth.get_user!(user_id)
    # case user do
    #   nil -> assign(conn, :user, nil)
    #   _ -> assign(conn, :user, user)
    # end
  end
end
