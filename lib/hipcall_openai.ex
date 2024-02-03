defmodule HipcallOpenai do
  @moduledoc """
  Documentation for `HipcallOpenai`.
  """
  alias HipcallOpenai.Audio.Speech
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

  @audio_create_speech_schema [
    model: [
      type: :string,
      doc: """
      One of the available TTS models: `tts-1` or `tts-1-hd`
      """,
      default: "tts-1",
      required: true
    ],
    input: [
      type: :string,
      doc: """
      The text to generate audio for. The maximum length is 4096 characters.
      """,
      default: "Hello world!",
      required: true
    ],
    voice: [
      type: :string,
      doc: """
      The voice to use when generating the audio. Supported voices are `alloy`, `echo`, `fable`, `onyx`, `nova`, and `shimmer`. Previews of the voices are available in the Text to speech guide.
      """,
      default: "nova",
      required: true
    ],
    response_format: [
      type: :string,
      doc: """
      The voice to use when generating the audio. Supported voices are `alloy`, `echo`, `fable`, `onyx`, `nova`, and `shimmer`. Previews of the voices are available in the Text to speech guide.
      """,
      default: "mp3"
    ],
    speed: [
      type: :float,
      doc: """
      The speed of the generated audio. Select a value from 0.25 to 4.0. 1.0 is the default.
      """,
      default: 1.0
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

  ## Arguments

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

  @doc """
  Create an audio from text.

  For more information

  - https://platform.openai.com/docs/guides/text-to-speech
  - https://platform.openai.com/docs/api-reference/audio/createSpeech


  ## Examples

      iex> %HipcallOpenai.Config{
      iex>   api_key: "YOUR_TOKEN_HERE",
      iex>   api_organization: "YOUR_ORG_KEY_HERE",
      iex>   api_url: nil
      iex> }
      iex> params = [
      iex>   model: "tts-1",
      iex>   input: "Hello, I'm an Elixir wrapper for OpenAI.",
      iex>   voice: "nova"
      iex> ]
      iex> HipcallOpenai.audio_create_speech(params, config_override)
      ...> {:ok, <<255, 243, 228, 196, 0, 103, 84, 58, 0, 5, 90, 208, 0, 1, 141, 82, 99, 56, 64,
      ...> 88, 0, 132, 9, 139, 34, 101, 75, 153, 147, 38, 100, 201, 155, 42, 104, 14,
      ...> 25, 227, 198, 120, 241, 158, 56, 102, 139, 25, 66, 6, ...>>}

  You can easily create a new mp3 file. For example

      iex> {:ok, finch_body} = HipcallOpenai.audio_create_speech(params, config_override)
      iex> File.write!("test.mp3", finch_body)
      ...> :ok

  ## Arguments

  #{NimbleOptions.docs(@chat_completions_schema)}

  ## Raises

    - Raise `NimbleOptions.ValidationError` if params are not valid.

  ## Returns

    - `{:ok, Finch.Response.t()}`
    - `{:error, Exception.t()}`

  """
  @spec audio_create_speech(params :: keyword()) ::
          {:ok, map()} | {:error, map()} | {:error, any()}
  def audio_create_speech(params) do
    NimbleOptions.validate!(params, @audio_create_speech_schema)
    Speech.create(params, %Config{})
  end

  @doc """
  The same `audio_create_speech/1` just overwrite config.
  """
  @spec audio_create_speech(params :: keyword(), config :: struct()) ::
          {:ok, map()} | {:error, map()} | {:error, any()}
  def audio_create_speech(params, %Config{} = config) do
    NimbleOptions.validate!(params, @audio_create_speech_schema)
    Speech.create(params, config)
  end
end
