---
description: Regras gerais de código, arquitetura limpa e padrões de UI
---

##Princípios Chave
- **Escreva código Dart conciso e técnico, com exemplos precisos.**
- **Use padrões de programação funcional e declarativa quando apropriado.**
- **Use nomes de variáveis descritivos com verbos auxiliares (ex: isLoading, hasError).**
- **Estruture os arquivos em: widget exportado, subwidgets, helpers, conteúdo estático, tipos.**
- **Utiliza Portugês do Brasil para documentação e inglês para nome de classes, variáveis, funções, métodos, etc.**

## Dart/Flutter
- **Utilize o padrão de arquitetura limpa (Clean Architecture) para o desenvolvimento do app.**
- **Utilize Bloc para gerenciamento de estado.**
- **Use construtores const para widgets imutáveis.**
- **Use sintaxe arrow para funções e métodos simples.**
- **Prefira corpos de expressão para getters e setters de uma linha.**
- **Use vírgulas finais para melhor formatação e revisão de código.**
- **Use const ao invés de final para variáveis inicializadas com valores constantes (ex: const mockData = Fixture.data ao invés de final mockData = Fixture.data).**

## Camada de Data
- **Use o padrão de implementação de DataSources encontrado no @WithdrawDatasource.**
- **Use o padrão de implementação de Models encontrados no @lib/features/withdraw/data/models.**
- **Sempre implemente tratamento de erro com try-catch nos DataSources.**
- **Use FirebaseCrashlytics.recordError() para registrar erros e stackTrace.**
- **Use log() ao invés de print() para logs de debug nos DataSources.**

## Camada de Domain
- **Use o padrão de implementação de Entities encontrados no @lib/features/withdraw/domain/entities.**
- **Use o padrão de implementação de Repositories encontrados no @lib/features/withdraw/domain/repositories.**
- **Use o padrão de implementação de UseCases encontrados no @lib/features/withdraw/domain/usecases.**
- **Sempre retorne Either<Failure?, T> nos métodos dos repositories.**

## Camada de Presentation
- **Use o padrão de implementação de Bloc encontrados no @lib/features/withdraw/presentation/bloc.**
- **Use o padrão de implementação de Eventos do Bloc encontrados no @lib/features/withdraw/presentation/bloc/withdraw_event.dart.**
- **IMPORTANTE: Para Events do Bloc, diferente dos States, eventos com propriedades DEVEM incluir essas propriedades nos props para permitir comparação de igualdade (evitando processamento duplicado de eventos iguais).**
- **Use o padrão de implementação de Estados do Bloc encontrados no @lib/features/withdraw/presentation/bloc/withdraw_state.dart.**
- **Sempre implemente estados específicos para Loading, Error e Success.**
- **Use buildWhen e listenWhen nos BlocBuilder e BlocListener para otimizar rebuilds.**
- **IMPORTANTE: Na classe abstrata dos States do Bloc, implemente `List<Object> get props => [identityHashCode(this)];` para garantir que todas as instâncias sejam únicas, mesmo states sem atributos.**
- **IMPORTANTE: Classes de estados do Bloc NÃO devem ter construtores `const` - isso garante que instâncias diferentes sejam criadas e `identityHashCode(this)` funcione corretamente.**
- **IMPORTANTE: States do Bloc que possuem atributos/propriedades DEVEM sobrescrever a propriedade props incluindo todos os atributos para permitir comparação adequada baseada nos valores (ex: `List<Object> get props => [attribute1, attribute2];`). States sem atributos podem usar apenas a implementação da classe base com `identityHashCode(this)`.**
- **IMPORTANTE: Classes de estados do Bloc sem atributos próprios NÃO devem sobrescrever a propriedade props, pois herdam automaticamente o comportamento da classe abstrata que já implementa `identityHashCode(this)`. Apenas sobrescreva props em classes com atributos específicos.**

## Camada de Services
- **Use o padrão de implementação de ApiService encontrados no @lib/core/services/api_service.dart.**
- **Sempre passe devLog e currentStackTrace nas chamadas do ApiService.**

## Tratamento de Erros e Validação
- **Implemente tratamento de erros para TimeoutFailure, UserSessionFailure, OfflineFailure, ErrorFailure, como é feito na @WalletInitialScreen.**
- **Quando ocorrer UserSessionFailure, o usuário deve ser deslogado, utilizando RoutesList.ExpiredSessionScreen.routeName.**
- **Implemente tratamento de erros nas views utilizando o widget @StandardErrorUi quando houver rebuild da tela.**
- **Use SnackBar @UiUtils.showSnackBarBlack quando não houver rebuild da tela.**
- **Para erros positivos/negativos, use @UiUtils.showSnackBarPositiveOrNegative com ShowSnackBarColorType.**

## Navegação e Rotas
- **Use @lib/core/routes/routes_list.dart (enum RoutesList) para todas as navegações.**
- **Sempre use Navigator.of(context).pushNamed() com RoutesList.NomeScreen.routeName.**
- **Para navegação com argumentos, crie classes Args específicas (ex: ProductDetailAffiliateScreenArgs).**

## Gerenciamento de Estado Local
- **Use SharedPreferencesHelper.instance com SharedPreferencesHelperKeys enum para persistência.**
- **Use SecureStorageHelper para dados sensíveis como tokens.**
- **Para estados loading, use variáveis booleanas privadas (ex: _isShowingLoading).**

## Gravação de logs de erros e Analytics
- **Use Firebase Crashlytics para gravar logs de erros, como pode ser visto no @lib/core/services/api_service.dart.**
- **Use AnalyticsHelper.instance.sendAnalyticsEvent() com AnalyticsEvents constants.**

## Otimização de Performance
- **Use widgets const sempre que possível para otimizar rebuilds.**
- **Implemente otimizações em listas (ex: ListView.builder).**
- **Use AssetImage para imagens estáticas e cached_network_image para imagens remotas.**

## Convenções Principais
- **Prefira widgets stateless:**
  - **Use BlocBuilder para widgets que dependem do estado do Cubit/Bloc.**
  - **Use BlocListener para tratar efeitos colaterais, como navegação ou exibição de diálogos.**
  - **Use BlocConsumer quando precisar tanto de listener quanto builder.**

## UI e Estilo
- **Use widgets nativos do Flutter e crie widgets personalizados.**
- **Use temas para manter o estilo consistente em todo o app.**
- **Use AppLocalizations.of(context).translate() para todas as strings.**
- **Use AppStyles para estilos de texto consistentes.**
- **Use Theme.of(context).extension<TextColors>() para cores de texto.**

## Widgets e Componentes de UI
- **Crie classes de widget pequenas e privadas, em vez de métodos como Widget _build...**
- **Implemente RefreshIndicator para funcionalidade de pull-to-refresh.**
- **Em TextFields, defina textCapitalization, keyboardType e textInputAction apropriados.**
- **Sempre inclua um errorBuilder ao usar Image.network.**
- **Use CustomButton ao invés de botões nativos para consistência.**
- **Use ProgressUtils.showCircularIndicator() para loading modals.**

## Conectividade e Offline
- **Sempre verifique conectividade com ConnectivityHelper.isConnectionDown() antes de chamadas de API.**
- **Implemente estados específicos para erro offline (ex: ErrorOfflineState).**

## Autenticação e Sessão
- **Use SessionHelper.instance para gerenciar dados da sessão do usuário.**
- **Use BiometricHelper para autenticação biométrica.**
- **Sempre trate UserSessionFailure redirecionando para ExpiredSessionScreen.**

## Internacionalização
- **Use AppLocalizations.of(context).translate() para todas as strings visíveis.**
- **Mantenha as chaves de tradução em snake_case.**

## Testes Unitários de UseCase
- **IMPORTANTE: Testes de UseCase devem usar o DataSource diretamente ao invés de mockar o Repository:**
  ```dart
  // ✅ Correto - Usando DataSource
  late SettingsDataSource dataSource;
  late PostDeviceUpdateSettingsUseCase useCase;

  setUp(() {
    dataSource = SettingsDataSource(
      apiService: apiServiceMock,
      firebaseCrashlytics: firebaseCrashlyticsMock,
      deviceHelper: deviceHelperMock,
    );
    useCase = PostDeviceUpdateSettingsUseCase(repository: dataSource);
  });

  // ❌ Evitar - Usando mock do Repository
  late SettingsRepositoryMock repositoryMock;
  late PostDeviceUpdateSettingsUseCase useCase;

  setUp(() {
    repositoryMock = SettingsRepositoryMock();
    useCase = PostDeviceUpdateSettingsUseCase(repository: repositoryMock);
  });
  ```

