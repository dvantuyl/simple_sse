defmodule SimpleSse.SseMessage do
  defstruct [:event, :data]

  def chunk_to(msg, conn) do
    Plug.Conn.chunk(conn, "event: #{msg.event}\r\ndata: #{msg.data}\r\n\n" )
    conn
  end
end
