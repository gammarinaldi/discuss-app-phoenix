defmodule App.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias App.Repo
  alias App.Auth.User

  def insert_or_update_user(attrs \\ %{}) do
    case Repo.get_by(User, email: attrs.changes.email) do
      nil ->
        Repo.insert(attrs)

      user ->
        {:ok, user}
    end
  end

  def get_user!(id), do: Repo.get!(User, id)
end
