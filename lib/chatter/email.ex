defmodule Chatter.Email do
  use Bamboo.Phoenix, view: ChatterWeb.EmailView

  def base_email do
    new_email
    |> from("email@chatter.com")
  end

  def password_reset(email) do
  end
end
