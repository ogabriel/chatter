defmodule Chatter.Email do
  def base_email do
    new_email
    |> from("email@chatter.com")
  end

  def password_reset(email) do
  end
end
