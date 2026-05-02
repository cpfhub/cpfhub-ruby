# cpfhub: Ruby SDK for CPFHub.io

🇺🇸 **English** | [🇧🇷 Português](#português)

**Official Ruby SDK for [CPFHub.io](https://cpfhub.io) — Brazilian CPF Lookup API**

[![Gem Version](https://img.shields.io/gem/v/cpfhub)](https://rubygems.org/gems/cpfhub)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

---

## What is CPFHub.io?

CPFHub.io is a REST API that returns name, gender, and date of birth from any Brazilian CPF number — in ~300ms, with 99.9% uptime and full LGPD compliance.

**10M+ CPFs queried · 1,300+ active companies · 99.9% uptime**

---

## Installation

```bash
gem install cpfhub
```

Or add to your `Gemfile`:

```ruby
gem 'cpfhub'
```

---

## Quick Start

```ruby
require 'cpfhub'

client = CPFHub::Client.new(api_key: 'YOUR_API_KEY')

result = client.lookup('00000000000')

puts result['name']       # "Fulano de Tal"
puts result['gender']     # "M"
puts result['birthDate']  # "15/06/1990"
```

Get your free API key at [app.cpfhub.io](https://app.cpfhub.io) — no credit card required.

---

## curl Example

```bash
curl -X GET "https://api.cpfhub.io/cpf/12345678909" \
  -H "x-api-key: YOUR_API_KEY"
```

**Response:**

```json
{
  "success": true,
  "data": {
    "cpf": "12345678909",
    "name": "Fulano de Tal",
    "nameUpper": "FULANO DE TAL",
    "gender": "M",
    "birthDate": "15/06/1990",
    "day": 15,
    "month": 6,
    "year": 1990
  }
}
```

---

## API Reference

### `CPFHub::Client.new(api_key:, timeout: 10, base_url: nil)`

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `api_key` | `String` | required | Your CPFHub API key |
| `timeout` | `Integer` | `10` | Request timeout in seconds |
| `base_url` | `String` | `https://api.cpfhub.io` | API base URL |

### `client.lookup(cpf) -> Hash`

Looks up a CPF and returns the associated identity data.

Accepts CPF with or without formatting (`000.000.000-00` or `00000000000`).

#### Response hash keys

| Key | Type | Description |
|-----|------|-------------|
| `cpf` | `String` | CPF number (digits only) |
| `name` | `String` | Full name — `"Fulano de Tal"` |
| `nameUpper` | `String` | Full name in uppercase |
| `gender` | `String` | `"M"` or `"F"` |
| `birthDate` | `String` | Date of birth — `"DD/MM/YYYY"` |
| `day` | `Integer` | Birth day |
| `month` | `Integer` | Birth month |
| `year` | `Integer` | Birth year |

---

## Error Handling

```ruby
require 'cpfhub'

client = CPFHub::Client.new(api_key: 'YOUR_API_KEY')

begin
  result = client.lookup('00000000000')
  puts result['name']
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

Check the `examples/` directory for sample usage:

- [simple_lookup.txt](examples/simple_lookup.txt)
- [real_world_onboarding.txt](examples/real_world_onboarding.txt)

### Ruby (plain)

```ruby
require 'cpfhub'
client = CPFHub::Client.new(api_key: ENV['CPFHUB_API_KEY'], timeout: 5)
result = client.lookup('00000000000')
puts result['name']
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
    render json: { name: result['name'], gender: result['gender'] }
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
    User.find(user_id).update!(verified_name: result['name'])
  end
end
```

---

## Rate Limits

| Plan | Limit |
|---|---|
| Free | 1 request every 2 seconds · 50 requests/month |
| Pro | 1 request per second · 1,000 requests/month |
| Corporate | Custom |

The SDK automatically retries on `429` with exponential backoff (up to 3 attempts).

---

## Plans & Pricing

| Plan | Price | Included | Extra |
|------|-------|----------|-------|
| **Free** | R$ 0/month | 50 lookups | — |
| **Pro** | R$ 149/month | 1,000 lookups | R$ 0,15/lookup |
| **Corporate** | Custom | Custom | Custom |

[View full pricing at cpfhub.io →](https://cpfhub.io#pricing)

---

## Requirements

- Ruby 3.0+
- `faraday` >= 2.0 — installed automatically

---

## Links

- [Documentation](https://cpfhub.io/documentacao)
- [Dashboard](https://app.cpfhub.io)
- [RubyGems](https://rubygems.org/gems/cpfhub)
- [Status Page](https://app.cpfhub.io/status)
- [Pricing](https://cpfhub.io#pricing)
- [LGPD Compliance](https://cpfhub.io/lgpd)
- [OpenAPI Specification](https://github.com/cpfhub/cpfhub-openapi/blob/main/openapi.yaml)
- [MCP Server (AI Agents)](https://github.com/cpfhub/cpfhub-mcp)

---

## License

MIT © [CPFHub.io](https://cpfhub.io)

---

# Português

[🇺🇸 English](#cpfhub-ruby-sdk-for-cpfhubio) | 🇧🇷 **Português**

**SDK Ruby oficial para [CPFHub.io](https://cpfhub.io) — API de Consulta de CPF Brasileiro**

---

## O que é o CPFHub.io?

O CPFHub.io é uma API REST que retorna nome, gênero e data de nascimento de qualquer CPF brasileiro — em ~300ms, com 99,9% de uptime e total conformidade com a LGPD.

**10M+ CPFs consultados · 1.300+ empresas ativas · 99,9% uptime**

---

## Instalação

```bash
gem install cpfhub
```

Ou adicione ao seu `Gemfile`:

```ruby
gem 'cpfhub'
```

---

## Início Rápido

```ruby
require 'cpfhub'

client = CPFHub::Client.new(api_key: 'SUA_CHAVE_DE_API')

result = client.lookup('00000000000')

puts result['name']       # "Fulano de Tal"
puts result['gender']     # "M"
puts result['birthDate']  # "15/06/1990"
```

Obtenha sua chave de API gratuita em [app.cpfhub.io](https://app.cpfhub.io) — sem cartão de crédito.

---

## Exemplo curl

```bash
curl -X GET "https://api.cpfhub.io/cpf/12345678909" \
  -H "x-api-key: SUA_CHAVE_DE_API"
```

**Resposta:**

```json
{
  "success": true,
  "data": {
    "cpf": "12345678909",
    "name": "Fulano de Tal",
    "nameUpper": "FULANO DE TAL",
    "gender": "M",
    "birthDate": "15/06/1990",
    "day": 15,
    "month": 6,
    "year": 1990
  }
}
```

---

## Referência da API

### `CPFHub::Client.new(api_key:, timeout: 10, base_url: nil)`

| Parâmetro | Tipo | Padrão | Descrição |
|-----------|------|--------|-----------|
| `api_key` | `String` | obrigatório | Sua chave de API do CPFHub |
| `timeout` | `Integer` | `10` | Timeout da requisição em segundos |
| `base_url` | `String` | `https://api.cpfhub.io` | URL base da API |

### `client.lookup(cpf) -> Hash`

Consulta um CPF e retorna os dados de identidade associados.

Aceita CPF com ou sem formatação (`000.000.000-00` ou `00000000000`).

#### Chaves do hash de resposta

| Chave | Tipo | Descrição |
|-------|------|-----------|
| `cpf` | `String` | CPF (apenas dígitos) |
| `name` | `String` | Nome completo — `"Fulano de Tal"` |
| `nameUpper` | `String` | Nome completo em maiúsculas |
| `gender` | `String` | `"M"` ou `"F"` |
| `birthDate` | `String` | Data de nascimento — `"DD/MM/YYYY"` |
| `day` | `Integer` | Dia de nascimento |
| `month` | `Integer` | Mês de nascimento |
| `year` | `Integer` | Ano de nascimento |

---

## Tratamento de Erros

```ruby
require 'cpfhub'

client = CPFHub::Client.new(api_key: 'SUA_CHAVE_DE_API')

begin
  result = client.lookup('00000000000')
  puts result['name']
rescue CPFHub::Error => e
  puts "Erro #{e.status_code}: #{e.message}"
  # 400 — Formato de CPF inválido
  # 401 — Chave de API inválida ou ausente
  # 404 — CPF não encontrado
  # 429 — Limite de requisições excedido
  # 500 — Erro no servidor
  # 503 — Serviço temporariamente indisponível
end
```

---

## Exemplos

Veja o diretório `examples/` para exemplos de uso:

- [simple_lookup.txt](examples/simple_lookup.txt)
- [real_world_onboarding.txt](examples/real_world_onboarding.txt)

### Ruby puro

```ruby
require 'cpfhub'
client = CPFHub::Client.new(api_key: ENV['CPFHUB_API_KEY'], timeout: 5)
result = client.lookup('00000000000')
puts result['name']
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
    render json: { name: result['name'], gender: result['gender'] }
  end
end
```

### Sidekiq (job em background)

```ruby
class CpfVerificationWorker
  include Sidekiq::Worker

  def perform(user_id, cpf)
    client = CPFHub::Client.new(api_key: ENV['CPFHUB_API_KEY'])
    result = client.lookup(cpf)
    User.find(user_id).update!(verified_name: result['name'])
  end
end
```

---

## Limites de Requisição

| Plano | Limite |
|---|---|
| Gratuito | 1 requisição a cada 2 segundos · 50 requisições/mês |
| Pro | 1 requisição por segundo · 1.000 requisições/mês |
| Corporativo | Personalizado |

O SDK faz retry automático no erro `429` com backoff exponencial (até 3 tentativas).

---

## Planos e Preços

| Plano | Preço | Incluído | Extra |
|-------|-------|----------|-------|
| **Gratuito** | R$ 0/mês | 50 consultas | — |
| **Pro** | R$ 149/mês | 1.000 consultas | R$ 0,15/consulta |
| **Corporativo** | Personalizado | Personalizado | Personalizado |

[Ver preços completos em cpfhub.io →](https://cpfhub.io#pricing)

---

## Requisitos

- Ruby 3.0+
- `faraday` >= 2.0 — instalado automaticamente

---

## Links

- [Documentação](https://cpfhub.io/documentacao)
- [Dashboard](https://app.cpfhub.io)
- [RubyGems](https://rubygems.org/gems/cpfhub)
- [Página de Status](https://app.cpfhub.io/status)
- [Preços](https://cpfhub.io#pricing)
- [Conformidade LGPD](https://cpfhub.io/lgpd)
- [Especificação OpenAPI](https://github.com/cpfhub/cpfhub-openapi/blob/main/openapi.yaml)
- [Servidor MCP (Agentes de IA)](https://github.com/cpfhub/cpfhub-mcp)

---

## Licença

MIT © [CPFHub.io](https://cpfhub.io)
