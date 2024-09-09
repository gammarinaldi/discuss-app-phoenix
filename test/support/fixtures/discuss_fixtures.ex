defmodule App.DiscussFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.Discuss` context.
  """

  @doc """
  Generate a topic.
  """
  def topic_fixture(attrs \\ %{}) do
    {:ok, topic} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> App.Discuss.create_topic()

    topic
  end
end
