defmodule LvsTool.ReductionsTest do
  use LvsTool.DataCase

  alias LvsTool.Reductions

  describe "reduction_types" do
    alias LvsTool.Reductions.ReductionType

    import LvsTool.ReductionsFixtures

    @invalid_attrs %{reduction_reason: nil, reduction_lvs: nil}

    test "list_reduction_types/0 returns all reduction_types" do
      reduction_type = reduction_type_fixture()
      assert Reductions.list_reduction_types() == [reduction_type]
    end

    test "get_reduction_type!/1 returns the reduction_type with given id" do
      reduction_type = reduction_type_fixture()
      assert Reductions.get_reduction_type!(reduction_type.id) == reduction_type
    end

    test "create_reduction_type/1 with valid data creates a reduction_type" do
      valid_attrs = %{reduction_reason: "some reduction_reason", reduction_lvs: 120.5}

      assert {:ok, %ReductionType{} = reduction_type} =
               Reductions.create_reduction_type(valid_attrs)

      assert reduction_type.reduction_reason == "some reduction_reason"
      assert reduction_type.reduction_lvs == 120.5
    end

    test "create_reduction_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reductions.create_reduction_type(@invalid_attrs)
    end

    test "update_reduction_type/2 with valid data updates the reduction_type" do
      reduction_type = reduction_type_fixture()
      update_attrs = %{reduction_reason: "some updated reduction_reason", reduction_lvs: 456.7}

      assert {:ok, %ReductionType{} = reduction_type} =
               Reductions.update_reduction_type(reduction_type, update_attrs)

      assert reduction_type.reduction_reason == "some updated reduction_reason"
      assert reduction_type.reduction_lvs == 456.7
    end

    test "update_reduction_type/2 with invalid data returns error changeset" do
      reduction_type = reduction_type_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Reductions.update_reduction_type(reduction_type, @invalid_attrs)

      assert reduction_type == Reductions.get_reduction_type!(reduction_type.id)
    end

    test "delete_reduction_type/1 deletes the reduction_type" do
      reduction_type = reduction_type_fixture()
      assert {:ok, %ReductionType{}} = Reductions.delete_reduction_type(reduction_type)

      assert_raise Ecto.NoResultsError, fn ->
        Reductions.get_reduction_type!(reduction_type.id)
      end
    end

    test "change_reduction_type/1 returns a reduction_type changeset" do
      reduction_type = reduction_type_fixture()
      assert %Ecto.Changeset{} = Reductions.change_reduction_type(reduction_type)
    end
  end
end
