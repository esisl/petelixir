defmodule Petelixir.Devices.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "devices" do
    field :name, :string
    field :status, :string
    field :device_type, :string
    field :last_seen, :utc_datetime
    field :firmware_version, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:name, :device_type, :status, :last_seen, :firmware_version])
    |> validate_required([:name, :device_type, :status, :last_seen, :firmware_version])
  end
end
