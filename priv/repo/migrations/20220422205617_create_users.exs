defmodule Todo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :user_id, :string
      add :type, :string
      add :account_id, references(:accounts, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:users, [:user_id, :account_id])
    create unique_index(:users, [:email, :account_id])
    create index(:users, [:account_id])
  end
end
