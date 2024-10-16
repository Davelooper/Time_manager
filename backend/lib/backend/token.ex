defmodule Backend.Token do
  use Joken.Config

  def generate_token(user) do
    Joken.generate_and_sign(%{"sub" => user.id})
  end
end
