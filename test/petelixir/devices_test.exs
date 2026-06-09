defmodule Petelixir.DevicesTest do
  use Petelixir.DataCase

  alias Petelixir.Devices

  describe "devices" do
    alias Petelixir.Devices.Device

    import Petelixir.DevicesFixtures

    @invalid_attrs %{name: nil, status: nil, device_type: nil, last_seen: nil, firmware_version: nil}

    test "list_devices/0 returns all devices" do
      device = device_fixture()
      assert Devices.list_devices() == [device]
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert Devices.get_device!(device.id) == device
    end

    test "create_device/1 with valid data creates a device" do
      valid_attrs = %{name: "some name", status: "some status", device_type: "some device_type", last_seen: ~U[2026-06-08 07:40:00Z], firmware_version: "some firmware_version"}

      assert {:ok, %Device{} = device} = Devices.create_device(valid_attrs)
      assert device.name == "some name"
      assert device.status == "some status"
      assert device.device_type == "some device_type"
      assert device.last_seen == ~U[2026-06-08 07:40:00Z]
      assert device.firmware_version == "some firmware_version"
    end

    test "create_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Devices.create_device(@invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      update_attrs = %{name: "some updated name", status: "some updated status", device_type: "some updated device_type", last_seen: ~U[2026-06-09 07:40:00Z], firmware_version: "some updated firmware_version"}

      assert {:ok, %Device{} = device} = Devices.update_device(device, update_attrs)
      assert device.name == "some updated name"
      assert device.status == "some updated status"
      assert device.device_type == "some updated device_type"
      assert device.last_seen == ~U[2026-06-09 07:40:00Z]
      assert device.firmware_version == "some updated firmware_version"
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = Devices.update_device(device, @invalid_attrs)
      assert device == Devices.get_device!(device.id)
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = Devices.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> Devices.get_device!(device.id) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = Devices.change_device(device)
    end
  end
end
