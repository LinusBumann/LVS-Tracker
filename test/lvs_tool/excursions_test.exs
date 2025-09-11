defmodule LvsTool.ExcursionsTest do
  use LvsTool.DataCase

  alias LvsTool.Excursions

  describe "excursion_entries" do
    alias LvsTool.Excursions.ExcursionEntry

    import LvsTool.ExcursionsFixtures

    @invalid_attrs %{
      name: nil,
      lvs: nil,
      student_count: nil,
      daily_max_teaching_units: nil,
      imputationfactor: nil
    }

    test "list_excursion_entries/0 returns all excursion_entries" do
      excursion_entry = excursion_entry_fixture()
      assert Excursions.list_excursion_entries() == [excursion_entry]
    end

    test "get_excursion_entry!/1 returns the excursion_entry with given id" do
      excursion_entry = excursion_entry_fixture()
      assert Excursions.get_excursion_entry!(excursion_entry.id) == excursion_entry
    end

    test "create_excursion_entry/1 with valid data creates a excursion_entry" do
      valid_attrs = %{
        name: "some name",
        lvs: 120.5,
        student_count: 120.5,
        daily_max_teaching_units: 120.5,
        imputationfactor: 120.5
      }

      assert {:ok, %ExcursionEntry{} = excursion_entry} =
               Excursions.create_excursion_entry(valid_attrs)

      assert excursion_entry.name == "some name"
      assert excursion_entry.lvs == 120.5
      assert excursion_entry.student_count == 120.5
      assert excursion_entry.daily_max_teaching_units == 120.5
      assert excursion_entry.imputationfactor == 120.5
    end

    test "create_excursion_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Excursions.create_excursion_entry(@invalid_attrs)
    end

    test "update_excursion_entry/2 with valid data updates the excursion_entry" do
      excursion_entry = excursion_entry_fixture()

      update_attrs = %{
        name: "some updated name",
        lvs: 456.7,
        student_count: 456.7,
        daily_max_teaching_units: 456.7,
        imputationfactor: 456.7
      }

      assert {:ok, %ExcursionEntry{} = excursion_entry} =
               Excursions.update_excursion_entry(excursion_entry, update_attrs)

      assert excursion_entry.name == "some updated name"
      assert excursion_entry.lvs == 456.7
      assert excursion_entry.student_count == 456.7
      assert excursion_entry.daily_max_teaching_units == 456.7
      assert excursion_entry.imputationfactor == 456.7
    end

    test "update_excursion_entry/2 with invalid data returns error changeset" do
      excursion_entry = excursion_entry_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Excursions.update_excursion_entry(excursion_entry, @invalid_attrs)

      assert excursion_entry == Excursions.get_excursion_entry!(excursion_entry.id)
    end

    test "delete_excursion_entry/1 deletes the excursion_entry" do
      excursion_entry = excursion_entry_fixture()
      assert {:ok, %ExcursionEntry{}} = Excursions.delete_excursion_entry(excursion_entry)

      assert_raise Ecto.NoResultsError, fn ->
        Excursions.get_excursion_entry!(excursion_entry.id)
      end
    end

    test "change_excursion_entry/1 returns a excursion_entry changeset" do
      excursion_entry = excursion_entry_fixture()
      assert %Ecto.Changeset{} = Excursions.change_excursion_entry(excursion_entry)
    end
  end
end
