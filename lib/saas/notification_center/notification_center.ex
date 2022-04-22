defmodule Saas.NotificationCenter do
  defmacro __using__(_opts) do
    quote do
      import Saas.Notifiers

      alias Saas.Message

      defdelegate send_notification(message), to: Saas.Notifiers, as: :send

      def change_message(%Message{} = message, attrs \\ %{}) do
        Message.changeset(message, attrs)
      end
    end
  end
end
