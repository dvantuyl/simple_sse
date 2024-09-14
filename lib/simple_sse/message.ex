defmodule SimpleSse.SseMessage do
  defstruct [:event, :data]

  alias Phoenix.PubSub
  alias SimpleSse.SseMessage

  def chunk_to(%SseMessage{} = msg, conn) do
    Plug.Conn.chunk(conn, "event: #{msg.event}\r\ndata: #{msg.data}\r\n\n")
    conn
  end

  def broadcast(topic, message) do
    PubSub.broadcast(SimpleSse.PubSub, topic, {:message, message})
  end

  def subscribe(topic) do
    PubSub.subscribe(SimpleSse.PubSub, topic)
  end

  def stream_to(conn, component, render) do
    receive do
      {:message, message} ->
        conn =
          %SseMessage{event: component, data: render.(message)}
          |> SseMessage.chunk_to(conn)

        stream_to(conn, component, render)
    end

    conn
  end
end
