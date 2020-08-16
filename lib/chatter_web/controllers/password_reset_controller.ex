defmodule ChatterWeb.PasswordResetController do
  use ChatterWeb, :controller

  alias Chatter.{Accounts, Email, Mailer}

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
        user
        |> Accounts.set_token_on_user()
        |> Email.password_reset()
        |> Mailer.deliver_later()

        conn
        |> put_flash(:info, "Password reset e-mail was sent")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def edit(conn, %{"id" => token}) do
    if user = Accounts.get_user_by_token(token) do
      changeset = Accounts.change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    else
      render(conn, "invalid_token.html")
    end
  end

  def update(conn, %{"id" => token, "user" => params}) do
    user = Accounts.get_user_by_token(token)

    with true <- Accounts.valid_token?(user),
         params <-
           Map.merge(params, %{"password_reset_token" => nil, "password_reset_sent_at" => nil}),
         {:ok, _user} <- Accounts.update_user(user, params) do
      conn
      |> put_flash(:info, "Password reseted")
      |> redirect(to: Routes.session_path(conn, :new))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Invalid password")
        |> render("edit.html", user: user, changeset: changeset)

      false ->
        conn
        |> put_flash(:error, "Invalid token")
        |> redirect(to: Routes.password_reset_path(conn, :new))
    end
  end
end
