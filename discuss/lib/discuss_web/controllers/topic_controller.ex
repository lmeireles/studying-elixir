defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Posts
  alias Discuss.Posts.Topic

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    topics = Discuss.Posts.list_topics()
    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Posts.change_topic(%Topic{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    user = conn.assigns.user
    case Posts.create_topic(topic_params, user) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic created!")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Posts.get_topic!(topic_id)
    changeset = Posts.change_topic(topic)

    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, %{"id" => topic_id, "topic" => topic_params}) do
    topic = Posts.get_topic!(topic_id)
    case Posts.update_topic(topic, topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic updated!")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, topic: topic)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    topic = Posts.get_topic!(topic_id)

    {:ok, _page} = Posts.delete_topic(topic)

    conn
    |> put_flash(:info, "Topic deleted!")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  defp check_topic_owner(%{params: %{"id" => topic_id}} = conn, _params) do
    if Discuss.Posts.get_topic!(topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit that.")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end