defmodule Todo.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    create table(:admins, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :user_id, :string
      add :type, :string

      timestamps()
    end

    create unique_index(:admins, [:user_id])
    create unique_index(:admins, [:email])
  end
end
