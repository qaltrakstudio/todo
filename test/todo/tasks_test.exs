defmodule Todo.TasksTest do
  use Todo.DataCase

  import Todo.AccountsFixtures

  alias Todo.Tasks

  def setup_account(_) do
    account = account_fixture()
    {:ok, account: account}
  end

  import Todo.TasksFixtures

  describe "tasks" do
    setup [:setup_account]

    alias Todo.Tasks.Task

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    test "paginate_tasks/1 returns paginated list of tasks", %{account: account} do
      for _ <- 1..20 do
        task_fixture(account)
      end

      {:ok, %{tasks: tasks} = page} = Tasks.paginate_tasks(account, %{})

      assert length(tasks) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_tasks/0 returns all tasks", %{account: account} do
      task = task_fixture(account)
      assert Tasks.list_tasks(account) == [task]
    end

    test "get_task!/1 returns the task with given id", %{account: account} do
      task = task_fixture(account)
      assert Tasks.get_task!(account, task.id) == task
    end

    test "create_task/1 with valid data creates a task", %{account: account} do
      assert {:ok, %Task{} = task} = Tasks.create_task(account, @valid_attrs)
      assert task.description == "some description"
      assert task.name == "some name"
    end

    test "create_task/1 with invalid data returns error changeset", %{account: account} do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(account, @invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, %Task{} = task} = Tasks.update_task(task, @update_attrs)
      assert task.description == "some updated description"
      assert task.name == "some updated name"
    end

    test "update_task/2 with invalid data returns error changeset", %{account: account} do
      task = task_fixture(account)
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(account, task.id)
    end

    test "delete_task/1 deletes the task", %{account: account} do
      task = task_fixture(account)
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(account, task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
