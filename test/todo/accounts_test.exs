defmodule Todo.AccountsTest do
  use Todo.DataCase

  alias Todo.Accounts

  import Todo.AccountsFixtures

  def setup_account(_) do
    account = account_fixture()
    {:ok, account: account}
  end

  describe "accounts" do
    alias Todo.Accounts.Account

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    test "paginate_accounts/1 returns paginated list of accounts" do
      for _ <- 1..20 do
        account_fixture()
      end

      {:ok, %{accounts: accounts} = page} = Accounts.paginate_accounts(%{})

      assert length(accounts) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.description == "some description"
      assert account.name == "some name"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.description == "some updated description"
      assert account.name == "some updated name"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end

  import Todo.AccountsFixtures

  describe "users" do
    setup [:setup_account]

    alias Todo.Accounts.User

    @valid_attrs %{
      email: "some email",
      first_name: "some first_name",
      last_name: "some last_name",
      type: :editor,
      user_id: "some user_id"
    }
    @update_attrs %{
      email: "some updated email",
      first_name: "some updated first_name",
      last_name: "some updated last_name",
      type: :viewer,
      user_id: "some updated user_id"
    }
    @invalid_attrs %{email: nil, first_name: nil, last_name: nil, type: nil, user_id: nil}

    test "paginate_users/1 returns paginated list of users", %{account: account} do
      for _ <- 1..20 do
        user_fixture(account)
      end

      {:ok, %{users: users} = page} = Accounts.paginate_users(account, %{})

      assert length(users) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_users/0 returns all users", %{account: account} do
      user = user_fixture(account)
      assert Accounts.list_users(account) == [user]
    end

    test "get_user!/1 returns the user with given id", %{account: account} do
      user = user_fixture(account)
      assert Accounts.get_user!(account, user.id) == user
    end

    test "create_user/1 with valid data creates a user", %{account: account} do
      assert {:ok, %User{} = user} = Accounts.create_user(account, @valid_attrs)
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.type == :editor
      assert user.user_id == "some user_id"
    end

    test "create_user/1 with invalid data returns error changeset", %{account: account} do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(account, @invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.type == :viewer
      assert user.user_id == "some updated user_id"
    end

    test "update_user/2 with invalid data returns error changeset", %{account: account} do
      user = user_fixture(account)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(account, user.id)
    end

    test "delete_user/1 deletes the user", %{account: account} do
      user = user_fixture(account)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(account, user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
