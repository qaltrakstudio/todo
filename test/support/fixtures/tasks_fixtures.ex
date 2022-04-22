defmodule Todo.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `task` context.
  """

  import Todo.AccountsFixtures

  alias Todo.Tasks
  alias Todo.Accounts.Account

  @valid_task_attrs %{description: "some description", name: "some name"}

  def task_fixture(), do: task_fixture(%{})
  def task_fixture(%Account{} = account), do: task_fixture(account, %{})

  def task_fixture(attrs) do
    account = account_fixture()
    task_fixture(account, attrs)
  end

  def task_fixture(%Account{} = account, attrs) do
    attrs =
      Enum.into(attrs, @valid_task_attrs)

    {:ok, task} = Tasks.create_task(account, attrs)

    Tasks.get_task!(account, task.id)
  end
end
