defmodule SimpleSse.Layouts.HtmlLayout do
  import Temple
  use Temple.Component
  alias SimpleSse.Components.UserInputComponent
  alias SimpleSse.Components.ConversationComponent

  def render do
    temple do
      "<!DOCTYPE html>"

      html do
        head do
          meta(charset: "UTF-8")
          meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
          title do: "Simple SSE"

          link(
            rel: "stylesheet",
            href: "https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css"
          )

          script(src: "https://unpkg.com/htmx.org@2.0.2", crossorigin: "anonymous")
          script(src: "https://unpkg.com/htmx-ext-sse@2.2.1/sse.js")
        end

        body do
          header(class: "container") do
            c &UserInputComponent.render/1
          end

          main(class: "container-fluid") do
            c &ConversationComponent.render/1
          end
        end
      end
    end
  end
end
