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


  def stream_messages(conn) do
    receive do
      {:user, message} ->
        conn =
          %SseMessage{event: "conversation", data: "<p>#{message}</p>"}
          |> SseMessage.chunk_to(conn)

        stream_messages(conn)
    end
  end
end
