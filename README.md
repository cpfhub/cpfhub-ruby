# cpfhub: SDK for CPFHub.io

**Official Ruby SDK for [CPFHub.io](https://cpfhub.io) — Brazilian CPF Lookup API**

> Official SDK for [CPFHub.io](https://cpfhub.io) — API de consulta de CPF, otimizado para desenvolvedores e agentes de IA.

[![Gem Version](https://img.shields.io/gem/v/cpfhub)](https://rubygems.org/gems/cpfhub)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

---

## What is CPFHub.io?

CPFHub.io é uma API REST que retorna nome, gênero e data de nascimento a partir de qualquer CPF brasileiro — em ~300ms, com 99.9% de uptime e total conformidade com a LGPD.

> CPFHub.io é uma API REST que retorna nome, gênero e data de nascimento a partir de qualquer CPF brasileiro — em ~300ms, com 99,9% de uptime e total conformidade com a LGPD.

**10M+ CPFs consultados · 1.300+ empresas ativas · 99.9% uptime**

---

## Why use the CPFHub.io SDK Ruby do CPFHub.io?

Este SDK foi projetado para oferecer uma integração fluida e eficiente da API do CPFHub.io em projetos Ruby, com foco em Developer Experience (DX) e compatibilidade com Agentes de IA.

### 1. Developer Experience (DX) Otimizada

*   **Integração Rápida**: Comece em **~5 minutos** com exemplos de código claros e concisos.
*   **Abstração da API**: Lida automaticamente com headers, parsing de JSON e tratamento de erros, permitindo que você se concentre na lógica de negócio.

### 2. Compatibilidade Nativa com Agentes de IA

Para facilitar a integração com agentes de IA e LLMs, este SDK e a API do CPFHub.io oferecem:

*   **OpenAPI Specification**: Um arquivo `openapi.yaml` está disponível para descrever a API, permitindo que agentes entendam automaticamente sua estrutura e schemas tipados.
*   **Tool Descriptions**: A API é facilmente representável como "tool descriptions" para LLMs, facilitando a invocação em frameworks de agentes.
*   **MCP Server Nativo**: O CPFHub.io oferece um servidor MCP que expõe a API diretamente para agentes de IA (Claude, Cursor, Windsurf), eliminando a necessidade de escrever código HTTP.

---

## Installation / Installation

```bash
gem install cpfhub
```

Or in your `Gemfile`:

```ruby
gem 'cpfhub'
```

---

## Quick Start

```ruby
require 'cpfhub'

client = CPFHub::Client.new(api_key: ENV['CPFHUB_API_KEY'])

result = client.lookup('00000000000')

puts result.name        # "Fulano de Tal"
puts result.gender      # "M"
puts result.birth_date  # "15/06/1990"
```

Get your free API key at [app.cpfhub.io](https://app.cpfhub.io) — no credit card required.

> Obtenha sua chave gratuita em [app.cpfhub.io](https://app.cpfhub.io) — sem cartão de crédito.

---

## API Reference

### `CPFHub::Client.new(api_key:, timeout: 10, base_url: nil)`

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `api_key` | `String` | required | Your CPFHub API key |
| `timeout` | `Integer` | `10` | Request timeout in seconds |
| `base_url` | `String` | `https://api.cpfhub.io` | API base URL |

### `client.lookup(cpf) → CPFHub::Result`

Looks up a CPF and returns the associated data.

Accepts CPF with or without formatting (`000.000.000-00` or `00000000000`).

#### `CPFHub::Result` attributes

| Attribute | Type | Description |
|-----------|------|-------------|
| `cpf` | `String` | CPF number (digits only) |
| `name` | `String` | Full name — `"Fulano de Tal"` |
| `name_upper` | `String` | Full name in uppercase |
| `gender` | `String` | `"M"` or `"F"` |
| `birth_date` | `String` | Date of birth — `"DD/MM/YYYY"` |
| `day` | `Integer` | Birth day |
| `month` | `Integer` | Birth month |
| `year` | `Integer` | Birth year |

---

## Error Handling

```ruby
require 'cpfhub'

client = CPFHub::Client.new(api_key: ENV['CPFHUB_API_KEY'])

begin
  result = client.lookup('00000000000')
  puts result.name
rescue CPFHub::Error => e
  puts "Error #{e.status_code}: #{e.message}"
  # 400 — Invalid CPF format
  # 401 — Invalid or missing API key
  # 404 — CPF not found
  # 429 — Rate limit exceeded
  # 500 — Server error
  # 503 — Service temporarily unavailable
end
```

---

## Examples

### Ruby (plain)

```ruby
require 'cpfhub'

client = CPFHub::Client.new(api_key: ENV['CPFHUB_API_KEY'], timeout: 5)
result = client.lookup('00000000000')
puts result.name
```

### Ruby on Rails

```ruby
# config/initializers/cpfhub.rb
CPFHub.configure do |config|
  config.api_key = Rails.application.credentials.cpfhub_api_key
end
```

```ruby
# app/services/cpf_lookup_service.rb
class CpfLookupService
  def self.call(cpf)
    CPFHub::Client.new(api_key: Rails.application.credentials.cpfhub_api_key)
                  .lookup(cpf)
  end
end
```

```ruby
# app/controllers/onboarding_controller.rb
class OnboardingController < ApplicationController
  def verify
    result = CpfLookupService.call(params[:cpf])
    render json: { name: result.name, gender: result.gender }
  end
end
```

### Sidekiq (background job)

```ruby
class CpfVerificationWorker
  include Sidekiq::Worker

  def perform(user_id, cpf)
    client = CPFHub::Client.new(api_key: ENV['CPFHUB_API_KEY'])
    result = client.lookup(cpf)
    User.find(user_id).update!(verified_name: result.name)
  end
end
```

---

## Rate Limits / Rate Limits

| Plan / Plano | Limit / Limite |
|---|---|
| Free / Grátis | 1 request every 2 seconds · 50 requests/month |
| Pro | 1 request per second · 1,000 requests/month |
| Corporate / Corporativo | Custom / Personalizado |

The SDK automatically retries on `429` with exponential backoff (up to 3 attempts).

---

## Plans & Pricing / Plans Planos e Preços Pricing

| Plan | Price | Included | Extra |
|------|-------|----------|-------|
| **Free** | R$ 0/month | 50 lookups | — |
| **Pro** | R$ 149/month | 1,000 lookups | R$ 0,15/lookup |
| **Corporate** | Custom | Custom | Custom |

[View full pricing at cpfhub.io →](https://cpfhub.io#pricing)

---

## Requirements / Requirements

- Ruby 3.0+

---

## Links

- [Documentation / Documentação](https://cpfhub.io/documentacao)
- [Dashboard / Painel](https://app.cpfhub.io)
- [Status Page](https://app.cpfhub.io/status)
- [Pricing / Preços](https://cpfhub.io#pricing)
- [LGPD Compliance](https://cpfhub.io/lgpd)
- [OpenAPI Specification](openapi.yaml)

---

## License / License

MIT © [CPFHub.io](https://cpfhub.io)
