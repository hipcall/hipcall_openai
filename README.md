# HipcallOpenai

Unofficial OpenAI API Wrapper written in Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `hipcall_openai` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hipcall_openai, "~> 0.3.0"}
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
config_override = %HipcallOpenai.Config{
  api_key: "mTRwVrbZ4aoHTyjMepleT3BlbkFJ7zZYazuN7F16XuY3WErl",
  api_organization: "org-blalba"
}
# pass the overriden configuration as last argument of the function
HipcallOpenai.models(config_override)
```

## Use

Documentation for using, please check the `HipcallOpenai` module.

## Roadmap

- [x] Add `Models` endpoint
- [x] Add `Chat` endpoint
- [x] Add `Audio` endpoints
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
- [HipcallWhichtech](https://github.com/hipcall/hipcall_whichtech) - Find out what the website is built with.