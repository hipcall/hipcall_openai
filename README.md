# HipcallOpenai

Unofficial OpenAI API Wrapper written in Elixir.

This Hex package is beta right now. [Please use another one](https://hex.pm/packages?search=openai&sort=name).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `hipcall_openai` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hipcall_openai, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/hipcall_openai>.

## Configuration override

Client library configuration can be overwritten in runtime by passing a %HipcallOpenai.Config{} 
struct as last argument of the function you need to use. For instance if you need to use a different 
api_key you can simply do:

```elixir
config_override = %HipcallOpenai.Config{api_key: "mTRwVrbZ4aoHTyjMepleT3BlbkFJ7zZYazuN7F16XuY3WErl"}
# pass the overriden configuration as last argument of the function
HipcallOpenai.models(config_override)
```

## Use

### Models

#### List

https://platform.openai.com/docs/api-reference/models

```elixir
iex(1)> HipcallOpenai.models(config_override)
{:ok,
 %{
   "data" => [
     %{
       "created" => 1686588896,
       "id" => "gpt-4-0613",
       "object" => "model",
       "owned_by" => "openai"
     },
     %{
       "created" => 1651172509,
       "id" => "curie-search-query",
       "object" => "model",
       "owned_by" => "openai-dev"
     },
     %{
       "created" => 1687882411,
       "id" => "gpt-4",
       "object" => "model",
       "owned_by" => "openai"
     },
     %{
       "created" => 1651172509,
       "id" => "babbage-search-query",
       "object" => "model",
       "owned_by" => "openai-dev"
     },
     %{
       "created" => 1698785189,
       "id" => "dall-e-3",
       "object" => "model",
       "owned_by" => "system"
     }
   ],
   "object" => "list"
 }}
```

#### Retrieve

https://platform.openai.com/docs/api-reference/models/retrieve

```elixir
iex(1)> HipcallOpenai.model("gpt-3.5-turbo-instruct", config_override)
{:ok,
 %{
   "created" => 1692901427,
   "id" => "gpt-3.5-turbo-instruct",
   "object" => "model",
   "owned_by" => "system"
 }}
```

## Roadmap

- [ ] Add `Audio` endpoints
- [ ] Add `Chat` endpoint
- [ ] Add `Embeddings` endpoint
- [ ] Add `Fine-tuning` endpoint
- [ ] Add `Files` endpoint
- [ ] Add `Images` endpoint
- [ ] Add `Moderations` endpoint
- [ ] Add `Beta - Assistants` endpoint
- [ ] Add `Beta - Threads` endpoint
- [ ] Add `Beta - Messages` endpoint
- [ ] Add `Beta - Runs` endpoint
- [ ] Add `Tools` or `Utils` calculate token, etc. 

## Hipcall

All [Hipcall](https://www.hipcall.com/en-gb/) libraries:

- [HipcallDisposableEmail](https://github.com/hipcall/hipcall_disposable_email) - Simple library checking the email's domain is disposable or not.
- [HipcallDeepgram](https://github.com/hipcall/hipcall_deepgram) - Unofficial Deepgram API Wrapper written in Elixir.
- [HipcallOpenai](https://github.com/hipcall/hipcall_openai) - Unofficial OpenAI API Wrapper written in Elixir.