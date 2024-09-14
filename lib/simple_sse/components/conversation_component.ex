defmodule SimpleSse.Components.ConversationComponent do
  import Temple

  def render(_assigns \\ {}) do
    temple do
      article do
        div(
          hx_ext: "sse",
          sse_connect: "/conversation",
          sse_swap: __MODULE__,
          hx_swap: "beforeend"
        )
      end
    end
  end
end
