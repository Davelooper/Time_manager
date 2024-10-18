defmodule Backend.WorkingTimes do
  @moduledoc """
  The WorkingTimes context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.WorkingTimes.WorkingTime


  @doc """
  Returns the list of working_times.

  ## Examples

      iex> list_working_times()
      [%WorkingTime{}, ...]

  """
  def list_working_times do
    Repo.all(WorkingTime)
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end


  def list_workingtimes_by_team_id(team_id, start_date, end_date) do
    query =
      from(w in WorkingTime,
        where: w.team_id == ^team_id,
        where: ^is_nil(start_date) or w.start >= ^start_date,
        where: ^is_nil(end_date) or w.end <= ^end_date,
        order_by: [asc: w.start]
      )

    Repo.all(query)
  end


  def get_working_time_by_team_id_and_id(team_id, id) do
    case Repo.one(from w in WorkingTime, where: w.team_id == ^team_id, where: w.id == ^id) do
      nil -> {:error, :not_found}
      working_time -> {:ok, working_time}
    end
  end

  # def get_working_time_by_user_id_and_id(user_id, id) do
  #   from(w in WorkingTime, where: w.user_id == ^user_id, where: w.id == ^id)
  #   |> Repo.one()
  # end

end
