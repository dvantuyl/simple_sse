defmodule SimpleSse.Components.ConversationComponent do
  alias SimpleSse.SseMessage
  import Temple

  def render(_assigns) do
    temple do
      article do
        div(
          hx_ext: "sse",
          sse_connect: "/conversation",
          sse_swap: "conversation",
          hx_swap: "beforeend"
        )
      end
    end
  end


  def stream_messages_to(conn) do
    receive do
      {:message, message} ->
        conn =
          %SseMessage{event: "conversation", data: "<p>#{message}</p>"}
          |> SseMessage.chunk_to(conn)

        stream_messages_to(conn)
    end
  end
end
