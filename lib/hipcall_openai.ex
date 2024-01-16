defmodule HipcallOpenai do
  @moduledoc """
  Documentation for `HipcallOpenai`.
  """
  alias HipcallOpenai.Chat
  alias HipcallOpenai.Config
  alias HipcallOpenai.Models

  @chat_completions_schema [
    model: [
      type: :string,
      doc: """
      ID of the model to use. See the model endpoint compatibility table for
      details on which models work with the Chat API.
      """,
      default: "gpt-3.5-turbo"
    ],
    messages: [
      type: {:list, :map},
      doc: """
      A list of messages comprising the conversation so far.
      """,
      default: [
        %{role: "system", content: "You are a helpful assistant."},
        %{role: "user", content: "Hello!"}
      ]
    ],
    frequency_penalty: [
      type: :float,
      doc: """
      Number between -2.0 and 2.0. Positive values penalize new tokens based on
      their existing frequency in the text so far, decreasing the model's
      likelihood to repeat the same line verbatim.
      """
    ],
    max_tokens: [
      type: :pos_integer,
      doc: """
      The maximum number of tokens that can be generated in the chat completion.
      The total length of input tokens and generated tokens is limited by the
      model's context length.
      """
    ],
    stream: [
      type: :boolean,
      doc: """
      If set, partial message deltas will be sent, like in ChatGPT. Tokens will
      be sent as data-only server-sent events as they become available, with
      the stream terminated by a data: [DONE] message.
      """
    ],
    temperature: [
      type: :float,
      doc: """
      What sampling temperature to use, between 0 and 2. Higher values like 0.8
      will make the output more random, while lower values like 0.2 will make
      it more focused and deterministic.
      """
    ],
    user: [
      type: :string,
      doc: """
      A unique identifier representing your end-user, which can help OpenAI
      to monitor and detect abuse.
      """
    ]
  ]

  @doc """
  List models

  For more information  https://platform.openai.com/docs/api-reference/models

  ## Examples

      iex> iex(1)> config_override = %Config{api_key: "asdf_api"}
      iex> iex(2)> HipcallOpenai.models(config_override)
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

  ## Raises

  - There is no exception.

  ## Returns

  - `{:ok, Finch.Response.t()}`
  - `{:error, Exception.t()}`

  """
  @spec models(config :: struct()) :: {:ok, map()} | {:error, map()} | {:error, any()}
  def models(config \\ %Config{}) when is_struct(config) do
    Models.list(config)
  end

  @doc """
  Retrieve model

  For more information https://platform.openai.com/docs/api-reference/models/retrieve

  ## Examples

      iex> iex(1)> iex(1)> HipcallOpenai.model("gpt-3.5-turbo-instruct")
      ...> {:ok,
      ...>  %{
      ...>    "created" => 1692901427,
      ...>    "id" => "gpt-3.5-turbo-instruct",
      ...>    "object" => "model",
      ...>    "owned_by" => "system"
      ...>  }}

  ## Arguments

    - `model`

  ## Raises

  There is no exceptions.

  ## Returns

    - `{:ok, map()}`
    - `{:error, Exception.t()}`

  """
  @spec model(model :: String.t()) :: {:ok, map()} | {:error, map()} | {:error, any()}
  def model(model) when is_bitstring(model) do
    model(model, %Config{})
  end

  @doc """
  The same with `model/1` just overwrite the config.
  """
  @spec model(model :: String.t(), config :: struct()) ::
          {:ok, map()} | {:error, map()} | {:error, any()}
  def model(model, %Config{} = config), do: Models.retrieve(model, config)

  @doc """
  Create chat completion

  For more information  https://platform.openai.com/docs/api-reference/chat/create

  ## Examples

      iex> params = [
      iex>   model: "gpt-4-1106-preview",
      iex>   messages: [
      iex>     %{role: "system", content: "Sen yardımcı olan bir asistansın."},
      iex>     %{role: "user", content: "Merhaba!"}
      iex>   ]
      iex> ]
      iex> HipcallOpenai.chat_completions(params)
      ...> {:ok,
      ...>   %{
      ...>     "choices" => [
      ...>       %{
      ...>         "finish_reason" => "stop",
      ...>         "index" => 0,
      ...>         "logprobs" => nil,
      ...>         "message" => %{
      ...>           "content" => "Merhaba! Size nasıl yardımcı olabilirim?",
      ...>           "role" => "assistant"
      ...>         }
      ...>       }
      ...>     ],
      ...>     "created" => 1705330002,
      ...>     "id" => "chatcmpl-8hIWYa9L3HBatp1Wyp5fJfneaBMUi",
      ...>     "model" => "gpt-4-1106-preview",
      ...>     "object" => "chat.completion",
      ...>     "system_fingerprint" => "fp_168383a679",
      ...>     "usage" => %{
      ...>       "completion_tokens" => 15,
      ...>       "prompt_tokens" => 27,
      ...>       "total_tokens" => 42
      ...>     }
      ...>   }}

  ## Params

  #{NimbleOptions.docs(@chat_completions_schema)}

  ## Raises

  - Raise `NimbleOptions.ValidationError` if params are not valid.

  ## Returns

  - `{:ok, Finch.Response.t()}`
  - `{:error, Exception.t()}`

  """
  @spec chat_completions(params :: keyword()) :: {:ok, map()} | {:error, map()} | {:error, any()}
  def chat_completions(params) do
    NimbleOptions.validate!(params, @chat_completions_schema)
    Chat.completions(params, %Config{})
  end

  @doc """
  The same `chat_completions/1` just overwrite config.
  """
  @spec chat_completions(params :: keyword(), config :: struct()) ::
          {:ok, map()} | {:error, map()} | {:error, any()}
  def chat_completions(params, %Config{} = config) when is_struct(config) do
    NimbleOptions.validate!(params, @chat_completions_schema)
    Chat.completions(params, config)
  end
end
