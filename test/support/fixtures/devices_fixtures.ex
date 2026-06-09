defmodule Petelixir.DevicesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Petelixir.Devices` context.
  """

  @doc """
  Generate a device.
  """
  def device_fixture(attrs \\ %{}) do
    {:ok, device} =
      attrs
      |> Enum.into(%{
        device_type: "some device_type",
        firmware_version: "some firmware_version",
        last_seen: ~U[2026-06-08 07:40:00Z],
        name: "some name",
        status: "some status"
      })
      |> Petelixir.Devices.create_device()

    device
  end
end
