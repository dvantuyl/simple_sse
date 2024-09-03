defmodule SimpleSse.Router do
  use Plug.Router

  alias Phoenix.PubSub
  alias SimpleSse.Components.ConversationComponent
  alias SimpleSse.Layouts.HtmlLayout
  alias SimpleSse.Components.UserInputComponent
  alias SimpleSse.EventData

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/" do
    {:safe, html} = HtmlLayout.render()

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, html |> Enum.join(""))
  end

  get "/conversation" do
    conn =
      conn
      |> put_resp_header("X-Accel-Buffering", "no")
      |> put_resp_content_type("text/event-stream")
      |> put_resp_header("Cache-Control", "no-cache")
      |> send_chunked(200)

    EventData.stream_latest(fn message ->
      chunk(conn, ConversationComponent.stream("<p>#{message}</p>"))
    end)

    conn
  end

  post "/user-input" do
    message = conn.body_params["message"]

    PubSub.broadcast(SimpleSse.PubSub, "conversation", {:message, message})

    {:safe, html} = UserInputComponent.render({})

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, html |> Enum.join(""))
  end

  match _ do
    send_resp(conn, 404, "Oops! Not Found")
  end
end
