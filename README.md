# Rick and Morty App — Flutter

Aplicativo Flutter que consome a [Rick and Morty API](https://rickandmortyapi.com) e exibe informações sobre episódios e personagens, desenvolvido com **Clean Architecture**, **BLoC** e boas práticas de engenharia de software.

---

## 📱 Funcionalidades

- **Tela Home** com exibição do episódio em destaque (ep. 28 — *The Ricklantis Mixup*)
- **Listagem de personagens** do episódio em ordem alfabética, com avatar, status de vida e localização
- **Sistema de Mocks** completo: o app funciona offline com dados reais pré-configurados, sem necessidade de backend

---

## 🏗️ Arquitetura

O projeto adota **Clean Architecture** com separação estrita em três camadas por feature. A regra de dependência flui exclusivamente de fora para dentro:

```
lib/
 ├─ core/                        # Infraestrutura compartilhada
 │   ├─ services/                # ApiService (HTTP), ApiEndpoints (enum centralizado)
 │   ├─ helpers/                 # EnvironmentHelper, MockHelper
 │   ├─ routes/                  # Roteamento centralizado (RoutesList enum + getRoute)
 │   ├─ errors/                  # Failure hierarchy (TimeoutFailure, SessionExpiredFailure...)
 │   └─ usecases/                # Contrato base UseCase<Type, Params> e NoParams
 │
 └─ features/
     └─ home/
         ├─ domain/              # Epsode, CharacterEntity, HomeRepository, 3 UseCases
         ├─ data/                # EpsodeModel, CharacterModel, HomeDatasource
         └─ presentation/        # HomeBloc, HomeScreen, CharactersScreen, Widgets
```

### Decisões de design relevantes

| Decisão | Rationale |
|---|---|
| **Datasource extends Repository** | Elimina uma camada de indireção desnecessária sem violar Clean Architecture — o Repository abstrato define o contrato, o Datasource o implementa diretamente |
| **Parsing de URLs no Model** | `EpsodeModel.fromMap` extrai os IDs inteiros das URLs de personagens (`/character/1` → `1`). A entidade de domínio já entrega `List<int>` — a camada de apresentação não conhece o formato da API |
| **IDs dinâmicos no endpoint** | `/character/1,2,3` é montado no Datasource; o enum `ApiEndpoints` registra apenas `/character`. Nenhum ID fica hardcoded fora da camada de dados |
| **MockHelper por prefixo** | `/episode/28` e `/character/1,2,3` são rotas dinâmicas — o mock intercepta por prefixo (`startsWith`) em vez de match exato, filtrando os dados pelo conjunto de IDs solicitados |
| **BLoC único compartilhado** | `HomeBloc` gerencia três eventos independentes (`LoadHomeTransactions`, `LoadEpsode`, `LoadCharacters`). Cada `BlocBuilder`/`BlocConsumer` usa `buildWhen` para reagir apenas aos seus próprios estados, sem acoplamento |

---

## ⚙️ Como rodar o projeto

### Pré-requisitos

- [FVM (Flutter Version Manager)](https://fvm.app) instalado globalmente
- Flutter **3.41.6** (gerenciado via FVM — veja abaixo)

### 1. Instalar o FVM

```bash
# via Homebrew (macOS)
brew tap leoafarias/fvm
brew install fvm

# ou via pub global
dart pub global activate fvm
```

### 2. Clonar e configurar o SDK

```bash
git clone <url-do-repositorio>
cd flutter-rick-and-morty-app

# Instala a versão correta do Flutter definida no .fvmrc e cria o link simbólico
fvm use

# Instala as dependências do projeto
fvm flutter pub get
```

> **⚠️ Atenção ao clonar/duplicar o projeto**
>
> O diretório `.fvm/` contém um **link simbólico** (`flutter_sdk`) que aponta para o cache do FVM na sua máquina. Este symlink **não é transferível** — ao clonar ou copiar o projeto, é obrigatório rodar `fvm use` antes de qualquer outro comando. Sem isso, o Dart do sistema será usado, e o `pub get` falhará com erro de versão de SDK incompatível.

### 3. Configurar o `.env`

O arquivo `.env` já está presente na raiz do projeto com as configurações para rodar localmente:

```env
API_BASE_URL=https://rickandmortyapi.com/api
USE_MOCK=true
```

> `USE_MOCK=true` faz o app utilizar dados mockados sem depender de conexão com a internet.
> Altere para `false` para consumir a API real.

### 4. Rodar o app

```bash
fvm flutter run
```

---

## 📦 Dependências

| Pacote | Uso |
|---|---|
| `flutter_bloc` | Gerenciamento de estado com BLoC pattern |
| `equatable` | Comparação estrutural de entidades e estados |
| `dartz` | Tipos funcionais — `Either<Failure, Success>` nos UseCases |
| `http` | Cliente HTTP para chamadas à API |
| `flutter_dotenv` | Leitura do arquivo `.env` em tempo de execução |
| `intl` | Formatação de moeda e datas (localização pt-BR) |

---

## 🧪 Testes

```bash
fvm flutter test
```

Os testes cobrem as camadas de **Domain** e **Data** da feature `home`, utilizando injeção de dependência para isolar datasources sem dependências externas de mocking.

---

## 📁 Configuração do VSCode

Para que o IntelliSense e o debugger do VSCode utilizem o SDK correto gerenciado pelo FVM, adicione ao `.vscode/settings.json`:

```json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk",
  "dart.sdkPath": ".fvm/flutter_sdk/bin/cache/dart-sdk"
}
```

> Este arquivo já está configurado no repositório. Caso o VSCode não reconheça o SDK automaticamente após o `fvm use`, reinicie o editor.

---

## 🔁 Fluxo de dados

```
UI (Widget)
  → BLoC.add(Event)
    → UseCase(Params)
      → Repository (contrato)
        → Datasource (implementação)
          → ApiService → MockHelper (USE_MOCK=true) | API real (USE_MOCK=false)
            → Model.fromMap(response)
              → Entity (domínio puro)
                → BLoC.emit(State)
                  → BlocBuilder → UI atualizada
```