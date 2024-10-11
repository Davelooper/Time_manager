defmodule TimeManager.ScheduleTest do
  use TimeManager.DataCase

  alias TimeManager.Schedule

  describe "clocks" do
    alias TimeManager.Schedule.Clock

    import TimeManager.ScheduleFixtures

    @invalid_attrs %{status: nil, time: nil}

    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Schedule.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert Schedule.get_clock!(clock.id) == clock
    end

    test "create_clock/1 with valid data creates a clock" do
      valid_attrs = %{status: true, time: ~N[2024-10-07 07:44:00]}

      assert {:ok, %Clock{} = clock} = Schedule.create_clock(valid_attrs)
      assert clock.status == true
      assert clock.time == ~N[2024-10-07 07:44:00]
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedule.create_clock(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      update_attrs = %{status: false, time: ~N[2024-10-08 07:44:00]}

      assert {:ok, %Clock{} = clock} = Schedule.update_clock(clock, update_attrs)
      assert clock.status == false
      assert clock.time == ~N[2024-10-08 07:44:00]
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Schedule.update_clock(clock, @invalid_attrs)
      assert clock == Schedule.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Schedule.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Schedule.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Schedule.change_clock(clock)
    end
  end

  describe "workingtimes" do
    alias TimeManager.Schedule.WorkingTime

    import TimeManager.ScheduleFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_workingtimes/0 returns all workingtimes" do
      working_time = working_time_fixture()
      assert Schedule.list_workingtimes() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Schedule.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{start: ~N[2024-10-07 08:27:00], end: ~N[2024-10-07 08:27:00]}

      assert {:ok, %WorkingTime{} = working_time} = Schedule.create_working_time(valid_attrs)
      assert working_time.start == ~N[2024-10-07 08:27:00]
      assert working_time.end == ~N[2024-10-07 08:27:00]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedule.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{start: ~N[2024-10-08 08:27:00], end: ~N[2024-10-08 08:27:00]}

      assert {:ok, %WorkingTime{} = working_time} = Schedule.update_working_time(working_time, update_attrs)
      assert working_time.start == ~N[2024-10-08 08:27:00]
      assert working_time.end == ~N[2024-10-08 08:27:00]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Schedule.update_working_time(working_time, @invalid_attrs)
      assert working_time == Schedule.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Schedule.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Schedule.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Schedule.change_working_time(working_time)
    end
  end

  describe "clocks" do
    alias TimeManager.Schedule.Clock

    import TimeManager.ScheduleFixtures

    @invalid_attrs %{status: nil, time: nil}

    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Schedule.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert Schedule.get_clock!(clock.id) == clock
    end

    test "create_clock/1 with valid data creates a clock" do
      valid_attrs = %{status: true, time: ~N[2024-10-07 08:28:00]}

      assert {:ok, %Clock{} = clock} = Schedule.create_clock(valid_attrs)
      assert clock.status == true
      assert clock.time == ~N[2024-10-07 08:28:00]
    end

    test "create_clock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedule.create_clock(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      update_attrs = %{status: false, time: ~N[2024-10-08 08:28:00]}

      assert {:ok, %Clock{} = clock} = Schedule.update_clock(clock, update_attrs)
      assert clock.status == false
      assert clock.time == ~N[2024-10-08 08:28:00]
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Schedule.update_clock(clock, @invalid_attrs)
      assert clock == Schedule.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Schedule.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Schedule.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Schedule.change_clock(clock)
    end
  end
end
