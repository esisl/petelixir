defmodule Petelixir.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :name, :string
      add :device_type, :string
      add :status, :string
      add :last_seen, :utc_datetime
      add :firmware_version, :string

      timestamps(type: :utc_datetime)
    end
  end
end
