defmodule BackendWeb.ClockController do
  use BackendWeb, :controller

  alias Backend.Clocks
  alias Backend.Clocks.Clock

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    clocks = Clocks.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"userId" => id, "clock" => clock_params}) do
    IO.inspect(clock_params)
    user_id = String.to_integer(id)
    clock_params = Map.put(clock_params, "user_id", user_id)
    IO.inspect(clock_params)
    with {:ok, %Clock{} = clock} <- Schedule.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock}")
      |> render(:show, clock: clock)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)
    render(conn, :show, clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Clocks.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)

    with {:ok, %Clock{}} <- Clocks.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_by_user_id(conn, %{"userId" => userId}) do
    clocks = Schedule.get_clock_by_user_id(userId)
    if clocks == [] do
      conn
      |> put_status(:not_found)
      |> json(%{message: "No clocks found for user with ID #{userId}"})
    else
      render(conn, "index.json", clocks: clocks)
    end
  end
end
