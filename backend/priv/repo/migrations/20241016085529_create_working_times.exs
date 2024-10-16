defmodule Backend.Repo.Migrations.CreateWorkingTimes do
  use Ecto.Migration

  def change do
    create table(:working_times, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :start, :utc_datetime
      add :end, :utc_datetime
      add :team_id, references(:teams, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:working_times, [:team_id])
  end
end
