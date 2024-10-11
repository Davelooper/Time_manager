defmodule TimeManager.ScheduleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Schedule` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-07 07:44:00]
      })
      |> TimeManager.Schedule.create_clock()

    clock
  end

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~N[2024-10-07 08:27:00],
        start: ~N[2024-10-07 08:27:00]
      })
      |> TimeManager.Schedule.create_working_time()

    working_time
  end

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-07 08:28:00]
      })
      |> TimeManager.Schedule.create_clock()

    clock
  end
end
