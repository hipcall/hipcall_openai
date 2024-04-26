defmodule HipcallOpenai.Embeddings do
  @moduledoc false

  alias HipcallOpenai.Config

  @endpoint_url "embeddings"

  def create(params, config \\ %Config{}) do
    Finch.build(
      :post,
      "#{Config.api_url()}#{@endpoint_url}",
      header(config),
      body(params)
    )
    |> Finch.request(HipcallOpenaiFinch, receive_timeout: 600_000)
    |> case do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        {:ok, body |> Jason.decode!()}

      {:ok, %Finch.Response{status: status, body: body, headers: headers}} ->
        {:error, %{status: status, body: body |> Jason.decode!(), headers: headers}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp body(params) do
    params |> Enum.into(%{}) |> Jason.encode!()
  end

  defp header(config) do
    api_key = config.api_key || Config.api_key()
    api_organization = config.api_organization || Config.api_organization()

    [
      {"Authorization", "Bearer #{api_key}"},
      {"OpenAI-Organization", "#{api_organization}"},
      {"content-type", "application/json"}
    ]
  end
end
