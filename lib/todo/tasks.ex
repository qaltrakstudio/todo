defmodule Todo.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias Todo.Repo

  import Saas.Helpers, only: [sort: 1, paginate: 4]
  import Filtrex.Type.Config

  alias Todo.Tasks.Task

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of tasks using filtrex
  filters.

  ## Examples

      iex> paginate_tasks(account, %{})
      %{tasks: [%Task{}], ...}
  """
  def paginate_tasks(account, params \\ %{}) do
    Repo.put_account_id(account.id)

    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:tasks), params["task"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_tasks(filter, params) do
      {:ok,
        %{
          tasks: page.entries,
          page_number: page.page_number,
          page_size: page.page_size,
          total_pages: page.total_pages,
          total_entries: page.total_entries,
          distance: @pagination_distance,
          sort_field: sort_field,
          sort_direction: sort_direction
        }
      }
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  defp do_paginate_tasks(filter, params) do
    Task
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  defp filter_config(:tasks) do
    defconfig do
      text :name
        text :description
        
    end
  end

  @doc """
  Returns the list of tasks for an account.

  ## Examples

      iex> list_tasks(account)
      [%Task{}, ...]

  """
  def list_tasks(account) do
    Repo.all(Task, account_id: account.id)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(account, 123)
      %Task{}

      iex> get_task!(account, 456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(account, id), do: Repo.get!(Task, id, account_id: account.id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(account, %{field: value})
      {:ok, %Task{}}

      iex> create_task(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(account, attrs \\ %{}) do
    # account
    # |> Ecto.build_assoc(:tasks)
    # |> Task.changeset(attrs)
    # |> Repo.insert()
    %Task{}
    |> Task.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:account, account)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end
end
