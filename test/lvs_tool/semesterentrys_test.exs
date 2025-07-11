defmodule LvsTool.SemesterentrysTest do
  use LvsTool.DataCase

  alias LvsTool.Semesterentrys

  describe "semesterentrys" do
    alias LvsTool.Semesterentrys.Semesterentry

    import LvsTool.SemesterentrysFixtures

    @invalid_attrs %{name: nil, status: nil}

    test "list_semesterentrys/0 returns all semesterentrys" do
      semesterentry = semesterentry_fixture()
      assert Semesterentrys.list_semesterentrys() == [semesterentry]
    end

    test "get_semesterentry!/1 returns the semesterentry with given id" do
      semesterentry = semesterentry_fixture()
      assert Semesterentrys.get_semesterentry!(semesterentry.id) == semesterentry
    end

    test "create_semesterentry/1 with valid data creates a semesterentry" do
      valid_attrs = %{name: "some name", status: "some status"}

      assert {:ok, %Semesterentry{} = semesterentry} = Semesterentrys.create_semesterentry(valid_attrs)
      assert semesterentry.name == "some name"
      assert semesterentry.status == "some status"
    end

    test "create_semesterentry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Semesterentrys.create_semesterentry(@invalid_attrs)
    end

    test "update_semesterentry/2 with valid data updates the semesterentry" do
      semesterentry = semesterentry_fixture()
      update_attrs = %{name: "some updated name", status: "some updated status"}

      assert {:ok, %Semesterentry{} = semesterentry} = Semesterentrys.update_semesterentry(semesterentry, update_attrs)
      assert semesterentry.name == "some updated name"
      assert semesterentry.status == "some updated status"
    end

    test "update_semesterentry/2 with invalid data returns error changeset" do
      semesterentry = semesterentry_fixture()
      assert {:error, %Ecto.Changeset{}} = Semesterentrys.update_semesterentry(semesterentry, @invalid_attrs)
      assert semesterentry == Semesterentrys.get_semesterentry!(semesterentry.id)
    end

    test "delete_semesterentry/1 deletes the semesterentry" do
      semesterentry = semesterentry_fixture()
      assert {:ok, %Semesterentry{}} = Semesterentrys.delete_semesterentry(semesterentry)
      assert_raise Ecto.NoResultsError, fn -> Semesterentrys.get_semesterentry!(semesterentry.id) end
    end

    test "change_semesterentry/1 returns a semesterentry changeset" do
      semesterentry = semesterentry_fixture()
      assert %Ecto.Changeset{} = Semesterentrys.change_semesterentry(semesterentry)
    end
  end
end
