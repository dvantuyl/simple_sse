defmodule SimpleSse.Components.UserInputComponent do
  import Temple

  def render(_assigns) do
    temple do
      form(
        hx_post: "/user-input",
        hx_target: "this"
      ) do
        fieldset(role: "group") do
          input(type: "text", name: "message", placeholder: "Pleased to meet you...")
          button do: "Speak"
        end
      end
    end
  end
end
