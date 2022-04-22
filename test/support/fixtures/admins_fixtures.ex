defmodule Todo.AdminsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `admin` context.
  """

  alias Todo.Admins

  def admin_fixture(), do: admin_fixture(%{})

  def admin_fixture(attrs) do
    attrs =
      Enum.into(attrs, %{
        email: "user#{System.unique_integer()}@example.com",
        first_name: "some first_name",
        last_name: "some last_name",
        type: :platform,
        user_id: "user#{System.unique_integer()}"
      })

    {:ok, admin} = Admins.create_admin(attrs)

    admin
  end
end
