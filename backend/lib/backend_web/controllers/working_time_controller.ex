defmodule BackendWeb.WorkingTimeController do
  use BackendWeb, :controller

  alias Backend.WorkingTimes
  alias Backend.WorkingTimes.WorkingTime

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    working_times = WorkingTimes.list_working_times()
    render(conn, :index, working_times: working_times)
  end

  # def create(conn, %{"working_time" => working_time_params}) do
  #   with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.create_working_time(working_time_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", ~p"/api/working_times/#{working_time}")
  #     |> render(:show, working_time: working_time)
  #   end
  # end

  def create(conn, %{"teamId" => id, "working_time" => working_time_params}) do
    # team_id = String.to_integer(id)
    working_time_params = Map.put(working_time_params, "team_id", id)
    IO.inspect(working_time_params)

    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{working_time}")
      |> render(:show, working_time: working_time)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset.errors})
    end
  end

  # def show(conn, %{"id" => id}) do
  #   working_time = WorkingTimes.get_working_time!(id)
  #   render(conn, :show, working_time: working_time)
  # end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = WorkingTimes.get_working_time!(id)
    IO.inspect(working_time)

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


  def get_all_by_team_id(conn, %{"teamId" => teamId} = params) do
    start_date = Map.get(params, "start")
    end_date = Map.get(params, "end")
    IO.inspect(start_date)
    IO.inspect(end_date)
    IO.inspect(teamId)

    # with {:ok, startdate} <- Date.from_iso8601(start_date),
    #      {:ok, enddate} <- Date.from_iso8601(end_date) do
    workingtimes = WorkingTimes.list_workingtimes_by_team_id(teamId, start_date, end_date)
    IO.inspect(workingtimes)
    render(conn, :index, workingtimes: workingtimes)
    # else
    #   :error ->
    #     conn
    #     |> put_status(:bad_request)
    #     |> json(%{error: "Invalid date format. Expected ISO8601 format (YYYY-MM-DD)."})
    # end
  end


  def get_one_by_user_id(conn, %{"teamId" => teamId, "id" => id}) do
    working_time = WorkingTimes.get_working_time_by_team_id_and_id(teamId, id)
    render(conn, :show, working_time: working_time)
  end


end
