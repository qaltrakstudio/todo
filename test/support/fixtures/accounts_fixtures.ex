defmodule Todo.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `account` context.
  """

  alias Todo.Accounts
  alias Todo.Accounts.Account

  @valid_account_attrs %{description: "some description", name: "some name"}

  def account_fixture(), do: account_fixture(%{})

  def account_fixture(attrs) do
    attrs = Enum.into(attrs, @valid_account_attrs)

    {:ok, account} = Accounts.create_account(attrs)

    account
  end

  def user_fixture(), do: user_fixture(%{})
  def user_fixture(%Account{} = account), do: user_fixture(account, %{})

  def user_fixture(attrs) do
    account = account_fixture()
    user_fixture(account, attrs)
  end

  def user_fixture(%Account{} = account, attrs) do
    attrs =
      Enum.into(attrs, %{
        email: "user#{System.unique_integer()}@example.com",
        first_name: "some first_name",
        last_name: "some last_name",
        type: :editor,
        user_id: "user#{System.unique_integer()}"
      })

    {:ok, user} = Accounts.create_user(account, attrs)

    Accounts.get_user!(account, user.id)
  end
end
