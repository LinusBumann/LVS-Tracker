defmodule LvsTool.ReductionsTest do
  use LvsTool.DataCase

  alias LvsTool.Reductions

  describe "reduction_types" do
    alias LvsTool.Reductions.Reduction

    import LvsTool.ReductionsFixtures

    @invalid_attrs %{reduction_reason: nil, reduction_lvs: nil}

    test "list_reduction_types/0 returns all reduction_types" do
      reduction = reduction_fixture()
      assert Reductions.list_reduction_types() == [reduction]
    end

    test "get_reduction!/1 returns the reduction with given id" do
      reduction = reduction_fixture()
      assert Reductions.get_reduction!(reduction.id) == reduction
    end

    test "create_reduction/1 with valid data creates a reduction" do
      valid_attrs = %{reduction_reason: "some reduction_reason", reduction_lvs: 120.5}

      assert {:ok, %Reduction{} = reduction} = Reductions.create_reduction(valid_attrs)
      assert reduction.reduction_reason == "some reduction_reason"
      assert reduction.reduction_lvs == 120.5
    end

    test "create_reduction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reductions.create_reduction(@invalid_attrs)
    end

    test "update_reduction/2 with valid data updates the reduction" do
      reduction = reduction_fixture()
      update_attrs = %{reduction_reason: "some updated reduction_reason", reduction_lvs: 456.7}

      assert {:ok, %Reduction{} = reduction} = Reductions.update_reduction(reduction, update_attrs)
      assert reduction.reduction_reason == "some updated reduction_reason"
      assert reduction.reduction_lvs == 456.7
    end

    test "update_reduction/2 with invalid data returns error changeset" do
      reduction = reduction_fixture()
      assert {:error, %Ecto.Changeset{}} = Reductions.update_reduction(reduction, @invalid_attrs)
      assert reduction == Reductions.get_reduction!(reduction.id)
    end

    test "delete_reduction/1 deletes the reduction" do
      reduction = reduction_fixture()
      assert {:ok, %Reduction{}} = Reductions.delete_reduction(reduction)
      assert_raise Ecto.NoResultsError, fn -> Reductions.get_reduction!(reduction.id) end
    end

    test "change_reduction/1 returns a reduction changeset" do
      reduction = reduction_fixture()
      assert %Ecto.Changeset{} = Reductions.change_reduction(reduction)
    end
  end
end
