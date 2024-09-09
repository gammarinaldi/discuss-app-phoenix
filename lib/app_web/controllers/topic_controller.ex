defmodule AppWeb.TopicController do
  use AppWeb, :controller

  alias App.Discuss
  alias App.Discuss.Topic

  # Executed first before controller actions
  plug AppWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :delete]
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, _params) do
    topics = Discuss.list_topics()
    render(conn, :index, topics: topics)
  end

  def new(conn, _params) do
    changeset = Discuss.change_topic(%Topic{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    # Adding user id
    attrs = Map.put(topic_params, "user_id", conn.assigns.user.id)

    case Discuss.create_topic(attrs) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic created successfully.")
        |> redirect(to: ~p"/#{topic}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Discuss.get_topic!(id)
    render(conn, :show, topic: topic)
  end

  def edit(conn, %{"id" => id}) do
    topic = Discuss.get_topic!(id)
    changeset = Discuss.change_topic(topic)
    render(conn, :edit, topic: topic, changeset: changeset)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Discuss.get_topic!(id)

    case Discuss.update_topic(topic, topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic updated successfully.")
        |> redirect(to: ~p"/#{topic}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, topic: topic, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Discuss.get_topic!(id)
    {:ok, _topic} = Discuss.delete_topic(topic)

    conn
    |> put_flash(:info, "Topic deleted successfully.")
    |> redirect(to: ~p"/")
  end

  defp check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn

    topic = Discuss.get_topic!(topic_id)

    if topic.user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You can not edit that")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end