- **Estrutura obrigatória para testes de UseCase:**
  1. **Mocks necessários:**
     - ApiServiceMock para simular chamadas da API
     - FirebaseCrashlyticsMock para logs de erro
     - DeviceHelperMock para dados do dispositivo
     - Outros mocks específicos conforme necessidade do DataSource

  2. **Configuração no setUp:**
     - Inicializar todos os mocks
     - Criar DataSource com os mocks
     - Criar UseCase com o DataSource
     - Resetar mocks com reset()
     - Configurar setupDefaults dos mocks
     - Configurar deviceId mock

  3. **Grupos de teste obrigatórios:**
     - Success cases: retorno bem sucedido
     - Error cases: 
       - Left(null) para erro genérico
       - TimeoutFailure para timeout
       - UserSessionFailure para sessão expirada
     - Params: validação dos parâmetros

  4. **Verificações obrigatórias:**
     - Verificar retorno (isRight/isLeft)
     - Verificar valor retornado
     - Verificar chamadas do deviceHelper
     - Verificar chamadas do apiService
     - Usar verifyNoMoreInteractions

  5. **Dados de teste:**
     - Usar fixtures existentes ao invés de dados inline
     - Seguir formato da API nas respostas mock
     - Usar dados realistas nos parâmetros
     - Testar variações de parâmetros

- **IMPORTANTE: Não criar mocks desnecessários. Se o UseCase depende do Repository e o Repository é implementado pelo DataSource, usar o DataSource diretamente.**

- **IMPORTANTE: Sempre verificar a implementação do DataSource para entender quais mocks são necessários e como estruturar os dados de teste.**

## Testes Unitários e Mocks
## IMPORTANTE: Nunca crie novos helpers de teste. Use sempre os helpers existentes na pasta @/test/core/helpers:

## IMPORTANTE: Em testes unitários, o reset() dos mocks deve ser feito no tearDown() e não no setUp():
```dart
setUp(() {
  apiServiceMock = ApiServiceMock();
  firebaseCrashlyticsMock = FirebaseCrashlyticsMock();
  // configuração inicial...
});

tearDown(() {
  reset(apiServiceMock);
  reset(firebaseCrashlyticsMock);
});
```

## Razões para usar reset() no tearDown:
- Garante que o estado dos mocks seja limpo mesmo se um teste falhar
- Mantém o setUp() focado apenas na configuração inicial necessária
- Segue o princípio de "limpar após usar" ao invés de "limpar antes de usar"
- Padrão recomendado pela comunidade Flutter/Dart
- **Use padrão AAA (Arrange, Act, Assert) em todos os testes.**
- **Use blocTest para testar Blocs.**
- **Use Mocktail para mocks.**
- **IMPORTANTE: Sempre que for testar igualdade de states, entities ou models (ou qualquer classe que sobrescreva props ou operator==), utilize obrigatoriamente a função auxiliar HelpersTestUtils.testObjectEquality para garantir padronização, evitar duplicação de código e cobrir todos os aspectos de igualdade (==, hashCode).**
- **IMPORTANTE: Para criar respostas de API em testes, sempre use os métodos utilitários do ApiServiceMock ao invés de criar ApiResponse diretamente:**
  - **Use createSuccessResponse() para respostas de sucesso com dados**
  - **Use createErrorResponse() para respostas de erro genérico**
  - **Use createTimeoutResponse() para respostas de timeout**
  - **Use createUserSessionErrorResponse() para respostas de erro de sessão**
- **Crie funções auxiliares locais apenas quando forem usadas 2 ou mais vezes. Funções auxiliares usadas uma única vez devem ser inline diretamente no teste.**
- **IMPORTANTE: Sempre dar preferência aos helpers da pasta @/test/core/helpers e seus métodos setupDefaults() para configurar mocks. Apenas use helpers específicos da feature quando a funcionalidade não existir nos helpers centrais.**
- **IMPORTANTE: Evite chamadas redundantes de configuração de mocks. Se setupDefaults() já configura um comportamento padrão (ex: conexão online), não repita essa configuração nos testes individuais.**

## Testes Unitários de Bloc - Boas Práticas Específicas
- **Sempre use `blocTest` ao invés de `test` manual para testes de Bloc.**
- **Use `reset()` em `setUp()` para garantir estado limpo entre testes: `reset(repositoryMock); reset(helperMock);`**
- **Use `seed:` em `blocTest` para testar com estados iniciais específicos (especialmente útil para testes de ações).**
- **Organize testes em grupos por funcionalidade: `group('LoadSentRequest', () {...})`**
- **Implemente seção `verify:` em todos os `blocTest` para verificar side effects.**
- **Sempre use `verify()` para verificar que métodos foram chamados com parâmetros corretos.**
- **Sempre use `verifyNoMoreInteractions()` para garantir que nenhuma chamada não esperada foi feita.**
- **Verifique parâmetros específicos nas chamadas: `verify(() => repo.method(param: expectedValue)).called(1);`**
- **Verifique o estado final detalhadamente no bloco `verify:`**
- **Crie grupo específico 'Edge Cases and Error Handling' para cenários extremos e tratamento de erros.**
- **Teste todos os cenários: success, error, offline, timeout, session expired, empty data.**
- **Use nomes descritivos explicando cenário e resultado esperado: 'should emit LoadingState and LoadedState when loading data successfully'**
- **Para testes de ações (approve, refuse, cancel), use `seed:` para definir estado inicial da lista.**
- **Configure todos os mocks necessários no bloco `build:` do `blocTest`.**
- **Use `when().thenAnswer((_) async => result)` para comportamentos assíncronos.**
- **Após finalizar todos os testes unitários do Bloc e garantir que todos passem com sucesso, revise o código e crie funções auxiliares para mocks que se repetem 2 ou mais vezes no arquivo de teste (ex: mockOnlineConnection(), mockOfflineConnection(), mockDatabaseSave()), seguindo o padrão estabelecido em @affiliation_bloc_test.dart.**
- **Use matchers específicos ao invés de equals() genérico:**
  - **Booleanos: isTrue/isFalse ao invés de equals(true)/equals(false)**
  - **Null: isNull/isNotNull ao invés de equals(null)**
  - **Tipos: isA<T>() para verificar tipos específicos**
  - **Coleções: isEmpty/isNotEmpty, hasLength(n), contains(item)**
  - **Strings: startsWith(), endsWith(), contains(), matches() para regex**
  - **Números: greaterThan(), lessThan(), closeTo() para valores com tolerância**
  - **Exceções: throwsA(), throwsException(), throwsArgumentError()**
  - **Mocks: called(), never, calledOnce ao invés de times(1)**
- **Teste todos os estados possíveis dos Blocs (Loading, Success, Error).**
- **Títulos de testes devem ser em inglês americano, com linguagem simples e direta (ex: "should return valid data when login is successful").**
- **Para testes de Bloc, use formato descritivo explicando o cenário completo: "should emit LoadingState and LoadedState when loading data successfully"**
- **Organize testes de Bloc em grupos por evento: `group('LoadSentRequest', () {})`, `group('ApproveRequest', () {})`**
- **Para cada grupo de evento, teste no mínimo: success, error, offline, e cenários de negócio específicos.**
- **Use sufixo descritivo nos grupos de edge cases: `group('Edge Cases and Error Handling', () {})`**
- **IMPORTANTE: Somente em testes de estados do Bloc, use `final` ao invés de `const` nas declarações (ex: `final state = LoadingState();`) pois as classes não possuem construtores const.**
- **Para criar ou refatorar testes unitários, use @helpers_test_utils.dart, @api_service_mock.dart, os mocks da pasta /test/core/helpers e arquivos com final fixture.dart.**
- **IMPORTANTE: Sempre use fixtures existentes ao invés de criar dados mock hardcoded inline nos testes. Use AffiliationRequestEntityFixture para dados de afiliação, MenuTestHelpers para dados de usuário e avatar, e outros fixtures específicos do projeto.**
- **Caso não houver mocks e funções auxiliares já criados no projeto, pode criar novos mocks e funções auxiliares.**
- **Os novos mocks e funções auxiliares podem usar os mocks e funções auxiliares existentes para uso interno, evitando código repetido.**
- **Siga as boas práticas estabelecidas no projeto e pergunte em caso de dúvidas.**
- **Separe testes de comportamento (expect) e interação (verify) em testes diferentes:**
  - **Teste de comportamento: Verifica o que o método retorna (usando expect)**
  - **Teste de interação: Verifica como o método interage com dependências (usando verify)**
  - **Exceção: Use expect e verify no mesmo teste apenas quando verificar que uma dependência NÃO foi chamada**
