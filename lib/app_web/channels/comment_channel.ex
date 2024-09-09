defmodule AppWeb.CommentChannel do
  use AppWeb, :channel

  alias App.Discuss

  # Server of join()
  @impl true
  def join("comment:" <> topic_id, payload, socket) do
    if authorized?(payload) do
      topic =
        topic_id
        |> String.to_integer()
        |> Discuss.get_topic_comments()

      # The comments value will be passed to join() client in user_socket.js
      {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in(_event, %{"content" => content}, socket) do
    case Discuss.insert_new_comment(content, socket) do
      {:ok, comment} ->
        broadcast!(
          socket,
          "comment:#{socket.assigns.topic.id}:new",
          %{comment: comment}
        )

        {:reply, :ok, socket}

      {:error, reason} ->
        {:reply, {:error, %{reason: reason}}, socket}
    end

    {:reply, :ok, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
