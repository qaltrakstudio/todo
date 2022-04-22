defmodule Todo.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Todo.Repo

  import Saas.Helpers, only: [sort: 1, paginate: 4]
  import Filtrex.Type.Config

  alias Todo.Accounts.Account

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of accounts using filtrex
  filters.

  ## Examples

      iex> list_accounts(%{})
      %{accounts: [%Account{}], ...}
  """
  def paginate_accounts(params \\ %{}) do
    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:accounts), params["account"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_accounts(filter, params) do
      {:ok,
        %{
          accounts: page.entries,
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

  defp do_paginate_accounts(filter, params) do
    Account
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  defp filter_config(:accounts) do
    defconfig do
      text :name
        text :description
        
    end
  end

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end

  import Saas.Helpers, only: [sort: 1, paginate: 4]
  import Filtrex.Type.Config

  alias Todo.Accounts.User

  @pagination [page_size: 15]
  @pagination_distance 5

  @doc """
  Paginate the list of users using filtrex
  filters.

  ## Examples

      iex> paginate_users(account, %{})
      %{users: [%User{}], ...}
  """
  def paginate_users(account, params \\ %{}) do
    Repo.put_account_id(account.id)

    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:users), params["user"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_users(filter, params) do
      {:ok,
        %{
          users: page.entries,
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

  defp do_paginate_users(filter, params) do
    User
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  defp filter_config(:users) do
    defconfig do
      text :first_name
        text :last_name
        text :email
        text :user_id
        
      
    end
  end

  @doc """
  Returns the list of users for an account.

  ## Examples

      iex> list_users(account)
      [%User{}, ...]

  """
  def list_users(account) do
    Repo.all(User, account_id: account.id)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(account, 123)
      %User{}

      iex> get_user!(account, 456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(account, id), do: Repo.get!(User, id, account_id: account.id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(account, %{field: value})
      {:ok, %User{}}

      iex> create_user(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(account, attrs \\ %{}) do
    # account
    # |> Ecto.build_assoc(:users)
    # |> User.changeset(attrs)
    # |> Repo.insert()
    %User{}
    |> User.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:account, account)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
