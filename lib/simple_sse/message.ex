defmodule SimpleSse.SseMessage do
  defstruct [:event, :data]

  alias SimpleSse.SseMessage

  def chunk_to(%SseMessage{} = msg, conn) do
    Plug.Conn.chunk(conn, "event: #{msg.event}\r\ndata: #{msg.data}\r\n\n" )
    conn
  end
end
