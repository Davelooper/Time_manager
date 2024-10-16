defmodule Backend.ClocksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.Clocks` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        time: ~U[2024-10-15 08:56:00Z]
      })
      |> Backend.Clocks.create_clock()

    clock
  end
end
