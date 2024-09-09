defmodule AppWeb.AuthController do
  alias App.Auth
  alias App.Auth.User

  use AppWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      token: auth.credentials.token,
      email: auth.info.nickname,
      provider: "github"
    }

    changeset = User.changeset(%User{}, user_params)
    signin(conn, changeset)
  end

  def callback(%{error: _error} = conn, _params) do
    maybe_error(conn)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: ~p"/")
  end

  defp signin(conn, changeset) do
    case Auth.insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back, #{user.email}!")
        |> put_session(:user_id, user.id)
        |> redirect(to: ~p"/")

      {:error, _reason} ->
        maybe_error(conn)
    end
  end

  defp maybe_error(conn) do
    conn
    |> put_flash(:error, "Error signing in")
    |> redirect(to: ~p"/")
  end
end
