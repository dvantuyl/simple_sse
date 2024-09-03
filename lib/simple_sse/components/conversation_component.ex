defmodule SimpleSse.Components.ConversationComponent do
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

  def stream(data) do
    "event: conversation\r\ndata: #{data}\r\n\n"
  end
end
