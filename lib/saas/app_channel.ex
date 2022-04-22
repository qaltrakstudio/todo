defmodule Saas.AppChannelHelper do
  @namespace "user_channel"
  @secret "ehC1cJYvVxMhglvBe9QWeT+Q7zWlv1LPQWO2DLwd3AqZXMbdM2HzmT3vevggs2fr"
  @max_age 1_209_600

  def channel_auth(%{id: "" <> id}) do
    Phoenix.Token.sign(@secret, @namespace, id)
  end

  def validate_channel_auth(token) do
    Phoenix.Token.verify(@secret, @namespace, token, max_age: @max_age)
  end

  def subscribe_to_user_channel(channel_name) do
    Phoenix.PubSub.subscribe(StoryCms.PubSub, channel_name)
  end

  def broadcast_to_user_channel(channel_name, payload) do
    Phoenix.PubSub.broadcast(StoryCms.PubSub, channel_name, {:notify, payload})
  end
end
