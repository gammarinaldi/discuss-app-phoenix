defmodule AppWeb.TopicHTML do
  use AppWeb, :html

  embed_templates "topic_html/*"

  @doc """
  Renders a topic form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def topic_form(assigns)
end
