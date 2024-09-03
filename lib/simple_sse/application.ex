defmodule SimpleSse.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: SimpleSse.Worker.start_link(arg)
      # {SimpleSse.Worker, arg}
      {Phoenix.PubSub, name: SimpleSse.PubSub},
      {Bandit, plug: SimpleSse.Router, port: 4000}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SimpleSse.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
