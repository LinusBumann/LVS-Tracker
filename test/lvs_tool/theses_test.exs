defmodule LvsTool.ThesesTest do
  use LvsTool.DataCase

  alias LvsTool.Theses

  describe "thesis_types" do
    alias LvsTool.Theses.ThesisType

    import LvsTool.ThesesFixtures

    @invalid_attrs %{name: nil, imputationfactor: nil}

    test "list_thesis_types/0 returns all thesis_types" do
      thesis_type = thesis_type_fixture()
      assert Theses.list_thesis_types() == [thesis_type]
    end

    test "get_thesis_type!/1 returns the thesis_type with given id" do
      thesis_type = thesis_type_fixture()
      assert Theses.get_thesis_type!(thesis_type.id) == thesis_type
    end

    test "create_thesis_type/1 with valid data creates a thesis_type" do
      valid_attrs = %{name: "some name", imputationfactor: 120.5}

      assert {:ok, %ThesisType{} = thesis_type} = Theses.create_thesis_type(valid_attrs)
      assert thesis_type.name == "some name"
      assert thesis_type.imputationfactor == 120.5
    end

    test "create_thesis_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Theses.create_thesis_type(@invalid_attrs)
    end

    test "update_thesis_type/2 with valid data updates the thesis_type" do
      thesis_type = thesis_type_fixture()
      update_attrs = %{name: "some updated name", imputationfactor: 456.7}

      assert {:ok, %ThesisType{} = thesis_type} = Theses.update_thesis_type(thesis_type, update_attrs)
      assert thesis_type.name == "some updated name"
      assert thesis_type.imputationfactor == 456.7
    end

    test "update_thesis_type/2 with invalid data returns error changeset" do
      thesis_type = thesis_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Theses.update_thesis_type(thesis_type, @invalid_attrs)
      assert thesis_type == Theses.get_thesis_type!(thesis_type.id)
    end

    test "delete_thesis_type/1 deletes the thesis_type" do
      thesis_type = thesis_type_fixture()
      assert {:ok, %ThesisType{}} = Theses.delete_thesis_type(thesis_type)
      assert_raise Ecto.NoResultsError, fn -> Theses.get_thesis_type!(thesis_type.id) end
    end

    test "change_thesis_type/1 returns a thesis_type changeset" do
      thesis_type = thesis_type_fixture()
      assert %Ecto.Changeset{} = Theses.change_thesis_type(thesis_type)
    end
  end

  describe "theses_entries" do
    alias LvsTool.Theses.ThesisEntry

    import LvsTool.ThesesFixtures

    @invalid_attrs %{type: nil, studygroup: nil, percent: nil}

    test "list_theses_entries/0 returns all theses_entries" do
      thesis_entry = thesis_entry_fixture()
      assert Theses.list_theses_entries() == [thesis_entry]
    end

    test "get_thesis_entry!/1 returns the thesis_entry with given id" do
      thesis_entry = thesis_entry_fixture()
      assert Theses.get_thesis_entry!(thesis_entry.id) == thesis_entry
    end

    test "create_thesis_entry/1 with valid data creates a thesis_entry" do
      valid_attrs = %{type: "some type", studygroup: "some studygroup", percent: 120.5}

      assert {:ok, %ThesisEntry{} = thesis_entry} = Theses.create_thesis_entry(valid_attrs)
      assert thesis_entry.type == "some type"
      assert thesis_entry.studygroup == "some studygroup"
      assert thesis_entry.percent == 120.5
    end

    test "create_thesis_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Theses.create_thesis_entry(@invalid_attrs)
    end

    test "update_thesis_entry/2 with valid data updates the thesis_entry" do
      thesis_entry = thesis_entry_fixture()
      update_attrs = %{type: "some updated type", studygroup: "some updated studygroup", percent: 456.7}

      assert {:ok, %ThesisEntry{} = thesis_entry} = Theses.update_thesis_entry(thesis_entry, update_attrs)
      assert thesis_entry.type == "some updated type"
      assert thesis_entry.studygroup == "some updated studygroup"
      assert thesis_entry.percent == 456.7
    end

    test "update_thesis_entry/2 with invalid data returns error changeset" do
      thesis_entry = thesis_entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Theses.update_thesis_entry(thesis_entry, @invalid_attrs)
      assert thesis_entry == Theses.get_thesis_entry!(thesis_entry.id)
    end

    test "delete_thesis_entry/1 deletes the thesis_entry" do
      thesis_entry = thesis_entry_fixture()
      assert {:ok, %ThesisEntry{}} = Theses.delete_thesis_entry(thesis_entry)
      assert_raise Ecto.NoResultsError, fn -> Theses.get_thesis_entry!(thesis_entry.id) end
    end

    test "change_thesis_entry/1 returns a thesis_entry changeset" do
      thesis_entry = thesis_entry_fixture()
      assert %Ecto.Changeset{} = Theses.change_thesis_entry(thesis_entry)
    end
  end
end
