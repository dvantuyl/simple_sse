defmodule SimpleSse.Components.MessageComponent do
  import Temple

  def render(assigns) do
    temple do
      p do: @message
    end
  end
end
