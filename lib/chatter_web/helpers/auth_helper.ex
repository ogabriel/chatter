defmodule ChatterWeb.AuthHelpers do
  alias Chatter.Accounts

  def signed_in?(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    if user_id, do: !!Accounts.get_user!(user_id)
  end

  def username(conn) do
    Plug.Conn.get_session(conn, :current_username) || "user"
  end
end
