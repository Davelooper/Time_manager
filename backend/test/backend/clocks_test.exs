defmodule Backend.ClocksTest do
  use Backend.DataCase

  alias Backend.Clocks

  describe "clocks" do
    alias Backend.Clocks.Clock

    import Backend.ClocksFixtures

    @invalid_attrs %{time: nil}

    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Clocks.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert Clocks.get_clock!(clock.id) == clock
    end

    test "create_clock/1 with valid data creates a clock" do
      valid_attrs = %{time: ~U[2024-10-15 08:56:00Z]}

      assert {:ok, %Clock{} = clock} = Clocks.create_clock(valid_attrs)
      assert clock.time == ~U[2024-10-15 08:56:00Z]
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clocks.create_clock(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      update_attrs = %{time: ~U[2024-10-16 08:56:00Z]}

      assert {:ok, %Clock{} = clock} = Clocks.update_clock(clock, update_attrs)
      assert clock.time == ~U[2024-10-16 08:56:00Z]
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Clocks.update_clock(clock, @invalid_attrs)
      assert clock == Clocks.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Clocks.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Clocks.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Clocks.change_clock(clock)
    end
  end
end
