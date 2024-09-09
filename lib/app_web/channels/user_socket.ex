defmodule AppWeb.UserSocket do
  use Phoenix.Socket

  channel "comment:*", AppWeb.CommentChannel

  # Pattern match token that sent from client (window.userToken at root.html.heex)
  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, "key", token) do
      {:ok, user_id} ->
        # Assign are key-value pairs that hold the state of the view.
        # This state is automatically kept up-to-date as the user interacts with the page
        # without needing to send full-page reloads
        {:ok, assign(socket, :user_id, user_id)}

      {:error, :invalid} ->
        {:ok, socket}
    end
  end

  @impl true
  def id(_socket), do: nil
end
