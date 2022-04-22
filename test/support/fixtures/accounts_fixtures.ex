defmodule Todo.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `account` context.
  """

  alias Todo.Accounts

  @valid_account_attrs %{description: "some description", name: "some name"}

  def account_fixture(), do: account_fixture(%{})

  def account_fixture(attrs) do
    attrs =
      Enum.into(attrs, @valid_account_attrs)

    {:ok, account} = Accounts.create_account(attrs)

    account
  end
end
