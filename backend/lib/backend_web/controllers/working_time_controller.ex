defmodule BackendWeb.WorkingTimeController do
  use BackendWeb, :controller

  alias Backend.WorkingTimes
  alias Backend.WorkingTimes.WorkingTime

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    working_times = WorkingTimes.list_working_times()
    render(conn, :index, working_times: working_times)
  end

  def create(conn, %{"working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/working_times/#{working_time}")
      |> render(:show, working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)
    render(conn, :show, working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- WorkingTimes.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_all_by_user_id(conn, %{"userId" => userId} = params) do
    start_date = Map.get(params, "start")
    end_date = Map.get(params, "end")


    # with {:ok, startdate} <- Date.from_iso8601(start_date),
    #      {:ok, enddate} <- Date.from_iso8601(end_date) do
    workingtimes = Schedule.list_workingtimes_by_user_id(userId, start_date, end_date)
    render(conn, :index, workingtimes: workingtimes)
    # else
    #   :error ->
    #     conn
    #     |> put_status(:bad_request)
    #     |> json(%{error: "Invalid date format. Expected ISO8601 format (YYYY-MM-DD)."})
    # end
  end

  def get_one_by_user_id(conn, %{"userId" => userId, "id" => id}) do
    working_time = Schedule.get_working_time_by_user_id_and_id(userId, id)
    render(conn, :show, working_time: working_time)
  end
end
