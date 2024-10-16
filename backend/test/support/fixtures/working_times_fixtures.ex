defmodule Backend.WorkingTimesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Backend.WorkingTimes` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~U[2024-10-15 08:55:00Z],
        start: ~U[2024-10-15 08:55:00Z]
      })
      |> Backend.WorkingTimes.create_working_time()

    working_time
  end
end
