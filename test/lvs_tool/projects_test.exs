defmodule LvsTool.ProjectsTest do
  use LvsTool.DataCase

  alias LvsTool.Projects

  describe "project_entries" do
    alias LvsTool.Projects.ProjectEntry

    import LvsTool.ProjectsFixtures
    import LvsTool.SemesterentrysFixtures

    @invalid_attrs %{name: nil, kind: nil, sws: nil, student_count: nil, percent: nil, lvs: nil}

    test "list_project_entries/0 returns all project_entries" do
      project_entry = project_entry_fixture()
      assert Projects.list_project_entries() == [project_entry]
    end

    test "get_project_entry!/1 returns the project_entry with given id" do
      project_entry = project_entry_fixture()
      assert Projects.get_project_entry!(project_entry.id) == project_entry
    end

    test "create_project_entry/1 with valid data creates a project_entry" do
      semesterentry = semesterentry_fixture()

      valid_attrs = %{
        name: "some name",
        kind: "some kind",
        sws: 120.5,
        student_count: 42,
        percent: 120.5,
        lvs: 120.5,
        semesterentry_id: semesterentry.id
      }

      assert {:ok, %ProjectEntry{} = project_entry} = Projects.create_project_entry(valid_attrs)
      assert project_entry.name == "some name"
      assert project_entry.kind == "some kind"
      assert project_entry.sws == 120.5
      assert project_entry.student_count == 42
      assert project_entry.percent == 120.5
      assert project_entry.lvs == 120.5
    end

    test "create_project_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project_entry(@invalid_attrs)
    end

    test "update_project_entry/2 with valid data updates the project_entry" do
      project_entry = project_entry_fixture()

      update_attrs = %{
        kind: "some updated kind",
        sws: 456.7,
        student_count: 43,
        percent: 456.7,
        lvs: 456.7
      }

      assert {:ok, %ProjectEntry{} = project_entry} =
               Projects.update_project_entry(project_entry, update_attrs)

      assert project_entry.kind == "some updated kind"
      assert project_entry.sws == 456.7
      assert project_entry.student_count == 43
      assert project_entry.percent == 456.7
      assert project_entry.lvs == 456.7
    end

    test "update_project_entry/2 with invalid data returns error changeset" do
      project_entry = project_entry_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Projects.update_project_entry(project_entry, @invalid_attrs)

      assert project_entry == Projects.get_project_entry!(project_entry.id)
    end

    test "delete_project_entry/1 deletes the project_entry" do
      project_entry = project_entry_fixture()
      assert {:ok, %ProjectEntry{}} = Projects.delete_project_entry(project_entry)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project_entry!(project_entry.id) end
    end

    test "change_project_entry/1 returns a project_entry changeset" do
      project_entry = project_entry_fixture()
      assert %Ecto.Changeset{} = Projects.change_project_entry(project_entry)
    end
  end
end
