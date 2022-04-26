defmodule TodoApi.Resolvers.Task do
  def list_tasks(_args, _context) do
    {:ok, %{tasks: [%{name: "task", description: "task description"}]}}
  end
end
