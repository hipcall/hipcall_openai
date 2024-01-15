defmodule HipcallOpenai.Models do
  @moduledoc false

  alias HipcallOpenai.Config

  @endpoint_url "models"

  @doc """
  List models

  For more information  https://platform.openai.com/docs/api-reference/models

  ## Examples

      iex> iex(1)> HipcallOpenai.models(config_override)
      ...> {:ok,
      ...> %{
      ...>   "data" => [
      ...>     %{
      ...>       "created" => 1686588896,
      ...>       "id" => "gpt-4-0613",
      ...>       "object" => "model",
      ...>       "owned_by" => "openai"
      ...>     },
      ...>     %{
      ...>       "created" => 1651172509,
      ...>       "id" => "curie-search-query",
      ...>       "object" => "model",
      ...>       "owned_by" => "openai-dev"
      ...>     },
      ...>     %{
      ...>       "created" => 1687882411,
      ...>       "id" => "gpt-4",
      ...>       "object" => "model",
      ...>       "owned_by" => "openai"
      ...>     },
      ...>     %{
      ...>       "created" => 1651172509,
      ...>       "id" => "babbage-search-query",
      ...>       "object" => "model",
      ...>       "owned_by" => "openai-dev"
      ...>     },
      ...>     %{
      ...>       "created" => 1698785189,
      ...>       "id" => "dall-e-3",
      ...>       "object" => "model",
      ...>       "owned_by" => "system"
      ...>     }
      ...>   ],
      ...>   "object" => "list"
      ...> }}

  ## Arguments

  - `config`

  ## Options

  There is no options.

  ## Raises

  - There is no exception.

  ## Returns

  - {:ok, Finch.Response.t()}
  - {:error, Exception.t()}

  """
  @spec list(config :: map) :: {:ok, map()} | {:error, map()} | {:error, any()}
  def list(config \\ %Config{}) do
    Finch.build(:get, "#{Config.api_url()}#{@endpoint_url}", header(config))
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

  @doc """
  Retrieve model

  For more information https://platform.openai.com/docs/api-reference/models/retrieve

  ## Examples

      iex> iex(1)> HipcallOpenai.model("gpt-3.5-turbo-instruct", config_override)
      ...> {:ok,
      ...>  %{
      ...>    "created" => 1692901427,
      ...>    "id" => "gpt-3.5-turbo-instruct",
      ...>    "object" => "model",
      ...>    "owned_by" => "system"
      ...>  }}

  ## Arguments

  - `model`
  - `config`

  ## Options

  There is no options.

  ## Raises

  There is no exceptions.

  ## Returns

  - {:ok, map()}
  - {:error, Exception.t()}

  """
  @spec retrieve(model :: String.t(), config :: map) ::
          {:ok, map()} | {:error, map()} | {:error, any()}
  def retrieve(model, config \\ %Config{}) do
    Finch.build(:get, "#{Config.api_url()}#{@endpoint_url}/#{model}", header(config))
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
