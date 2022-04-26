defmodule TodoApi.Types.Task do
  use Absinthe.Schema.Notation
  alias TodoApi.Resolvers

  @desc "Task Object"
  object :task do
    field :name, non_null(:string)
    field :description, non_null(:string)
  end

  @desc "List Tasks Object"
  object :list_tasks do
    field :tasks, list_of(:task)
  end

  object :task_queries do
    @desc """
    Task queries
    """
    field :list_tasks, :list_tasks do
      resolve(&Resolvers.Task.list_tasks/2)
    end
  end
end
