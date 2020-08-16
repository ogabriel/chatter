defmodule Chatter.Email do
  use Bamboo.Phoenix, view: ChatterWeb.EmailView

  def base_email do
    new_email
    |> from("email@chatter.com")
    |> put_html_layout({TeacherWeb.LayoutView, "email.html"})
  end

  def password_reset(user) do
    base_email
    |> to(user.email)
    |> subject("Password reset")
    |> assign(:user, user)
    |> render("password_reset.html")
  end
end