- **Para testes de Bloc, combine verificação de comportamento (expect) e interação (verify) no mesmo teste usando o bloco `verify:` do `blocTest`.**

## Estrutura de Testes de Bloc
- **Use a seguinte estrutura consistente em todos os `blocTest`:**
  ```dart
  blocTest<BlocClass, StateClass>(
    'should emit [ExpectedState1, ExpectedState2] when action occurs',
    seed: () => InitialState(), // opcional, para estados iniciais específicos
    build: () {
      // Arrange - configurar mocks
      when(() => mock.method()).thenAnswer((_) async => result);
      return bloc;
    },
    act: (bloc) => bloc.add(EventClass()),
    expect: () => [
      isA<ExpectedState1>(),
      isA<ExpectedState2>(),
    ],
    verify: (bloc) {
      // Verificar side effects
      verify(() => mock.method()).called(1);
      verifyNoMoreInteractions(mock);
      
      // Verificar estado final
      final state = bloc.state as ExpectedState2;
      expect(state.property, expectedValue);
    },
  );
  ```
- **Sempre configure `reset()` no `setUp()` para limpar estado dos mocks entre testes.**
- **Configure mocks no `build:` e nunca no `setUp()` ou `setUpAll()` para testes de Bloc.**
- **Use `isA<StateType>()` ao invés de instâncias específicas no `expect:` para melhor flexibilidade.**

## Estrutura de Organização de Testes
- **Organize a estrutura de testes espelhando a estrutura da pasta /lib.**
- **Crie um arquivo de mock específico para cada classe (ex: connectivity_helper_mock.dart).**
- **Crie um arquivo de fixture específico para cada classe (ex: user_login_data_fixture.dart).**
- **Use @test/test_helpers.dart para funções auxiliares globais usadas em múltiplas features.**
- **Use @test/features/[feature]/[feature]_test_helpers.dart para funções auxiliares específicas de uma feature.**

## Padrões de Nomenclatura para Testes
- **Use sufixo _mock.dart para arquivos de mock: connectivity_helper_mock.dart, api_service_mock.dart.**
- **Use sufixo _fixture.dart para arquivos de fixture: user_login_data_fixture.dart, api_response_fixture.dart.**
- **Use sufixo _test_helpers.dart para arquivos de funções auxiliares: login_test_helpers.dart.**
- **Use sufixo Mock para classes de mock: ConnectivityHelperMock, ApiServiceMock.**
- **Use sufixo Fake para classes fake: BuildContextFake, ApiRequestFake.**
- **Use sufixo Fixture para classes de fixture: UserLoginDataFixture.**
- **Para variáveis mock, use sufixo Mock: apiServiceMock, firebaseCrashlyticsMock.**
- **Para dados de teste, use nomes descritivos ao contexto: successResponse, errorResponse, invalidDataResponse.**
- **IMPORTANTE: Variáveis de mock devem seguir o padrão camelCase do tipo da classe: `late BankingAccountRepositoryMock bankingAccountRepositoryMock`, `late ConnectivityHelperMock connectivityHelperMock`.**
- **Quando um item de lista for acessado múltiplas vezes, extraia-o para uma variável com nome descritivo (ex: requestItem, [runtimeType]Item).**
- **Prefira .first ao invés de [0] para acessar o primeiro item - é mais seguro e expressivo.**
- **IMPORTANTE: Nomes de métodos em fixtures devem refletir o estado do objeto e serem genéricos para permitir reutilização:**
  ```dart
  // ✅ Correto - Nomes refletem estado do objeto
  static Entity createWithDefaultData()
  static Entity createWithEmptyData()
  static Entity createWithCustomData()
  static Entity createWithFullData()
  static Entity createWithPartialData()
  static Entity createWithInvalidData()
  
  // ❌ Evitar - Nomes muito específicos ou pouco descritivos
  static Entity createFromApi()
  static Entity createDifferent()
  static Entity create()
  static Entity createCustom()
  ```

## Organização de Mocks
- **Crie mocks específicos por classe em arquivos separados espelhando a estrutura de /lib.**
- **Implemente métodos setupDefaults() estáticos nos mocks para configuração padrão.**
- **Use registerFallbackValue() para tipos complexos que precisam de fallback.**
- **Configure mocks no setUpAll() para dados que não mudam entre testes.**
- **Use setUp() para configurações que precisam ser resetadas a cada teste.**

## Verificação de Parâmetros e Interações em Testes de Bloc
- **Sempre verifique parâmetros específicos nas chamadas de método ao invés de usar `any()`:**
  ```dart
  // ✅ Correto - verificar parâmetros específicos
  verify(() => repository.getItems(page: '1', status: 'active')).called(1);
  
  // ❌ Evitar - usar any() genérico
  verify(() => repository.getItems(page: any(named: 'page'))).called(1);
  ```
- **Verifique o número exato de chamadas para cada mock: `.called(1)`, `.called(2)`, `never`**
- **Use `verifyInOrder()` quando a ordem das chamadas for importante.**
- **Para testes de Bloc com múltiplas dependências, verifique todas em sequência:**
  ```dart
  verify(() => connectivityHelper.isConnectionDown()).called(1);
  verify(() => repository.getData()).called(1); 
  verify(() => databaseHelper.save()).called(1);
  verifyNoMoreInteractions(connectivityHelper);
  verifyNoMoreInteractions(repository);
  verifyNoMoreInteractions(databaseHelper);
  ```
- **Configure todos os mocks necessários mesmo se não forem usados em cenários offline/erro.**

## Organização de Fixtures
- **Crie fixtures específicos por classe em arquivos separados espelhando a estrutura de /lib.**

- **IMPORTANTE: Para fixtures de models:**
  ```dart
  /// Fixture para testes do MyModel
  class MyModelFixture {
    /// Gera um Map com dados válidos para o MyModel
    static const Map<String, dynamic> validData = {
      'id': '123',
      'name': 'Test Name',
      'value': 'R$ 1.000,00',
    };

    /// Gera um Map com dados inválidos para o MyModel
    static const Map<String, dynamic> invalidData = {
      'id': 'invalid',
      'name': null,
      'value': 'invalid',
    };
  }
  ```
## Regras:
  1. **Use `static const Map<String, dynamic>` para todos os dados**
  2. **Mantenha os dados hard coded inline exatamente como vêm da API**
  3. **Nomeie os métodos seguindo o padrão:**
     - `validData` para dados válidos padrão
     - `invalidData` para dados inválidos
     - `customData` para variações específicas
  4. **Documente cada método explicando seu propósito**
  5. **Mantenha os dados realistas, copiados diretamente da API**
  6. **Use valores formatados como na API (ex: 'R$ 1.000,00' ao invés de '1000.00')**
  7. **Não crie métodos intermediários ou helpers - mantenha os dados diretos**

- **IMPORTANTE: Para fixtures de entities:**
  ```dart
  /// Fixture para testes do MyEntity
  class MyEntityFixture {
    /// Instância base para comparação
    static const MyEntity baseInstance = MyEntity(
      value: 1000.00,
      type: Type.DEFAULT,
    );

    /// Instância com as mesmas propriedades
    static const MyEntity instanceWithSameProps = MyEntity(
      value: 1000.00,
      type: Type.DEFAULT,
    );

    /// Instância com propriedades diferentes
    static const MyEntity instanceWithDifferentProps = MyEntity(
      value: 2000.00,
      type: Type.OTHER,
    );
  }
  ```

## Regras:
  1. **Use `static const` para todas as instâncias**
  2. **Nomeie as instâncias seguindo o padrão:**
     - `baseInstance` para instância base de comparação
     - `instanceWithSameProps` para instância com mesmas propriedades
     - `instanceWithDifferentProps` para instância com propriedades diferentes
  3. **IMPORTANTE: Se a entity tem model correspondente, sempre dever usar os dados do model fixture:**
     ```dart
     static const MyEntity baseInstance = MyEntityModel.fromApi(
       map: MyModelFixture.validData,
     );
     ```
  4. **Documente cada instância explicando seu propósito**
  5. **Mantenha os dados realistas e consistentes com o model fixture**
  6. **Não crie métodos - use apenas instâncias const**
    ```
     // ❌ Evitar - Valor usado apenas uma vez
     static const defaultType = Type.DEFAULT; // Deveria estar direto na instância
     ```
  7. **Use construtores const para instâncias de entidades quando possível:**
     ```dart
     static Entity createBaseInstance() => const Entity(
       value: defaultValue,
       type: defaultType,
     );
     ```
  8. **Prefira propriedades const sobre métodos de factory quando os valores são estáticos:**
     ```dart
     // ✅ Correto - Usando const
     static const defaultData = {
       'key': 'value',
       'amount': 1000.00,
     };
     
     // ❌ Evitar - Usando método
     static Map<String, dynamic> getDefaultData() => {
       'key': 'value',
       'amount': 1000.00,
     };
     ```
  9. **Use factory methods (não const) apenas quando precisar de valores dinâmicos ou customização**
  10. **Mantenha consistência usando const em toda a fixture para melhor performance e imutabilidade**

