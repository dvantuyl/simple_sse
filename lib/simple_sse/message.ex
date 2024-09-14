defmodule SimpleSse.SseMessage do
  defstruct [:event, :data]

  alias Phoenix.PubSub
  alias SimpleSse.SseMessage

  @type t :: %SseMessage{event: String.t(), data: String.t()}

  @spec chunk_to(SseMessage.t(), Plug.Conn.t()) :: Plug.Conn.t()
  def chunk_to(%SseMessage{} = msg, conn) do
    Plug.Conn.chunk(conn, "event: #{msg.event}\r\ndata: #{msg.data}\r\n\n")
    conn
  end

  @spec broadcast(String.t(), String.t()) :: :ok
  def broadcast(topic, message) do
    PubSub.broadcast(SimpleSse.PubSub, topic, {:message, message})
    :ok
  end

  @spec subscribe(String.t()) :: :ok
  def subscribe(topic) do
    PubSub.subscribe(SimpleSse.PubSub, topic)
    :ok
  end

  @spec stream_to(Plug.Conn.t(), String.t(), (String.t() -> String.t())) :: no_return()
  def stream_to(conn, component, render) do
    receive do
      {:message, message} ->
        conn =
          %SseMessage{event: component, data: render.(message)}
          |> SseMessage.chunk_to(conn)

        stream_to(conn, component, render)
    end
  end
end
