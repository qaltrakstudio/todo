defmodule Todo.AdminsTest do
  use Todo.DataCase

  alias Todo.Admins

  import Todo.AdminsFixtures

  describe "admins" do
    alias Todo.Admins.Admin

    @valid_attrs %{email: "some email", first_name: "some first_name", last_name: "some last_name", type: :platform, user_id: "some user_id"}
    @update_attrs %{email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", type: :service, user_id: "some updated user_id"}
    @invalid_attrs %{email: nil, first_name: nil, last_name: nil, type: nil, user_id: nil}

    test "paginate_admins/1 returns paginated list of admins" do
      for _ <- 1..20 do
        admin_fixture()
      end

      {:ok, %{admins: admins} = page} = Admins.paginate_admins(%{})

      assert length(admins) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_admins/0 returns all admins" do
      admin = admin_fixture()
      assert Admins.list_admins() == [admin]
    end

    test "get_admin!/1 returns the admin with given id" do
      admin = admin_fixture()
      assert Admins.get_admin!(admin.id) == admin
    end

    test "create_admin/1 with valid data creates a admin" do
      assert {:ok, %Admin{} = admin} = Admins.create_admin(@valid_attrs)
      assert admin.email == "some email"
      assert admin.first_name == "some first_name"
      assert admin.last_name == "some last_name"
      assert admin.type == :platform
      assert admin.user_id == "some user_id"
    end

    test "create_admin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admins.create_admin(@invalid_attrs)
    end

    test "update_admin/2 with valid data updates the admin" do
      admin = admin_fixture()
      assert {:ok, %Admin{} = admin} = Admins.update_admin(admin, @update_attrs)
      assert admin.email == "some updated email"
      assert admin.first_name == "some updated first_name"
      assert admin.last_name == "some updated last_name"
      assert admin.type == :service
      assert admin.user_id == "some updated user_id"
    end

    test "update_admin/2 with invalid data returns error changeset" do
      admin = admin_fixture()
      assert {:error, %Ecto.Changeset{}} = Admins.update_admin(admin, @invalid_attrs)
      assert admin == Admins.get_admin!(admin.id)
    end

    test "delete_admin/1 deletes the admin" do
      admin = admin_fixture()
      assert {:ok, %Admin{}} = Admins.delete_admin(admin)
      assert_raise Ecto.NoResultsError, fn -> Admins.get_admin!(admin.id) end
    end

    test "change_admin/1 returns a admin changeset" do
      admin = admin_fixture()
      assert %Ecto.Changeset{} = Admins.change_admin(admin)
    end
  end
end
