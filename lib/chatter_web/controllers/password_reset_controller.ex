defmodule ChatterWeb.PasswordResetController do
  use ChatterWeb, :controller

  alias Chatter.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"password_reset" => password_reset_params}) do
    case Accounts.get_user_by_email(password_reset_params["email"]) do
      nil ->
        conn
        |> put_flash(:error, "No email exists!")
        |> redirect(to: Routes.password_reset_path(conn, :new))

      user ->
        conn
        |> put_flash(:info, "Password reset e-mail was sent")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end
end
