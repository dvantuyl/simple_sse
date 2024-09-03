defmodule SimpleSse.EventData do
  def stream_latest(callback) do
    Phoenix.PubSub.subscribe(SimpleSse.PubSub, "conversation")
    stream_latest(callback, subscribed: true)
  end

  def stream_latest(callback, subscribed: true) do
    receive do
      {:message, message} ->
        callback.(message)
        stream_latest(callback, subscribed: true)
    end
  end
end
