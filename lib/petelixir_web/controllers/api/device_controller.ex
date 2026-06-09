defmodule PetelixirWeb.API.DeviceController do
  use PetelixirWeb, :controller
  alias Petelixir.Devices

  def index(conn, _params) do
    devices = Devices.list_devices()
    json(conn, %{data: Enum.map(devices, &map_device/1)})
  end

  defp map_device(device) do
    %{
      id: device.id,
      name: device.name,
      status: device.status,
      last_seen: device.last_seen
    }
  end
end