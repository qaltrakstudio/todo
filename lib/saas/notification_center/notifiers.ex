defprotocol Saas.Notifiers do
  @moduledoc false

  def send(message)
end