- **IMPORTANTE: Para testes de igualdade, use APENAS as três instâncias padrão como constantes, sem métodos:**
  ```dart
  // Valores padrão para testes
  static const defaultValue = 1000.00;
  static const defaultType = Type.DEFAULT;
  static const differentValue = 2000.00;
  static const differentType = Type.OTHER;

  // Instância base para comparação
  static const Entity baseInstance = Entity(
    value: defaultValue,
    type: defaultType,
  );

  // Instância com mesmas propriedades
  static const Entity instanceWithSameProps = Entity(
    value: defaultValue,
    type: defaultType,
  );

  // Instância com propriedades diferentes
  static const Entity instanceWithDifferentProps = Entity(
    value: differentValue,
    type: differentType,
  );
  ```

## Razões para usar APENAS constantes:
  1. **Performance:** Avaliado em tempo de compilação, sem overhead de chamada de método
  2. **Imutabilidade:** Mais explícito que o valor nunca mudará
  3. **Otimização:** Permite mais otimizações pelo compilador
  4. **Legibilidade:** Mais direto e menos verboso
  5. **Simplicidade:** Reduz duplicação e pontos de manutenção
  6. **Clareza:** Torna óbvio que os valores são imutáveis e conhecidos em tempo de compilação
- **IMPORTANTE: Fixtures devem retornar Map<String, dynamic> ao invés de String JSON para melhor performance, type safety e facilidade de uso.**
- **Evite convert.jsonDecode nos testes - faça o decode dentro do fixture quando necessário.**
- **Use const Map<String, dynamic> para dados estáticos e factory methods para dados dinâmicos.**
- **Implemente métodos estáticos para diferentes cenários (ex: createValidUser(), createExpiredUser()).**
- **Crie factory methods quando precisar de variações (ex: createBalanceResponse({required double amount})).**
- **Prefira fixtures padronizadas a criar dados únicos em cada teste.**
- **Use FakerUtils.instance para gerar dados aleatórios quando necessário.**
- **Quando houver uso de entities nos testes, sempre crie fixtures ao invés de criar dados inline.**
- **Toda entity deve ter testes de comparação (equality) para verificar se objetos são iguais ou diferentes, testando operator ==, hashCode e props.**
- **Para testes unitários de Events do Bloc, não é necessário fazer testes de igualdade - foque apenas no comportamento funcional e criação dos events.**
- **IMPORTANTE: Para Events do Bloc, não implemente testes de equality (igualdade). Os testes recomendados são: criação do evento, verificação de propriedades, imutabilidade e herança da classe base AnticipationEvent.**
- **IMPORTANTE: Ao refatorar testes que possuem mockJson hardcoded, sempre transforme os dados em fixtures mantendo EXATAMENTE os mesmos dados originais. Não altere nenhum valor, apenas mova os dados para um arquivo de fixture usando Map<String, dynamic> ao invés de JSON string. Isso melhora a manutenibilidade sem quebrar os testes existentes.**
- **IMPORTANTE: Não permita fixtures com dados idênticos repetidos. Se múltiplos testes usam exatamente os mesmos dados, crie uma única constante e faça ambos os testes reutilizarem essa constante. Prefira sempre a solução mais simples: remover duplicatas ao invés de criar constantes intermediárias.**
- **IMPORTANTE: Ao criar fixtures de entities:**
  1. **Use o model.fromApi para converter dados do Map em entity**
  2. **Obtenha os dados do Map do model_fixture correspondente**
  3. **Nunca modifique dados hard coded inline - mova-os para fixtures apropriadas**
  4. **Crie um novo arquivo de fixture seguindo a estrutura de pastas do projeto**
  
  ```dart
  // ✅ Correto - Usando model_fixture e model.fromApi
  // Em test/features/settings/domain/entities/settings_fixture.dart
  class SettingsFixture {
    static Settings createFromApi() => SettingsModel.fromApi(
      map: SettingsModelFixture.generateFromApi(),
    );
  }
  
  // ❌ Evitar - Dados hard coded inline
  class SettingsFixture {
    static Settings create() => Settings(
      id: '123',  // Dados hard coded que deveriam vir do model_fixture
      name: 'Test',
      // ...
    );
  }
  ```

## Funções Auxiliares Globais (test/test_helpers.dart)
- **Centralize funções auxiliares usadas em múltiplas features.**
- **Implemente funções para criação de ApiResponse padrão (createSuccessResponse(), createErrorResponse()).**
- **Configure mocks básicos reutilizáveis em setupGlobalMocks().**
- **Use para padrões uniformes em todo o projeto.**

## Funções Auxiliares por Feature (test/features/[feature]/[feature]_test_helpers.dart)
- **Centralize funções auxiliares específicas de uma feature.**
- **Implemente funções para cenários específicos da feature (ex: mockLoginSuccess(), mockLoginError()).**
- **Configure mocks específicos da feature em setup[Feature]Mocks().**
- **Use para funcionalidades reutilizáveis dentro da mesma feature.**
- **Externalize mocks de repository em funções auxiliares genéricas que recebem Either como parâmetro para reutilização em múltiplos testes de UseCases (ex: mockPostApproveAffiliation(const Right(true)), mockGetAllData(Right(data))).**
- **Crie funções auxiliares locais apenas quando forem usadas 2 ou mais vezes. Funções usadas uma única vez devem ser inline diretamente no teste.**

