defmodule SimpleSse.Router do
  use Plug.Router

  alias Phoenix.HTML

  alias SimpleSse.SseMessage
  alias SimpleSse.Layouts.HtmlLayout
  alias SimpleSse.Components.ConversationComponent
  alias SimpleSse.Components.UserInputComponent
  alias SimpleSse.Components.MessageComponent

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/" do
    html =
      HtmlLayout.render()
      |> HTML.safe_to_string()

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, html)
  end

  get "/conversation" do
    SseMessage.subscribe("user_input")

    conn
    |> put_resp_header("X-Accel-Buffering", "no")
    |> put_resp_content_type("text/event-stream")
    |> put_resp_header("Cache-Control", "no-cache")
    |> send_chunked(200)
    |> SseMessage.stream_to(ConversationComponent, fn message ->
      MessageComponent.render(message: message)
      |> HTML.safe_to_string()
    end)
  end

  post "/user-input" do
    SseMessage.broadcast("user_input", conn.body_params["message"])

    html =
      UserInputComponent.render()
      |> HTML.safe_to_string()

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, html)
  end

  match _ do
    send_resp(conn, 404, "Oops! Not Found")
  end
end
