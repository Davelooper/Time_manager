defmodule TimeManagerWeb.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias TimeManager.Repo

  alias TimeManager.Clocks

  @doc """
  Returns the list of Clocks.

  ## Examples

      iex> list_Clocks()
      [%Clock{}, ...]

  """
  def list_Clocks do
    Repo.all(Clocks)
  end

  def get_clock_by_id(id) do
    Repo.get(Clocks, id)
  end
end
