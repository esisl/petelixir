defmodule PetelixirWeb.DeviceController do
  use PetelixirWeb, :controller
  alias Petelixir.Devices

  def index(conn, _params) do
    devices = Devices.list_devices()
    json(conn, %{
      data: Enum.map(devices, fn device ->
        %{
          id: device.id,
          name: device.name,
          status: device.status,
          last_seen: device.last_seen,
          device_type: device.device_type,
          firmware_version: device.firmware_version
        }
      end)
    })
  end
end