## Estrutura de Arquivos de Teste
- **Mantenha a seguinte estrutura para cada pasta de teste:**
  - **test/core/helpers/**: Mocks e fixtures dos helpers do core
  - **test/core/services/**: Mocks e fixtures dos services do core
  - **test/features/[feature]/data/**: Mocks e fixtures da camada de data
  - **test/features/[feature]/domain/**: Mocks e fixtures da camada de domain
  - **test/features/[feature]/presentation/**: Mocks e fixtures da camada de presentation

## Configuração de Testes
- **Use when() com thenAnswer() para comportamentos assíncronos.**
- **Use when() com thenReturn() para valores síncronos.**
- **Sempre use FirebaseCrashlytics.recordError() nos mocks quando necessário.**
- **Configure todos os mocks necessários antes de executar os testes.**

## Testes de Cenários de Erro e Edge Cases para Bloc
- **Implemente grupo 'Edge Cases and Error Handling' em todos os testes de Bloc.**
- **Teste cenários obrigatórios para cada evento de Bloc:**
  - **Success case: comportamento padrão esperado**
  - **Error case: falha genérica da API/repository** 
  - **Offline case: usuário sem conectividade (`ErrorOfflineState`)**
  - **Timeout case: falha por timeout (`ErrorTimeoutState`)**
  - **User session case: sessão expirada (`ErrorUserSessionState`)**
  - **Empty data case: resposta vazia mas válida**
  - **Specific business errors: falhas específicas do negócio (ex: `UserUnaccreditedFailure`)**
- **Para cada cenário de erro, verifique que apenas as dependências necessárias foram chamadas.**
- **Use `verifyNoMoreInteractions()` para garantir que métodos não foram chamados desnecessariamente em cenários offline.**
- **Configure mocks adequados para cada dependência (connectivity, database, repository) conforme o cenário.**
- **Verifique o estado interno do Bloc após erro (ex: `expect(bloc.requestsList!.length, expectedCount)`).**

## Diversos
- **Use log em vez de print para depuração.**
- **Use BlocObserver para monitorar transições de estado durante a depuração.**
- **Mantenha as linhas com no máximo 120 caracteres, adicionando vírgulas antes de fechar parênteses em funções com vários parâmetros.**
- **Use ignore_for_file comentários quando necessário para suprimir warnings específicos.**
- **IMPORTANTE: Nunca execute comandos git no terminal. Deixe o gerenciamento de controle de versão para o usuário.**

## Documentação
- **Documente em Português do Brasil as lógicas complexas e decisões de código não óbvias.**
- **Siga a documentação oficial do Flutter, Bloc e Firebase para melhores práticas.**

## Referencie a documentação do Flutter, Bloc e Firebase para Widgets, Gerenciamento de Estado e Integração com Backend.
## Princípios Chave
- **Escreva código Dart conciso e técnico, com exemplos precisos.**
- **Use padrões de programação funcional e declarativa quando apropriado.**
- **Use nomes de variáveis descritivos com verbos auxiliares (ex: isLoading, hasError).**
- **Estruture os arquivos em: widget exportado, subwidgets, helpers, conteúdo estático, tipos.**
- **Utiliza Portugês do Brasil para documentação e inglês para nome de classes, variáveis, funções, métodos, etc.**

## Dart/Flutter
- **Utilize o padrão de arquitetura limpa (Clean Architecture) para o desenvolvimento do app.**
- **Utilize Bloc para gerenciamento de estado.**
- **Use construtores const para widgets imutáveis.**
- **Use sintaxe arrow para funções e métodos simples.**
- **Prefira corpos de expressão para getters e setters de uma linha.**
- **Use vírgulas finais para melhor formatação e revisão de código.**
- **Use const ao invés de final para variáveis inicializadas com valores constantes (ex: const mockData = Fixture.data ao invés de final mockData = Fixture.data).**

## Camada de Data
- **Use o padrão de implementação de DataSources encontrado no @WithdrawDatasource.**
- **Use o padrão de implementação de Models encontrados no @lib/features/withdraw/data/models.**
- **Sempre implemente tratamento de erro com try-catch nos DataSources.**
- **Use FirebaseCrashlytics.recordError() para registrar erros e stackTrace.**
- **Use log() ao invés de print() para logs de debug nos DataSources.**

## Camada de Domain
- **Use o padrão de implementação de Entities encontrados no @lib/features/withdraw/domain/entities.**
- **Use o padrão de implementação de Repositories encontrados no @lib/features/withdraw/domain/repositories.**
- **Use o padrão de implementação de UseCases encontrados no @lib/features/withdraw/domain/usecases.**
- **Sempre retorne Either<Failure?, T> nos métodos dos repositories.**

## Camada de Presentation
- **Use o padrão de implementação de Bloc encontrados no @lib/features/withdraw/presentation/bloc.**
- **Use o padrão de implementação de Eventos do Bloc encontrados no @lib/features/withdraw/presentation/bloc/withdraw_event.dart.**
- **IMPORTANTE: Para Events do Bloc, diferente dos States, eventos com propriedades DEVEM incluir essas propriedades nos props para permitir comparação de igualdade (evitando processamento duplicado de eventos iguais).**
- **Use o padrão de implementação de Estados do Bloc encontrados no @lib/features/withdraw/presentation/bloc/withdraw_state.dart.**
- **Sempre implemente estados específicos para Loading, Error e Success.**
- **Use buildWhen e listenWhen nos BlocBuilder e BlocListener para otimizar rebuilds.**
- **IMPORTANTE: Na classe abstrata dos States do Bloc, implemente `List<Object> get props => [identityHashCode(this)];` para garantir que todas as instâncias sejam únicas, mesmo states sem atributos.**
- **IMPORTANTE: Classes de estados do Bloc NÃO devem ter construtores `const` - isso garante que instâncias diferentes sejam criadas e `identityHashCode(this)` funcione corretamente.**
- **IMPORTANTE: States do Bloc que possuem atributos/propriedades DEVEM sobrescrever a propriedade props incluindo todos os atributos para permitir comparação adequada baseada nos valores (ex: `List<Object> get props => [attribute1, attribute2];`). States sem atributos podem usar apenas a implementação da classe base com `identityHashCode(this)`.**
- **IMPORTANTE: Classes de estados do Bloc sem atributos próprios NÃO devem sobrescrever a propriedade props, pois herdam automaticamente o comportamento da classe abstrata que já implementa `identityHashCode(this)`. Apenas sobrescreva props em classes com atributos específicos.**

## Camada de Services
- **Use o padrão de implementação de ApiService encontrados no @lib/core/services/api_service.dart.**
- **Sempre passe devLog e currentStackTrace nas chamadas do ApiService.**

## Tratamento de Erros e Validação
- **Implemente tratamento de erros para TimeoutFailure, UserSessionFailure, OfflineFailure, ErrorFailure, como é feito na @WalletInitialScreen.**
- **Quando ocorrer UserSessionFailure, o usuário deve ser deslogado, utilizando RoutesList.ExpiredSessionScreen.routeName.**
- **Implemente tratamento de erros nas views utilizando o widget @StandardErrorUi quando houver rebuild da tela.**
- **Use SnackBar @UiUtils.showSnackBarBlack quando não houver rebuild da tela.**
- **Para erros positivos/negativos, use @UiUtils.showSnackBarPositiveOrNegative com ShowSnackBarColorType.**

## Navegação e Rotas
- **Use @lib/core/routes/routes_list.dart (enum RoutesList) para todas as navegações.**
- **Sempre use Navigator.of(context).pushNamed() com RoutesList.NomeScreen.routeName.**
- **Para navegação com argumentos, crie classes Args específicas (ex: ProductDetailAffiliateScreenArgs).**

## Gerenciamento de Estado Local
- **Use SharedPreferencesHelper.instance com SharedPreferencesHelperKeys enum para persistência.**
- **Use SecureStorageHelper para dados sensíveis como tokens.**
- **Para estados loading, use variáveis booleanas privadas (ex: _isShowingLoading).**

## Gravação de logs de erros e Analytics
- **Use Firebase Crashlytics para gravar logs de erros, como pode ser visto no @lib/core/services/api_service.dart.**
- **Use AnalyticsHelper.instance.sendAnalyticsEvent() com AnalyticsEvents constants.**

## Otimização de Performance
- **Use widgets const sempre que possível para otimizar rebuilds.**
- **Implemente otimizações em listas (ex: ListView.builder).**
- **Use AssetImage para imagens estáticas e cached_network_image para imagens remotas.**

## Convenções Principais
- **Prefira widgets stateless:**
  - **Use BlocBuilder para widgets que dependem do estado do Cubit/Bloc.**
  - **Use BlocListener para tratar efeitos colaterais, como navegação ou exibição de diálogos.**
  - **Use BlocConsumer quando precisar tanto de listener quanto builder.**

## UI e Estilo
- **Use widgets nativos do Flutter e crie widgets personalizados.**
- **Use temas para manter o estilo consistente em todo o app.**
- **Use AppLocalizations.of(context).translate() para todas as strings.**
- **Use AppStyles para estilos de texto consistentes.**
- **Use Theme.of(context).extension<TextColors>() para cores de texto.**

## Widgets e Componentes de UI
- **Crie classes de widget pequenas e privadas, em vez de métodos como Widget _build...**
- **Implemente RefreshIndicator para funcionalidade de pull-to-refresh.**
- **Em TextFields, defina textCapitalization, keyboardType e textInputAction apropriados.**
- **Sempre inclua um errorBuilder ao usar Image.network.**
- **Use CustomButton ao invés de botões nativos para consistência.**
- **Use ProgressUtils.showCircularIndicator() para loading modals.**

## Conectividade e Offline
- **Sempre verifique conectividade com ConnectivityHelper.isConnectionDown() antes de chamadas de API.**
- **Implemente estados específicos para erro offline (ex: ErrorOfflineState).**

## Autenticação e Sessão
- **Use SessionHelper.instance para gerenciar dados da sessão do usuário.**
- **Use BiometricHelper para autenticação biométrica.**
- **Sempre trate UserSessionFailure redirecionando para ExpiredSessionScreen.**

## Internacionalização
- **Use AppLocalizations.of(context).translate() para todas as strings visíveis.**
- **Mantenha as chaves de tradução em snake_case.**

## Testes Unitários de UseCase
- **IMPORTANTE: Testes de UseCase devem usar o DataSource diretamente ao invés de mockar o Repository:**
  ```dart
  // ✅ Correto - Usando DataSource
  late SettingsDataSource dataSource;
  late PostDeviceUpdateSettingsUseCase useCase;

  setUp(() {
    dataSource = SettingsDataSource(
      apiService: apiServiceMock,
      firebaseCrashlytics: firebaseCrashlyticsMock,
      deviceHelper: deviceHelperMock,
    );
    useCase = PostDeviceUpdateSettingsUseCase(repository: dataSource);
  });

  // ❌ Evitar - Usando mock do Repository
  late SettingsRepositoryMock repositoryMock;
  late PostDeviceUpdateSettingsUseCase useCase;

  setUp(() {
    repositoryMock = SettingsRepositoryMock();
    useCase = PostDeviceUpdateSettingsUseCase(repository: repositoryMock);
  });
  ```

- **Estrutura obrigatória para testes de UseCase:**
  1. **Mocks necessários:**
     - ApiServiceMock para simular chamadas da API
     - FirebaseCrashlyticsMock para logs de erro
     - DeviceHelperMock para dados do dispositivo
     - Outros mocks específicos conforme necessidade do DataSource

  2. **Configuração no setUp:**
     - Inicializar todos os mocks
     - Criar DataSource com os mocks
     - Criar UseCase com o DataSource
     - Resetar mocks com reset()
     - Configurar setupDefaults dos mocks
     - Configurar deviceId mock

  3. **Grupos de teste obrigatórios:**
     - Success cases: retorno bem sucedido
     - Error cases: 
       - Left(null) para erro genérico
       - TimeoutFailure para timeout
       - UserSessionFailure para sessão expirada
     - Params: validação dos parâmetros

  4. **Verificações obrigatórias:**
     - Verificar retorno (isRight/isLeft)
     - Verificar valor retornado
     - Verificar chamadas do deviceHelper
     - Verificar chamadas do apiService
     - Usar verifyNoMoreInteractions

  5. **Dados de teste:**
     - Usar fixtures existentes ao invés de dados inline
     - Seguir formato da API nas respostas mock
     - Usar dados realistas nos parâmetros
     - Testar variações de parâmetros

- **IMPORTANTE: Não criar mocks desnecessários. Se o UseCase depende do Repository e o Repository é implementado pelo DataSource, usar o DataSource diretamente.**

- **IMPORTANTE: Sempre verificar a implementação do DataSource para entender quais mocks são necessários e como estruturar os dados de teste.**

## Testes Unitários e Mocks
## IMPORTANTE: Nunca crie novos helpers de teste. Use sempre os helpers existentes na pasta @/test/core/helpers:

## IMPORTANTE: Em testes unitários, o reset() dos mocks deve ser feito no tearDown() e não no setUp():
```dart
setUp(() {
  apiServiceMock = ApiServiceMock();
  firebaseCrashlyticsMock = FirebaseCrashlyticsMock();
  // configuração inicial...
});

tearDown(() {
  reset(apiServiceMock);
  reset(firebaseCrashlyticsMock);
});
```

## Razões para usar reset() no tearDown:
- Garante que o estado dos mocks seja limpo mesmo se um teste falhar
- Mantém o setUp() focado apenas na configuração inicial necessária
- Segue o princípio de "limpar após usar" ao invés de "limpar antes de usar"
- Padrão recomendado pela comunidade Flutter/Dart
- **Use padrão AAA (Arrange, Act, Assert) em todos os testes.**
- **Use blocTest para testar Blocs.**
- **Use Mocktail para mocks.**
- **IMPORTANTE: Sempre que for testar igualdade de states, entities ou models (ou qualquer classe que sobrescreva props ou operator==), utilize obrigatoriamente a função auxiliar HelpersTestUtils.testObjectEquality para garantir padronização, evitar duplicação de código e cobrir todos os aspectos de igualdade (==, hashCode).**
- **IMPORTANTE: Para criar respostas de API em testes, sempre use os métodos utilitários do ApiServiceMock ao invés de criar ApiResponse diretamente:**
  - **Use createSuccessResponse() para respostas de sucesso com dados**
  - **Use createErrorResponse() para respostas de erro genérico**
  - **Use createTimeoutResponse() para respostas de timeout**
  - **Use createUserSessionErrorResponse() para respostas de erro de sessão**
- **Crie funções auxiliares locais apenas quando forem usadas 2 ou mais vezes. Funções auxiliares usadas uma única vez devem ser inline diretamente no teste.**
- **IMPORTANTE: Sempre dar preferência aos helpers da pasta @/test/core/helpers e seus métodos setupDefaults() para configurar mocks. Apenas use helpers específicos da feature quando a funcionalidade não existir nos helpers centrais.**
- **IMPORTANTE: Evite chamadas redundantes de configuração de mocks. Se setupDefaults() já configura um comportamento padrão (ex: conexão online), não repita essa configuração nos testes individuais.**

## Testes Unitários de Bloc - Boas Práticas Específicas
- **Sempre use `blocTest` ao invés de `test` manual para testes de Bloc.**
- **Use `reset()` em `setUp()` para garantir estado limpo entre testes: `reset(repositoryMock); reset(helperMock);`**
- **Use `seed:` em `blocTest` para testar com estados iniciais específicos (especialmente útil para testes de ações).**
- **Organize testes em grupos por funcionalidade: `group('LoadSentRequest', () {...})`**
- **Implemente seção `verify:` em todos os `blocTest` para verificar side effects.**
- **Sempre use `verify()` para verificar que métodos foram chamados com parâmetros corretos.**
- **Sempre use `verifyNoMoreInteractions()` para garantir que nenhuma chamada não esperada foi feita.**
- **Verifique parâmetros específicos nas chamadas: `verify(() => repo.method(param: expectedValue)).called(1);`**
- **Verifique o estado final detalhadamente no bloco `verify:`**
- **Crie grupo específico 'Edge Cases and Error Handling' para cenários extremos e tratamento de erros.**
- **Teste todos os cenários: success, error, offline, timeout, session expired, empty data.**
- **Use nomes descritivos explicando cenário e resultado esperado: 'should emit LoadingState and LoadedState when loading data successfully'**
- **Para testes de ações (approve, refuse, cancel), use `seed:` para definir estado inicial da lista.**
- **Configure todos os mocks necessários no bloco `build:` do `blocTest`.**
- **Use `when().thenAnswer((_) async => result)` para comportamentos assíncronos.**
- **Após finalizar todos os testes unitários do Bloc e garantir que todos passem com sucesso, revise o código e crie funções auxiliares para mocks que se repetem 2 ou mais vezes no arquivo de teste (ex: mockOnlineConnection(), mockOfflineConnection(), mockDatabaseSave()), seguindo o padrão estabelecido em @affiliation_bloc_test.dart.**
- **Use matchers específicos ao invés de equals() genérico:**
  - **Booleanos: isTrue/isFalse ao invés de equals(true)/equals(false)**
  - **Null: isNull/isNotNull ao invés de equals(null)**
  - **Tipos: isA<T>() para verificar tipos específicos**
  - **Coleções: isEmpty/isNotEmpty, hasLength(n), contains(item)**
  - **Strings: startsWith(), endsWith(), contains(), matches() para regex**
  - **Números: greaterThan(), lessThan(), closeTo() para valores com tolerância**
  - **Exceções: throwsA(), throwsException(), throwsArgumentError()**
  - **Mocks: called(), never, calledOnce ao invés de times(1)**
- **Teste todos os estados possíveis dos Blocs (Loading, Success, Error).**
- **Títulos de testes devem ser em inglês americano, com linguagem simples e direta (ex: "should return valid data when login is successful").**
- **Para testes de Bloc, use formato descritivo explicando o cenário completo: "should emit LoadingState and LoadedState when loading data successfully"**
- **Organize testes de Bloc em grupos por evento: `group('LoadSentRequest', () {})`, `group('ApproveRequest', () {})`**
- **Para cada grupo de evento, teste no mínimo: success, error, offline, e cenários de negócio específicos.**
- **Use sufixo descritivo nos grupos de edge cases: `group('Edge Cases and Error Handling', () {})`**
- **IMPORTANTE: Somente em testes de estados do Bloc, use `final` ao invés de `const` nas declarações (ex: `final state = LoadingState();`) pois as classes não possuem construtores const.**
- **Para criar ou refatorar testes unitários, use @helpers_test_utils.dart, @api_service_mock.dart, os mocks da pasta /test/core/helpers e arquivos com final fixture.dart.**
- **IMPORTANTE: Sempre use fixtures existentes ao invés de criar dados mock hardcoded inline nos testes. Use AffiliationRequestEntityFixture para dados de afiliação, MenuTestHelpers para dados de usuário e avatar, e outros fixtures específicos do projeto.**
- **Caso não houver mocks e funções auxiliares já criados no projeto, pode criar novos mocks e funções auxiliares.**
- **Os novos mocks e funções auxiliares podem usar os mocks e funções auxiliares existentes para uso interno, evitando código repetido.**
- **Siga as boas práticas estabelecidas no projeto e pergunte em caso de dúvidas.**
- **Separe testes de comportamento (expect) e interação (verify) em testes diferentes:**
  - **Teste de comportamento: Verifica o que o método retorna (usando expect)**
  - **Teste de interação: Verifica como o método interage com dependências (usando verify)**
  - **Exceção: Use expect e verify no mesmo teste apenas quando verificar que uma dependência NÃO foi chamada**
- **Para testes de Bloc, combine verificação de comportamento (expect) e interação (verify) no mesmo teste usando o bloco `verify:` do `blocTest`.**

## Estrutura de Testes de Bloc
- **Use a seguinte estrutura consistente em todos os `blocTest`:**
  ```dart
  blocTest<BlocClass, StateClass>(
    'should emit [ExpectedState1, ExpectedState2] when action occurs',
    seed: () => InitialState(), // opcional, para estados iniciais específicos
    build: () {
      // Arrange - configurar mocks
      when(() => mock.method()).thenAnswer((_) async => result);
      return bloc;
    },
    act: (bloc) => bloc.add(EventClass()),
    expect: () => [
      isA<ExpectedState1>(),
      isA<ExpectedState2>(),
    ],
    verify: (bloc) {
      // Verificar side effects
      verify(() => mock.method()).called(1);
      verifyNoMoreInteractions(mock);
      
      // Verificar estado final
      final state = bloc.state as ExpectedState2;
      expect(state.property, expectedValue);
    },
  );
  ```
- **Sempre configure `reset()` no `setUp()` para limpar estado dos mocks entre testes.**
- **Configure mocks no `build:` e nunca no `setUp()` ou `setUpAll()` para testes de Bloc.**
- **Use `isA<StateType>()` ao invés de instâncias específicas no `expect:` para melhor flexibilidade.**

## Estrutura de Organização de Testes
- **Organize a estrutura de testes espelhando a estrutura da pasta /lib.**
- **Crie um arquivo de mock específico para cada classe (ex: connectivity_helper_mock.dart).**
- **Crie um arquivo de fixture específico para cada classe (ex: user_login_data_fixture.dart).**
- **Use @test/test_helpers.dart para funções auxiliares globais usadas em múltiplas features.**
- **Use @test/features/[feature]/[feature]_test_helpers.dart para funções auxiliares específicas de uma feature.**

## Padrões de Nomenclatura para Testes
- **Use sufixo _mock.dart para arquivos de mock: connectivity_helper_mock.dart, api_service_mock.dart.**
- **Use sufixo _fixture.dart para arquivos de fixture: user_login_data_fixture.dart, api_response_fixture.dart.**
- **Use sufixo _test_helpers.dart para arquivos de funções auxiliares: login_test_helpers.dart.**
- **Use sufixo Mock para classes de mock: ConnectivityHelperMock, ApiServiceMock.**
- **Use sufixo Fake para classes fake: BuildContextFake, ApiRequestFake.**
- **Use sufixo Fixture para classes de fixture: UserLoginDataFixture.**
- **Para variáveis mock, use sufixo Mock: apiServiceMock, firebaseCrashlyticsMock.**
- **Para dados de teste, use nomes descritivos ao contexto: successResponse, errorResponse, invalidDataResponse.**
- **IMPORTANTE: Variáveis de mock devem seguir o padrão camelCase do tipo da classe: `late BankingAccountRepositoryMock bankingAccountRepositoryMock`, `late ConnectivityHelperMock connectivityHelperMock`.**
- **Quando um item de lista for acessado múltiplas vezes, extraia-o para uma variável com nome descritivo (ex: requestItem, [runtimeType]Item).**
- **Prefira .first ao invés de [0] para acessar o primeiro item - é mais seguro e expressivo.**
- **IMPORTANTE: Nomes de métodos em fixtures devem refletir o estado do objeto e serem genéricos para permitir reutilização:**
  ```dart
  // ✅ Correto - Nomes refletem estado do objeto
  static Entity createWithDefaultData()
  static Entity createWithEmptyData()
  static Entity createWithCustomData()
  static Entity createWithFullData()
  static Entity createWithPartialData()
  static Entity createWithInvalidData()
  
  // ❌ Evitar - Nomes muito específicos ou pouco descritivos
  static Entity createFromApi()
  static Entity createDifferent()
  static Entity create()
  static Entity createCustom()
  ```

## Organização de Mocks
- **Crie mocks específicos por classe em arquivos separados espelhando a estrutura de /lib.**
- **Implemente métodos setupDefaults() estáticos nos mocks para configuração padrão.**
- **Use registerFallbackValue() para tipos complexos que precisam de fallback.**
- **Configure mocks no setUpAll() para dados que não mudam entre testes.**
- **Use setUp() para configurações que precisam ser resetadas a cada teste.**

## Verificação de Parâmetros e Interações em Testes de Bloc
- **Sempre verifique parâmetros específicos nas chamadas de método ao invés de usar `any()`:**
  ```dart
  // ✅ Correto - verificar parâmetros específicos
  verify(() => repository.getItems(page: '1', status: 'active')).called(1);
  
  // ❌ Evitar - usar any() genérico
  verify(() => repository.getItems(page: any(named: 'page'))).called(1);
  ```
- **Verifique o número exato de chamadas para cada mock: `.called(1)`, `.called(2)`, `never`**
- **Use `verifyInOrder()` quando a ordem das chamadas for importante.**
- **Para testes de Bloc com múltiplas dependências, verifique todas em sequência:**
  ```dart
  verify(() => connectivityHelper.isConnectionDown()).called(1);
  verify(() => repository.getData()).called(1); 
  verify(() => databaseHelper.save()).called(1);
  verifyNoMoreInteractions(connectivityHelper);
  verifyNoMoreInteractions(repository);
  verifyNoMoreInteractions(databaseHelper);
  ```
- **Configure todos os mocks necessários mesmo se não forem usados em cenários offline/erro.**

## Organização de Fixtures
- **Crie fixtures específicos por classe em arquivos separados espelhando a estrutura de /lib.**

- **IMPORTANTE: Para fixtures de models:**
  ```dart
  /// Fixture para testes do MyModel
  class MyModelFixture {
    /// Gera um Map com dados válidos para o MyModel
    static const Map<String, dynamic> validData = {
      'id': '123',
      'name': 'Test Name',
      'value': 'R$ 1.000,00',
    };

    /// Gera um Map com dados inválidos para o MyModel
    static const Map<String, dynamic> invalidData = {
      'id': 'invalid',
      'name': null,
      'value': 'invalid',
    };
  }
  ```
## Regras:
  1. **Use `static const Map<String, dynamic>` para todos os dados**
  2. **Mantenha os dados hard coded inline exatamente como vêm da API**
  3. **Nomeie os métodos seguindo o padrão:**
     - `validData` para dados válidos padrão
     - `invalidData` para dados inválidos
     - `customData` para variações específicas
  4. **Documente cada método explicando seu propósito**
  5. **Mantenha os dados realistas, copiados diretamente da API**
  6. **Use valores formatados como na API (ex: 'R$ 1.000,00' ao invés de '1000.00')**
  7. **Não crie métodos intermediários ou helpers - mantenha os dados diretos**

- **IMPORTANTE: Para fixtures de entities:**
  ```dart
  /// Fixture para testes do MyEntity
  class MyEntityFixture {
    /// Instância base para comparação
    static const MyEntity baseInstance = MyEntity(
      value: 1000.00,
      type: Type.DEFAULT,
    );

    /// Instância com as mesmas propriedades
    static const MyEntity instanceWithSameProps = MyEntity(
      value: 1000.00,
      type: Type.DEFAULT,
    );

    /// Instância com propriedades diferentes
    static const MyEntity instanceWithDifferentProps = MyEntity(
      value: 2000.00,
      type: Type.OTHER,
    );
  }
  ```

## Regras:
  1. **Use `static const` para todas as instâncias**
  2. **Nomeie as instâncias seguindo o padrão:**
     - `baseInstance` para instância base de comparação
     - `instanceWithSameProps` para instância com mesmas propriedades
     - `instanceWithDifferentProps` para instância com propriedades diferentes
  3. **IMPORTANTE: Se a entity tem model correspondente, sempre dever usar os dados do model fixture:**
     ```dart
     static const MyEntity baseInstance = MyEntityModel.fromApi(
       map: MyModelFixture.validData,
     );
     ```
  4. **Documente cada instância explicando seu propósito**
  5. **Mantenha os dados realistas e consistentes com o model fixture**
  6. **Não crie métodos - use apenas instâncias const**
    ```
     // ❌ Evitar - Valor usado apenas uma vez
     static const defaultType = Type.DEFAULT; // Deveria estar direto na instância
     ```
  7. **Use construtores const para instâncias de entidades quando possível:**
     ```dart
     static Entity createBaseInstance() => const Entity(
       value: defaultValue,
       type: defaultType,
     );
     ```
  8. **Prefira propriedades const sobre métodos de factory quando os valores são estáticos:**
     ```dart
     // ✅ Correto - Usando const
     static const defaultData = {
       'key': 'value',
       'amount': 1000.00,
     };
     
     // ❌ Evitar - Usando método
     static Map<String, dynamic> getDefaultData() => {
       'key': 'value',
       'amount': 1000.00,
     };
     ```
  9. **Use factory methods (não const) apenas quando precisar de valores dinâmicos ou customização**
  10. **Mantenha consistência usando const em toda a fixture para melhor performance e imutabilidade**

- **IMPORTANTE: Para testes de igualdade, use APENAS as três instâncias padrão como constantes, sem métodos:**
  ```dart
  // Valores padrão para testes
  static const defaultValue = 1000.00;
  static const defaultType = Type.DEFAULT;
  static const differentValue = 2000.00;
  static const differentType = Type.OTHER;

  // Instância base para comparação
  static const Entity baseInstance = Entity(
    value: defaultValue,
    type: defaultType,
  );

  // Instância com mesmas propriedades
  static const Entity instanceWithSameProps = Entity(
    value: defaultValue,
    type: defaultType,
  );

  // Instância com propriedades diferentes
  static const Entity instanceWithDifferentProps = Entity(
    value: differentValue,
    type: differentType,
  );
  ```

## Razões para usar APENAS constantes:
  1. **Performance:** Avaliado em tempo de compilação, sem overhead de chamada de método
  2. **Imutabilidade:** Mais explícito que o valor nunca mudará
  3. **Otimização:** Permite mais otimizações pelo compilador
  4. **Legibilidade:** Mais direto e menos verboso
  5. **Simplicidade:** Reduz duplicação e pontos de manutenção
  6. **Clareza:** Torna óbvio que os valores são imutáveis e conhecidos em tempo de compilação
- **IMPORTANTE: Fixtures devem retornar Map<String, dynamic> ao invés de String JSON para melhor performance, type safety e facilidade de uso.**
- **Evite convert.jsonDecode nos testes - faça o decode dentro do fixture quando necessário.**
- **Use const Map<String, dynamic> para dados estáticos e factory methods para dados dinâmicos.**
- **Implemente métodos estáticos para diferentes cenários (ex: createValidUser(), createExpiredUser()).**
- **Crie factory methods quando precisar de variações (ex: createBalanceResponse({required double amount})).**
- **Prefira fixtures padronizadas a criar dados únicos em cada teste.**
- **Use FakerUtils.instance para gerar dados aleatórios quando necessário.**
- **Quando houver uso de entities nos testes, sempre crie fixtures ao invés de criar dados inline.**
- **Toda entity deve ter testes de comparação (equality) para verificar se objetos são iguais ou diferentes, testando operator ==, hashCode e props.**
- **Para testes unitários de Events do Bloc, não é necessário fazer testes de igualdade - foque apenas no comportamento funcional e criação dos events.**
- **IMPORTANTE: Para Events do Bloc, não implemente testes de equality (igualdade). Os testes recomendados são: criação do evento, verificação de propriedades, imutabilidade e herança da classe base AnticipationEvent.**
- **IMPORTANTE: Ao refatorar testes que possuem mockJson hardcoded, sempre transforme os dados em fixtures mantendo EXATAMENTE os mesmos dados originais. Não altere nenhum valor, apenas mova os dados para um arquivo de fixture usando Map<String, dynamic> ao invés de JSON string. Isso melhora a manutenibilidade sem quebrar os testes existentes.**
- **IMPORTANTE: Não permita fixtures com dados idênticos repetidos. Se múltiplos testes usam exatamente os mesmos dados, crie uma única constante e faça ambos os testes reutilizarem essa constante. Prefira sempre a solução mais simples: remover duplicatas ao invés de criar constantes intermediárias.**
- **IMPORTANTE: Ao criar fixtures de entities:**
  1. **Use o model.fromApi para converter dados do Map em entity**
  2. **Obtenha os dados do Map do model_fixture correspondente**
  3. **Nunca modifique dados hard coded inline - mova-os para fixtures apropriadas**
  4. **Crie um novo arquivo de fixture seguindo a estrutura de pastas do projeto**
  
  ```dart
  // ✅ Correto - Usando model_fixture e model.fromApi
  // Em test/features/settings/domain/entities/settings_fixture.dart
  class SettingsFixture {
    static Settings createFromApi() => SettingsModel.fromApi(
      map: SettingsModelFixture.generateFromApi(),
    );
  }
  
  // ❌ Evitar - Dados hard coded inline
  class SettingsFixture {
    static Settings create() => Settings(
      id: '123',  // Dados hard coded que deveriam vir do model_fixture
      name: 'Test',
      // ...
    );
  }
  ```

## Funções Auxiliares Globais (test/test_helpers.dart)
- **Centralize funções auxiliares usadas em múltiplas features.**
- **Implemente funções para criação de ApiResponse padrão (createSuccessResponse(), createErrorResponse()).**
- **Configure mocks básicos reutilizáveis em setupGlobalMocks().**
- **Use para padrões uniformes em todo o projeto.**

## Funções Auxiliares por Feature (test/features/[feature]/[feature]_test_helpers.dart)
- **Centralize funções auxiliares específicas de uma feature.**
- **Implemente funções para cenários específicos da feature (ex: mockLoginSuccess(), mockLoginError()).**
- **Configure mocks específicos da feature em setup[Feature]Mocks().**
- **Use para funcionalidades reutilizáveis dentro da mesma feature.**
- **Externalize mocks de repository em funções auxiliares genéricas que recebem Either como parâmetro para reutilização em múltiplos testes de UseCases (ex: mockPostApproveAffiliation(const Right(true)), mockGetAllData(Right(data))).**
- **Crie funções auxiliares locais apenas quando forem usadas 2 ou mais vezes. Funções usadas uma única vez devem ser inline diretamente no teste.**

## Estrutura de Arquivos de Teste
- **Mantenha a seguinte estrutura para cada pasta de teste:**
  - **test/core/helpers/**: Mocks e fixtures dos helpers do core
  - **test/core/services/**: Mocks e fixtures dos services do core
  - **test/features/[feature]/data/**: Mocks e fixtures da camada de data
  - **test/features/[feature]/domain/**: Mocks e fixtures da camada de domain
  - **test/features/[feature]/presentation/**: Mocks e fixtures da camada de presentation

## Configuração de Testes
- **Use when() com thenAnswer() para comportamentos assíncronos.**
- **Use when() com thenReturn() para valores síncronos.**
- **Sempre use FirebaseCrashlytics.recordError() nos mocks quando necessário.**
- **Configure todos os mocks necessários antes de executar os testes.**

## Testes de Cenários de Erro e Edge Cases para Bloc
- **Implemente grupo 'Edge Cases and Error Handling' em todos os testes de Bloc.**
- **Teste cenários obrigatórios para cada evento de Bloc:**
  - **Success case: comportamento padrão esperado**
  - **Error case: falha genérica da API/repository** 
  - **Offline case: usuário sem conectividade (`ErrorOfflineState`)**
  - **Timeout case: falha por timeout (`ErrorTimeoutState`)**
  - **User session case: sessão expirada (`ErrorUserSessionState`)**
  - **Empty data case: resposta vazia mas válida**
  - **Specific business errors: falhas específicas do negócio (ex: `UserUnaccreditedFailure`)**
- **Para cada cenário de erro, verifique que apenas as dependências necessárias foram chamadas.**
- **Use `verifyNoMoreInteractions()` para garantir que métodos não foram chamados desnecessariamente em cenários offline.**
- **Configure mocks adequados para cada dependência (connectivity, database, repository) conforme o cenário.**
- **Verifique o estado interno do Bloc após erro (ex: `expect(bloc.requestsList!.length, expectedCount)`).**

## Diversos
- **Use log em vez de print para depuração.**
- **Use BlocObserver para monitorar transições de estado durante a depuração.**
- **Mantenha as linhas com no máximo 120 caracteres, adicionando vírgulas antes de fechar parênteses em funções com vários parâmetros.**
- **Use ignore_for_file comentários quando necessário para suprimir warnings específicos.**
- **IMPORTANTE: Nunca execute comandos git no terminal. Deixe o gerenciamento de controle de versão para o usuário.**

## Documentação
- **Documente em Português do Brasil as lógicas complexas e decisões de código não óbvias.**
- **Siga a documentação oficial do Flutter, Bloc e Firebase para melhores práticas.**

## Referencie a documentação do Flutter, Bloc e Firebase para Widgets, Gerenciamento de Estado e Integração com Backend.
