defmodule PetelixirWeb.TelemetryController do
  use PetelixirWeb, :controller

  alias Petelixir.Devices

  # Этот эндпоинт будет вызывать мобильное приложение
  def update(conn, %{"id" => id} = params) do
    case Devices.get_device(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Device not found"})

      device ->
        # Обновляем last_seen в PostgreSQL (реляционная БД)
        {:ok, updated_device} = Devices.update_device(device, %{
          last_seen: DateTime.utc_now(),
          status: "online"
        })

        # Сохраняем телеметрию в Redis (NoSQL)
        telemetry_data = %{
          "temperature" => params["temperature"],
          "battery" => params["battery"],
          "timestamp" => DateTime.utc_now() |> DateTime.to_iso8601()
        }
      
        Petelixir.Redis.set_last_telemetry(id, telemetry_data)
      
        IO.inspect(telemetry_data, label: "Saved to Redis for device #{id}")

        conn
        |> put_status(:ok)
        |> json(%{
          status: "success",
          device_id: updated_device.id,
          last_seen: updated_device.last_seen
        })
    end
  end
end