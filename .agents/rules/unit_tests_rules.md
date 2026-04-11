---
description: Regras e estrutura para elaboração de Testes Unitários e mocks
---
# Regras de Testes Unitários

## Princípios Gerais

### Idioma e Convenções
- **Títulos de testes devem ser em inglês americano, com linguagem simples e direta**
- **Exemplo: "should return valid data when login is successful"**
- **Use doc comments (///) em português para fixtures e test helpers**
- **Documente apenas testes complexos ou não óbvios**
- **Evite documentar testes auto-explicativos**

### Padrão AAA (Arrange, Act, Assert)
```dart
test('should return user when credentials are valid', () {
  // Arrange - Configuração
  const email = 'user@example.com';
  const password = 'password123';
  when(() => repository.login(email, password))
      .thenAnswer((_) async => Right(user));

  // Act - Execução
  final result = await useCase(email: email, password: password);

  // Assert - Verificação
  expect(result.isRight(), isTrue);
  expect(result.getOrElse(() => throw Exception()), user);
});
```

### Separação de Testes
- **Teste de comportamento: Verifica o que o método retorna (usando expect)**
- **Teste de interação: Verifica como o método interage com dependências (usando verify)**
- **Exceção: Use expect e verify no mesmo teste apenas quando verificar que uma dependência NÃO foi chamada**
- **Para testes de Bloc, combine verificação de comportamento (expect) e interação (verify) no mesmo teste usando o bloco `verify:` do `blocTest`**

### Matchers Específicos
Use matchers específicos ao invés de `equals()` genérico:

```dart
// ✅ Correto - Matchers específicos
expect(isOnline, isTrue);
expect(user, isNull);
expect(products, isEmpty);
expect(products.length, equals(5));
expect(result, isA<SuccessState>());

// ❌ Evitar - equals() genérico
expect(isOnline, equals(true));
expect(user, equals(null));
expect(products.isEmpty, equals(true));
```

**Lista de matchers recomendados:**
- **Booleanos:** `isTrue`, `isFalse`
- **Null:** `isNull`, `isNotNull`
- **Tipos:** `isA<T>()`
- **Coleções:** `isEmpty`, `isNotEmpty`, `hasLength(n)`, `contains(item)`
- **Strings:** `startsWith()`, `endsWith()`, `contains()`, `matches()`
- **Números:** `greaterThan()`, `lessThan()`, `closeTo()`
- **Exceções:** `throwsA()`, `throwsException()`, `throwsArgumentError()`
- **Mocks:** `called()`, `never`, `calledOnce`

## Estrutura de Organização

### Hierarquia de Arquivos
Organize a estrutura de testes espelhando a estrutura da pasta `/lib`:

```
test/
├── core/
│   ├── helpers/          # Mocks e fixtures dos helpers
│   └── services/         # Mocks e fixtures dos services
├── features/
│   └── [feature]/
│       ├── data/         # Testes de DataSources e Models
│       ├── domain/       # Testes de Entities, Repositories e UseCases
│       └── presentation/ # Testes de Blocs, States e Events
└── test_helpers.dart     # Funções auxiliares globais
```

### Padrões de Nomenclatura

#### Arquivos
- **Mock files:** sufixo `_mock.dart` (ex: `connectivity_helper_mock.dart`)
- **Fixture files:** sufixo `_fixture.dart` (ex: `user_login_data_fixture.dart`)
- **Test helpers:** sufixo `_test_helpers.dart` (ex: `login_test_helpers.dart`)

#### Classes
- **Mock classes:** sufixo `Mock` (ex: `ConnectivityHelperMock`, `ApiServiceMock`)
- **Fake classes:** sufixo `Fake` (ex: `BuildContextFake`, `ApiRequestFake`)
- **Fixture classes:** sufixo `Fixture` (ex: `UserLoginDataFixture`)

#### Variáveis
- **Variáveis mock:** sufixo `Mock` em camelCase (ex: `apiServiceMock`, `firebaseCrashlyticsMock`)
- **Dados de teste:** nomes descritivos ao contexto (ex: `successResponse`, `errorResponse`, `invalidDataResponse`)

**Exemplos:**
```dart
// ✅ Correto
late BankingAccountRepositoryMock bankingAccountRepositoryMock;
late ConnectivityHelperMock connectivityHelperMock;

// ❌ Evitar
late BankingAccountRepositoryMock repository;
late ConnectivityHelperMock connectivity;
```

### Acesso a Elementos de Lista
```dart
// ✅ Correto - Prefira .first
final firstItem = list.first;

// ✅ Correto - Extraia para variável quando usado múltiplas vezes
final requestItem = bloc.requestsList!.first;
expect(requestItem.id, '123');
expect(requestItem.status, AffiliationStatus.approved);

// ❌ Evitar - [0] é menos seguro
final firstItem = list[0];

// ❌ Evitar - Acesso repetido
expect(bloc.requestsList![0].id, '123');
expect(bloc.requestsList![0].status, AffiliationStatus.approved);
```

## Testes de UseCase

### Estrutura Obrigatória

#### IMPORTANTE: Use DataSource Diretamente
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

#### Mocks Necessários
1. `ApiServiceMock` para simular chamadas da API
2. `FirebaseCrashlyticsMock` para logs de erro
3. `DeviceHelperMock` para dados do dispositivo
4. Outros mocks específicos conforme necessidade do DataSource

#### Configuração no setUp/tearDown
```dart
late ApiServiceMock apiServiceMock;
late FirebaseCrashlyticsMock firebaseCrashlyticsMock;
late DeviceHelperMock deviceHelperMock;
late SettingsDataSource dataSource;
late PostDeviceUpdateSettingsUseCase useCase;

setUp(() {
  // Inicializar mocks
  apiServiceMock = ApiServiceMock();
  firebaseCrashlyticsMock = FirebaseCrashlyticsMock();
  deviceHelperMock = DeviceHelperMock();
  
  // Configurar defaults
  ApiServiceMock.setupDefaults(apiServiceMock);
  DeviceHelperMock.setupDefaults(deviceHelperMock);
  
  // Criar DataSource e UseCase
  dataSource = SettingsDataSource(
    apiService: apiServiceMock,
    firebaseCrashlytics: firebaseCrashlyticsMock,
    deviceHelper: deviceHelperMock,
  );
  useCase = PostDeviceUpdateSettingsUseCase(repository: dataSource);
});

tearDown(() {
  reset(apiServiceMock);
  reset(firebaseCrashlyticsMock);
  reset(deviceHelperMock);
});
```

**IMPORTANTE: reset() no tearDown(), não no setUp()**

**Razões:**
- Garante limpeza mesmo se um teste falhar
- Mantém setUp() focado na configuração inicial
- Segue princípio de "limpar após usar"
- Padrão recomendado pela comunidade Flutter/Dart

#### Grupos de Teste Obrigatórios

```dart
void main() {
  group('PostDeviceUpdateSettingsUseCase', () {
    // Success cases
    group('Success cases', () {
      test('should return Right when API call succeeds', () {});
    });

    // Error cases
    group('Error cases', () {
      test('should return Left(null) for generic error', () {});
      test('should return Left(TimeoutFailure) on timeout', () {});
      test('should return Left(UserSessionFailure) on session expired', () {});
    });

    // Params validation
    group('Params', () {
      test('should validate required parameters', () {});
    });
  });
}
```

#### Verificações Obrigatórias
```dart
test('should return valid data when call succeeds', () async {
  // Arrange
  when(() => apiServiceMock.post(any(), any()))
      .thenAnswer((_) async => ApiServiceMock.createSuccessResponse(
            data: SettingsModelFixture.validData,
          ));

  // Act
  final result = await useCase();

  // Assert
  expect(result.isRight(), isTrue); // Verificar retorno
  expect(result.getOrElse(() => throw Exception()), isA<Settings>()); // Verificar tipo
  
  // Verificar chamadas
  verify(() => deviceHelperMock.getDeviceId()).called(1);
  verify(() => apiServiceMock.post(any(), any())).called(1);
  verifyNoMoreInteractions(apiServiceMock);
  verifyNoMoreInteractions(deviceHelperMock);
});
```

#### Dados de Teste
- Usar fixtures existentes ao invés de dados inline
- Seguir formato da API nas respostas mock
- Usar dados realistas nos parâmetros
- Testar variações de parâmetros

## Testes de Bloc

### Estrutura com blocTest

#### Template Básico
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

#### Regras Importantes
- **Sempre use `blocTest` ao invés de `test` manual**
- **Use `seed:` para testar com estados iniciais específicos**
- **Configure mocks no `build:` e nunca no `setUp()` ou `setUpAll()`**
- **Use `isA<StateType>()` ao invés de instâncias específicas no `expect:`**
- **Sempre implemente seção `verify:` para verificar side effects**

#### Organização por Evento
```dart
void main() {
  group('WithdrawBloc', () {
    group('LoadWithdrawsEvent', () {
      blocTest<WithdrawBloc, WithdrawState>(
        'should emit [LoadingState, LoadedState] when loading successfully',
        build: () => bloc,
        act: (bloc) => bloc.add(LoadWithdrawsEvent()),
        expect: () => [isA<LoadingState>(), isA<LoadedState>()],
      );
    });

    group('RequestWithdrawEvent', () {
      blocTest<WithdrawBloc, WithdrawState>(
        'should emit [LoadingState, SuccessState] when request succeeds',
        build: () => bloc,
        act: (bloc) => bloc.add(RequestWithdrawEvent(amount: 1000.0)),
        expect: () => [isA<LoadingState>(), isA<SuccessState>()],
      );
    });

    group('Edge Cases and Error Handling', () {
      // Testes de cenários extremos
    });
  });
}
```

### Cenários de Erro Obrigatórios

Para cada evento de Bloc, teste no mínimo:

1. **Success case:** comportamento padrão esperado
2. **Error case:** falha genérica da API/repository
3. **Offline case:** usuário sem conectividade (`ErrorOfflineState`)
4. **Timeout case:** falha por timeout (`ErrorTimeoutState`)
5. **User session case:** sessão expirada (`ErrorUserSessionState`)
6. **Empty data case:** resposta vazia mas válida
7. **Specific business errors:** falhas específicas do negócio

```dart
group('Edge Cases and Error Handling', () {
  blocTest<WithdrawBloc, WithdrawState>(
    'should emit [LoadingState, ErrorOfflineState] when offline',
    build: () {
      when(() => connectivityHelperMock.isConnectionDown())
          .thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWithdrawsEvent()),
    expect: () => [isA<LoadingState>(), isA<ErrorOfflineState>()],
    verify: (bloc) {
      verify(() => connectivityHelperMock.isConnectionDown()).called(1);
      verifyNoMoreInteractions(connectivityHelperMock);
      verifyNoMoreInteractions(repositoryMock); // Não deve chamar repository
    },
  );

  blocTest<WithdrawBloc, WithdrawState>(
    'should emit [LoadingState, ErrorTimeoutState] when timeout occurs',
    build: () {
      when(() => connectivityHelperMock.isConnectionDown())
          .thenAnswer((_) async => false);
      when(() => repositoryMock.getWithdraws())
          .thenAnswer((_) async => const Left(TimeoutFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWithdrawsEvent()),
    expect: () => [isA<LoadingState>(), isA<ErrorTimeoutState>()],
  );
});
```

### Verificação de Parâmetros e Interações

```dart
// ✅ Correto - verificar parâmetros específicos
verify(() => repository.getItems(page: '1', status: 'active')).called(1);

// ❌ Evitar - usar any() genérico
verify(() => repository.getItems(page: any(named: 'page'))).called(1);
```

**Verificações obrigatórias:**
- Verifique o número exato de chamadas: `.called(1)`, `.called(2)`, `never`
- Use `verifyInOrder()` quando a ordem das chamadas for importante
- Use `verifyNoMoreInteractions()` para garantir que nenhuma chamada não esperada foi feita
- Verifique todas as dependências em sequência

```dart
verify: (bloc) {
  verify(() => connectivityHelper.isConnectionDown()).called(1);
  verify(() => repository.getData()).called(1);
  verify(() => databaseHelper.save()).called(1);
  verifyNoMoreInteractions(connectivityHelper);
  verifyNoMoreInteractions(repository);
  verifyNoMoreInteractions(databaseHelper);
  
  // Verificar estado final
  final state = bloc.state as LoadedState;
  expect(state.data, isNotEmpty);
  expect(bloc.internalList?.length, 5);
}
```

### Uso de seed para Estados Iniciais

```dart
blocTest<AffiliationBloc, AffiliationState>(
  'should approve request and update list when approve succeeds',
  seed: () => AffiliationLoadedState(
    requests: [
      pendingRequest,
      approvedRequest,
    ],
  ),
  build: () {
    when(() => repositoryMock.approveRequest(requestId: any(named: 'requestId')))
        .thenAnswer((_) async => const Right(true));
    return bloc;
  },
  act: (bloc) => bloc.add(ApproveRequestEvent(requestId: '123')),
  expect: () => [
    isA<AffiliationLoadingState>(),
    isA<AffiliationLoadedState>(),
  ],
  verify: (bloc) {
    final state = bloc.state as AffiliationLoadedState;
    final approvedItem = state.requests.firstWhere((r) => r.id == '123');
    expect(approvedItem.status, AffiliationStatus.approved);
  },
);
```

### Funções Auxiliares para Mocks

Após finalizar todos os testes e garantir que passam, revise e crie funções auxiliares para mocks que se repetem 2 ou mais vezes:

```dart
// Funções auxiliares locais
void mockOnlineConnection() {
  when(() => connectivityHelperMock.isConnectionDown())
      .thenAnswer((_) async => false);
}

void mockOfflineConnection() {
  when(() => connectivityHelperMock.isConnectionDown())
      .thenAnswer((_) async => true);
}

void mockRepositorySuccess(List<AffiliationRequest> data) {
  when(() => repositoryMock.getAllRequests())
      .thenAnswer((_) async => Right(data));
}

void mockDatabaseSave() {
  when(() => databaseHelperMock.saveRequests(any()))
      .thenAnswer((_) async => const Right(true));
}
```

**Regras:**
- Crie funções auxiliares apenas quando usadas 2+ vezes
- Funções usadas uma única vez devem ser inline no teste
- Prefira helpers da pasta `/test/core/helpers` quando possível

## Testes de Models

### Estrutura de Testes
```dart
void main() {
  group('WithdrawModel', () {
    group('fromApi', () {
      test('should create model from valid API data', () {
        // Arrange
        const data = WithdrawModelFixture.validData;

        // Act
        final model = WithdrawModel.fromApi(map: data);

        // Assert
        expect(model.id, '123');
        expect(model.amount, 1000.0);
        expect(model.status, WithdrawStatus.pending);
      });

      test('should throw exception when data is invalid', () {
        // Arrange
        const data = WithdrawModelFixture.invalidData;

        // Act & Assert
        expect(
          () => WithdrawModel.fromApi(map: data),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });
}
```

## Testes de Entities

### Testes de Equality Obrigatórios

Use a função auxiliar `HelpersTestUtils.testObjectEquality` para testar igualdade:

```dart
import 'package:flutter-template/core/utils/helpers_test_utils.dart';

void main() {
  group('WithdrawEntity', () {
    group('Equality', () {
      test('should implement equality correctly', () {
        HelpersTestUtils.testObjectEquality(
          baseInstance: WithdrawEntityFixture.baseInstance,
          instanceWithSameProps: WithdrawEntityFixture.instanceWithSameProps,
          instanceWithDifferentProps: WithdrawEntityFixture.instanceWithDifferentProps,
        );
      });
    });
  });
}
```

**IMPORTANTE:** Sempre use `HelpersTestUtils.testObjectEquality` para garantir:
- Padronização nos testes
- Evitar duplicação de código
- Cobrir todos aspectos de igualdade (`==`, `hashCode`, `props`)

## Testes de Events do Bloc

### Estrutura de Testes
```dart
void main() {
  group('WithdrawEvent', () {
    group('RequestWithdrawEvent', () {
      test('should create event with correct properties', () {
        // Arrange
        const amount = 1000.0;

        // Act
        final event = RequestWithdrawEvent(amount: amount);

        // Assert
        expect(event.amount, amount);
      });

      test('should include properties in props for equality', () {
        // Arrange
        const amount = 1000.0;

        // Act
        final event1 = RequestWithdrawEvent(amount: amount);
        final event2 = RequestWithdrawEvent(amount: amount);
        final event3 = RequestWithdrawEvent(amount: 2000.0);

        // Assert
        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('should extend WithdrawEvent', () {
        // Arrange & Act
        final event = RequestWithdrawEvent(amount: 1000.0);

        // Assert
        expect(event, isA<WithdrawEvent>());
      });
    });
  });
}
```

**IMPORTANTE:** Não implemente testes de equality usando `HelpersTestUtils.testObjectEquality` para Events. Foque em:
1. Criação do evento
2. Verificação de propriedades
3. Verificação de que propriedades estão em `props`
4. Herança da classe base

## Testes de States do Bloc

### Estrutura de Testes
```dart
void main() {
  group('WithdrawState', () {
    test('should use final instead of const for state instances', () {
      // ✅ Correto - usar final
      final state1 = WithdrawLoadingState();
      final state2 = WithdrawLoadingState();

      // States sem atributos devem ser diferentes devido a identityHashCode
      expect(state1, isNot(equals(state2)));
    });

    group('WithdrawSuccessState', () {
      test('should include properties in props', () {
        // Arrange
        final withdraw1 = WithdrawEntityFixture.baseInstance;
        final withdraw2 = WithdrawEntityFixture.baseInstance;
        final withdraw3 = WithdrawEntityFixture.different;

        // Act
        final state1 = WithdrawSuccessState(withdraw: withdraw1);
        final state2 = WithdrawSuccessState(withdraw: withdraw2);
        final state3 = WithdrawSuccessState(withdraw: withdraw3);

        // Assert - States com mesmas propriedades devem ser iguais
        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });
    });
  });
}
```

**IMPORTANTE:** Use `final` ao invés de `const` para states em testes, pois as classes não possuem construtores const.

## Fixtures

### Fixtures de Models

#### Estrutura e Documentação
```dart
/// Fixture para testes do [WithdrawModel].
///
/// Fornece dados de exemplo representando diferentes estados de saque
/// baseados nas respostas reais da API.
class WithdrawModelFixture {
  /// Dados de um saque pendente de aprovação.
  ///
  /// Representa um saque solicitado mas ainda não processado.
  static const Map<String, dynamic> pendingWithdraw = {
    'id': '123',
    'amount': 'R$ 1.000,00',
    'status': 'pending',
    'created_at': '2024-01-15T10:30:00Z',
  };

  /// Dados de um saque aprovado e processado.
  static const Map<String, dynamic> approvedWithdraw = {
    'id': '456',
    'amount': 'R$ 2.500,00',
    'status': 'approved',
    'created_at': '2024-01-10T14:20:00Z',
    'processed_at': '2024-01-12T09:15:00Z',
  };

  /// Dados inválidos para teste de validação.
  ///
  /// Usado para testar tratamento de erros quando a API retorna dados mal-formados.
  static const Map<String, dynamic> invalidData = {
    'id': null,
    'amount': 'invalid',
    'status': 'unknown_status',
  };
}
```

#### Regras para Fixtures de Models
1. Use `static const Map<String, dynamic>` para todos os dados
2. Mantenha os dados hard coded inline exatamente como vêm da API
3. Nomeie seguindo o padrão:
   - `validData` para dados válidos padrão
   - `invalidData` para dados inválidos
   - `customData` para variações específicas
4. Documente cada método explicando seu propósito
5. Mantenha os dados realistas, copiados diretamente da API
6. Use valores formatados como na API (ex: 'R$ 1.000,00')
7. Não crie métodos intermediários - mantenha os dados diretos

### Fixtures de Entities

#### Com Model Correspondente
```dart
/// Fixture para testes do [WithdrawEntity].
///
/// As instâncias são criadas a partir dos dados do [WithdrawModelFixture]
/// para garantir consistência entre models e entities.
class WithdrawEntityFixture {
  /// Instância de saque pendente.
  static final WithdrawEntity pending = WithdrawModel.fromApi(
    map: WithdrawModelFixture.pendingWithdraw,
  );

  /// Instância de saque aprovado.
  static final WithdrawEntity approved = WithdrawModel.fromApi(
    map: WithdrawModelFixture.approvedWithdraw,
  );
}
```

#### Para Testes de Equality
```dart
/// Fixture para testes de igualdade do [WithdrawEntity].
class WithdrawEntityFixture {
  /// Instância base para comparação.
  static const WithdrawEntity baseInstance = WithdrawEntity(
    id: '123',
    amount: 1000.0,
    status: WithdrawStatus.pending,
    createdAt: '2024-01-15',
  );

  /// Instância com mesmas propriedades da base.
  static const WithdrawEntity instanceWithSameProps = WithdrawEntity(
    id: '123',
    amount: 1000.0,
    status: WithdrawStatus.pending,
    createdAt: '2024-01-15',
  );

  /// Instância com propriedades diferentes.
  static const WithdrawEntity instanceWithDifferentProps = WithdrawEntity(
    id: '456',
    amount: 2000.0,
    status: WithdrawStatus.approved,
    createdAt: '2024-01-20',
  );
}
```

#### Regras para Fixtures de Entities
1. Use `static const` para todas as instâncias
2. Nomeie as instâncias seguindo o padrão:
   - `baseInstance` para instância base de comparação
   - `instanceWithSameProps` para instância com mesmas propriedades
   - `instanceWithDifferentProps` para instância com propriedades diferentes
3. **IMPORTANTE:** Se a entity tem model correspondente, sempre use os dados do model fixture via `Model.fromApi()`
4. Documente cada instância explicando seu propósito
5. Mantenha os dados realistas e consistentes com o model fixture
6. Não crie métodos - use apenas instâncias const
7. Use construtores const para instâncias quando possível
8. Prefira propriedades const sobre métodos factory quando os valores são estáticos
9. Use factory methods apenas quando precisar de valores dinâmicos ou customização

#### IMPORTANTE: Não Permita Duplicatas
```dart
// ❌ Evitar - Dados duplicados
class MyFixture {
  static const data1 = {'id': '123', 'name': 'Test'};
  static const data2 = {'id': '123', 'name': 'Test'}; // Duplicata!
}

// ✅ Correto - Reutilize a mesma constante
class MyFixture {
  static const validData = {'id': '123', 'name': 'Test'};
  // Use validData em múltiplos testes
}
```

### Fixtures - Map vs JSON String

**IMPORTANTE:** Fixtures devem retornar `Map<String, dynamic>` ao invés de String JSON:

```dart
// ✅ Correto - Map<String, dynamic>
class UserFixture {
  static const Map<String, dynamic> validData = {
    'id': '123',
    'name': 'John Doe',
    'email': 'john@example.com',
  };
}

// ❌ Evitar - JSON String
class UserFixture {
  static const String validData = '''
  {
    "id": "123",
    "name": "John Doe",
    "email": "john@example.com"
  }
  ''';
}
```

**Razões:**
- Melhor performance (sem overhead de parsing)
- Type safety em tempo de compilação
- Facilidade de uso nos testes
- Evita erros de JSON inválido

## Mocks

### Estrutura e Documentação
```dart
/// Mock do [ApiService] para testes unitários.
///
/// Fornece métodos auxiliares para simular respostas da API
/// em diferentes cenários (sucesso, erro, timeout, etc).
class ApiServiceMock extends Mock implements ApiService {
  /// Configura comportamentos padrão do mock.
  ///
  /// Deve ser chamado no setUp() de cada teste para garantir
  /// estado inicial consistente.
  static void setupDefaults(ApiServiceMock mock) {
    when(() => mock.get(any())).thenAnswer(
      (_) async => ApiServiceMock.createSuccessResponse(data: {}),
    );
  }

  /// Cria uma resposta de sucesso simulada.
  ///
  /// Útil para mockar chamadas bem-sucedidas da API.
  static ApiResponse createSuccessResponse({
    required Map<String, dynamic> data,
  }) {
    return ApiResponse(
      statusCode: 200,
      data: data,
      success: true,
    );
  }

  /// Cria uma resposta de erro genérico.
  static ApiResponse createErrorResponse() {
    return ApiResponse(
      statusCode: 500,
      data: {},
      success: false,
    );
  }

  /// Cria uma resposta de timeout.
  static ApiResponse createTimeoutResponse() {
    return ApiResponse(
      statusCode: 408,
      data: {},
      success: false,
    );
  }

  /// Cria uma resposta de erro de sessão expirada.
  static ApiResponse createUserSessionErrorResponse() {
    return ApiResponse(
      statusCode: 401,
      data: {},
      success: false,
    );
  }
}
```

### Configuração de Mocks

#### setupDefaults
```dart
class ConnectivityHelperMock extends Mock implements ConnectivityHelper {
  static void setupDefaults(ConnectivityHelperMock mock) {
    // Comportamento padrão: online
    when(() => mock.isConnectionDown()).thenAnswer((_) async => false);
  }
}
```

#### registerFallbackValue
```dart
class ApiRequestFake extends Fake implements ApiRequest {}

setUpAll(() {
  registerFallbackValue(ApiRequestFake());
});
```

### Uso dos Métodos Utilitários

**IMPORTANTE:** Sempre use os métodos utilitários do mock ao invés de criar instâncias diretamente:

```dart
// ✅ Correto - Usar métodos utilitários
when(() => apiServiceMock.get(any())).thenAnswer(
  (_) async => ApiServiceMock.createSuccessResponse(
    data: UserModelFixture.validData,
  ),
);

// ❌ Evitar - Criar ApiResponse diretamente
when(() => apiServiceMock.get(any())).thenAnswer(
  (_) async => ApiResponse(
    statusCode: 200,
    data: UserModelFixture.validData,
    success: true,
  ),
);
```

**Métodos disponíveis:**
- `createSuccessResponse()` para respostas de sucesso
- `createErrorResponse()` para respostas de erro genérico
- `createTimeoutResponse()` para respostas de timeout
- `createUserSessionErrorResponse()` para respostas de sessão expirada

### Organização de Mocks

- Crie mocks específicos por classe em arquivos separados
- Implemente métodos `setupDefaults()` estáticos
- Use `registerFallbackValue()` para tipos complexos
- Configure mocks no `setUpAll()` para dados que não mudam
- Use `setUp()` para configurações que precisam ser resetadas

## Helpers de Teste

### Helpers Globais (`test/test_helpers.dart`)

Centralize funções auxiliares usadas em múltiplas features:

```dart
/// Configura mocks globais usados em múltiplos testes.
void setupGlobalMocks() {
  // Configuração global
}
```

### Helpers por Feature (`test/features/[feature]/[feature]_test_helpers.dart`)

Centralize funções auxiliares específicas de uma feature:

```dart
/// Configura mock do repository para retornar sucesso.
void mockGetAllDataSuccess(
  AffiliationRepositoryMock mock,
  Either<Failure?, List<AffiliationRequest>> result,
) {
  when(() => mock.getAllRequests()).thenAnswer((_) async => result);
}

/// Configura mock do repository para retornar erro.
void mockGetAllDataError(AffiliationRepositoryMock mock) {
  when(() => mock.getAllRequests())
      .thenAnswer((_) async => const Left(null));
}
```

**Regras:**
- Externalize mocks de repository em funções genéricas que recebem `Either` como parâmetro
- Permite reutilização em múltiplos testes de UseCases
- Crie funções auxiliares apenas quando usadas 2+ vezes
- Funções usadas uma única vez devem ser inline no teste

### IMPORTANTE: Use Helpers Existentes

**Sempre dar preferência aos helpers da pasta `/test/core/helpers`:**

```dart
// ✅ Correto - Usar helpers centrais
ApiServiceMock.setupDefaults(apiServiceMock);
ConnectivityHelperMock.setupDefaults(connectivityHelperMock);

// ❌ Evitar - Reconfigurar comportamentos já definidos
when(() => connectivityHelperMock.isConnectionDown())
    .thenAnswer((_) async => false); // setupDefaults() já faz isso
```

**Apenas use helpers específicos da feature quando a funcionalidade não existir nos helpers centrais.**

## Nomenclatura e Organização

### Títulos de Testes

```dart
// ✅ Bom - Claro, específico, descreve o comportamento
test('should return available balance when user has transactions', () {});
test('should throw FormatException when CPF has less than 11 digits', () {});

// ✅ Bom para Bloc - Descreve estados emitidos e cenário
blocTest<WithdrawBloc, WithdrawState>(
  'should emit [LoadingState, LoadedState] when loading withdraws successfully',
  // ...
);

// ❌ Evitar - Vago, não descreve o comportamento
test('test balance', () {});
test('CPF validation', () {});
blocTest<WithdrawBloc, WithdrawState>(
  'load withdraws',
  // ...
);
```

### Organização de Grupos

```dart
void main() {
  group('WithdrawDataSource', () {
    group('requestWithdraw', () {
      test('should return success when API call succeeds', () {});
      test('should return TimeoutFailure when request times out', () {});
      test('should return OfflineFailure when device is offline', () {});
    });
    
    group('Edge Cases and Error Handling', () {
      test('should handle null response gracefully', () {});
      test('should retry on network error', () {});
    });
  });
}
```

## Boas Práticas Gerais

### DOs - O Que Fazer
✅ Use padrão AAA (Arrange, Act, Assert) em todos os testes
✅ Use `blocTest` para testar Blocs
✅ Use Mocktail para mocks
✅ Use `HelpersTestUtils.testObjectEquality` para testes de igualdade
✅ Use fixtures existentes ao invés de dados inline
✅ Use métodos utilitários dos mocks para criar respostas
✅ Separe testes de comportamento e interação
✅ Use matchers específicos ao invés de `equals()`
✅ Organize testes espelhando estrutura de `/lib`
✅ Use `reset()` no `tearDown()`
✅ Configure mocks no `build:` para testes de Bloc
✅ Use `final` para states em testes (não `const`)
✅ Verifique parâmetros específicos nas chamadas de método
✅ Use `verifyNoMoreInteractions()` para garantir limpeza
✅ Teste todos os cenários de erro obrigatórios
✅ Documente fixtures e helpers complexos

### DON'Ts - O Que Evitar
❌ Não crie novos helpers quando existem helpers centrais
❌ Não use `any()` genérico para verificar parâmetros
❌ Não crie mocks desnecessários (use DataSource diretamente)
❌ Não permita fixtures com dados duplicados
❌ Não use JSON String ao invés de Map para fixtures
❌ Não configure mocks no `setUp()` para testes de Bloc
❌ Não use `reset()` no `setUp()` (use no `tearDown()`)
❌ Não crie funções auxiliares usadas apenas uma vez
❌ Não use `equals()` genérico quando há matcher específico
❌ Não modifique dados de fixtures ao refatorar testes
❌ Não documente testes auto-explicativos
❌ Não use `const` para states em testes

## Checklist de Qualidade

### Antes de Commitar
- [ ] Todos os testes passam
- [ ] Cobertos success, error, offline, timeout, session expired
- [ ] Fixtures criadas para dados repetidos
- [ ] Mocks usam métodos utilitários
- [ ] Verificações incluem `verifyNoMoreInteractions()`
- [ ] Parâmetros específicos verificados (não `any()`)
- [ ] Funções auxiliares criadas apenas quando usadas 2+ vezes
- [ ] `reset()` está no `tearDown()`, não no `setUp()`
- [ ] Matchers específicos usados ao invés de `equals()`
- [ ] Testes de Bloc usam `blocTest` com `verify:`
- [ ] Titles descritivos em inglês americano
- [ ] Grupos organizados por funcionalidade
- [ ] Sem dados duplicados em fixtures

### Code Review
- [ ] Estrutura de testes espelha estrutura de `/lib`
- [ ] Fixtures bem documentadas
- [ ] Mocks têm `setupDefaults()`
- [ ] Helpers existentes são reutilizados
- [ ] Testes de equality usam `HelpersTestUtils.testObjectEquality`
- [ ] Testes de Bloc verificam estado final no `verify:`
- [ ] Sem configurações redundantes de mocks
- [ ] DataSource usado diretamente em testes de UseCase

## Referências

### Documentação Oficial
- [Effective Dart: Testing](https://dart.dev/guides/testing)
- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Bloc Testing Documentation](https://bloclibrary.dev/#/testing)
- [Mocktail Package](https://pub.dev/packages/mocktail)

### Padrões do Projeto
- Sempre consulte `@/test/core/helpers` para helpers existentes
- Siga exemplos em `@/test/features/affiliation` para estrutura de Bloc
- Use `@helpers_test_utils.dart` para utilitários de teste
- Consulte arquivos `*_fixture.dart` existentes para padrões
# Regras de Testes Unitários

## Princípios Gerais

### Idioma e Convenções
- **Títulos de testes devem ser em inglês americano, com linguagem simples e direta**
- **Exemplo: "should return valid data when login is successful"**
- **Use doc comments (///) em português para fixtures e test helpers**
- **Documente apenas testes complexos ou não óbvios**
- **Evite documentar testes auto-explicativos**

### Padrão AAA (Arrange, Act, Assert)
```dart
test('should return user when credentials are valid', () {
  // Arrange - Configuração
  const email = 'user@example.com';
  const password = 'password123';
  when(() => repository.login(email, password))
      .thenAnswer((_) async => Right(user));

  // Act - Execução
  final result = await useCase(email: email, password: password);

  // Assert - Verificação
  expect(result.isRight(), isTrue);
  expect(result.getOrElse(() => throw Exception()), user);
});
```

### Separação de Testes
- **Teste de comportamento: Verifica o que o método retorna (usando expect)**
- **Teste de interação: Verifica como o método interage com dependências (usando verify)**
- **Exceção: Use expect e verify no mesmo teste apenas quando verificar que uma dependência NÃO foi chamada**
- **Para testes de Bloc, combine verificação de comportamento (expect) e interação (verify) no mesmo teste usando o bloco `verify:` do `blocTest`**

### Matchers Específicos
Use matchers específicos ao invés de `equals()` genérico:

```dart
// ✅ Correto - Matchers específicos
expect(isOnline, isTrue);
expect(user, isNull);
expect(products, isEmpty);
expect(products.length, equals(5));
expect(result, isA<SuccessState>());

// ❌ Evitar - equals() genérico
expect(isOnline, equals(true));
expect(user, equals(null));
expect(products.isEmpty, equals(true));
```

**Lista de matchers recomendados:**
- **Booleanos:** `isTrue`, `isFalse`
- **Null:** `isNull`, `isNotNull`
- **Tipos:** `isA<T>()`
- **Coleções:** `isEmpty`, `isNotEmpty`, `hasLength(n)`, `contains(item)`
- **Strings:** `startsWith()`, `endsWith()`, `contains()`, `matches()`
- **Números:** `greaterThan()`, `lessThan()`, `closeTo()`
- **Exceções:** `throwsA()`, `throwsException()`, `throwsArgumentError()`
- **Mocks:** `called()`, `never`, `calledOnce`

## Estrutura de Organização

### Hierarquia de Arquivos
Organize a estrutura de testes espelhando a estrutura da pasta `/lib`:

```
test/
├── core/
│   ├── helpers/          # Mocks e fixtures dos helpers
│   └── services/         # Mocks e fixtures dos services
├── features/
│   └── [feature]/
│       ├── data/         # Testes de DataSources e Models
│       ├── domain/       # Testes de Entities, Repositories e UseCases
│       └── presentation/ # Testes de Blocs, States e Events
└── test_helpers.dart     # Funções auxiliares globais
```

### Padrões de Nomenclatura

#### Arquivos
- **Mock files:** sufixo `_mock.dart` (ex: `connectivity_helper_mock.dart`)
- **Fixture files:** sufixo `_fixture.dart` (ex: `user_login_data_fixture.dart`)
- **Test helpers:** sufixo `_test_helpers.dart` (ex: `login_test_helpers.dart`)

#### Classes
- **Mock classes:** sufixo `Mock` (ex: `ConnectivityHelperMock`, `ApiServiceMock`)
- **Fake classes:** sufixo `Fake` (ex: `BuildContextFake`, `ApiRequestFake`)
- **Fixture classes:** sufixo `Fixture` (ex: `UserLoginDataFixture`)

#### Variáveis
- **Variáveis mock:** sufixo `Mock` em camelCase (ex: `apiServiceMock`, `firebaseCrashlyticsMock`)
- **Dados de teste:** nomes descritivos ao contexto (ex: `successResponse`, `errorResponse`, `invalidDataResponse`)

**Exemplos:**
```dart
// ✅ Correto
late BankingAccountRepositoryMock bankingAccountRepositoryMock;
late ConnectivityHelperMock connectivityHelperMock;

// ❌ Evitar
late BankingAccountRepositoryMock repository;
late ConnectivityHelperMock connectivity;
```

### Acesso a Elementos de Lista
```dart
// ✅ Correto - Prefira .first
final firstItem = list.first;

// ✅ Correto - Extraia para variável quando usado múltiplas vezes
final requestItem = bloc.requestsList!.first;
expect(requestItem.id, '123');
expect(requestItem.status, AffiliationStatus.approved);

// ❌ Evitar - [0] é menos seguro
final firstItem = list[0];

// ❌ Evitar - Acesso repetido
expect(bloc.requestsList![0].id, '123');
expect(bloc.requestsList![0].status, AffiliationStatus.approved);
```

## Testes de UseCase

### Estrutura Obrigatória

#### IMPORTANTE: Use DataSource Diretamente
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

#### Mocks Necessários
1. `ApiServiceMock` para simular chamadas da API
2. `FirebaseCrashlyticsMock` para logs de erro
3. `DeviceHelperMock` para dados do dispositivo
4. Outros mocks específicos conforme necessidade do DataSource

#### Configuração no setUp/tearDown
```dart
late ApiServiceMock apiServiceMock;
late FirebaseCrashlyticsMock firebaseCrashlyticsMock;
late DeviceHelperMock deviceHelperMock;
late SettingsDataSource dataSource;
late PostDeviceUpdateSettingsUseCase useCase;

setUp(() {
  // Inicializar mocks
  apiServiceMock = ApiServiceMock();
  firebaseCrashlyticsMock = FirebaseCrashlyticsMock();
  deviceHelperMock = DeviceHelperMock();
  
  // Configurar defaults
  ApiServiceMock.setupDefaults(apiServiceMock);
  DeviceHelperMock.setupDefaults(deviceHelperMock);
  
  // Criar DataSource e UseCase
  dataSource = SettingsDataSource(
    apiService: apiServiceMock,
    firebaseCrashlytics: firebaseCrashlyticsMock,
    deviceHelper: deviceHelperMock,
  );
  useCase = PostDeviceUpdateSettingsUseCase(repository: dataSource);
});

tearDown(() {
  reset(apiServiceMock);
  reset(firebaseCrashlyticsMock);
  reset(deviceHelperMock);
});
```

**IMPORTANTE: reset() no tearDown(), não no setUp()**

**Razões:**
- Garante limpeza mesmo se um teste falhar
- Mantém setUp() focado na configuração inicial
- Segue princípio de "limpar após usar"
- Padrão recomendado pela comunidade Flutter/Dart

#### Grupos de Teste Obrigatórios

```dart
void main() {
  group('PostDeviceUpdateSettingsUseCase', () {
    // Success cases
    group('Success cases', () {
      test('should return Right when API call succeeds', () {});
    });

    // Error cases
    group('Error cases', () {
      test('should return Left(null) for generic error', () {});
      test('should return Left(TimeoutFailure) on timeout', () {});
      test('should return Left(UserSessionFailure) on session expired', () {});
    });

    // Params validation
    group('Params', () {
      test('should validate required parameters', () {});
    });
  });
}
```

#### Verificações Obrigatórias
```dart
test('should return valid data when call succeeds', () async {
  // Arrange
  when(() => apiServiceMock.post(any(), any()))
      .thenAnswer((_) async => ApiServiceMock.createSuccessResponse(
            data: SettingsModelFixture.validData,
          ));

  // Act
  final result = await useCase();

  // Assert
  expect(result.isRight(), isTrue); // Verificar retorno
  expect(result.getOrElse(() => throw Exception()), isA<Settings>()); // Verificar tipo
  
  // Verificar chamadas
  verify(() => deviceHelperMock.getDeviceId()).called(1);
  verify(() => apiServiceMock.post(any(), any())).called(1);
  verifyNoMoreInteractions(apiServiceMock);
  verifyNoMoreInteractions(deviceHelperMock);
});
```

#### Dados de Teste
- Usar fixtures existentes ao invés de dados inline
- Seguir formato da API nas respostas mock
- Usar dados realistas nos parâmetros
- Testar variações de parâmetros

## Testes de Bloc

### Estrutura com blocTest

#### Template Básico
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

#### Regras Importantes
- **Sempre use `blocTest` ao invés de `test` manual**
- **Use `seed:` para testar com estados iniciais específicos**
- **Configure mocks no `build:` e nunca no `setUp()` ou `setUpAll()`**
- **Use `isA<StateType>()` ao invés de instâncias específicas no `expect:`**
- **Sempre implemente seção `verify:` para verificar side effects**

#### Organização por Evento
```dart
void main() {
  group('WithdrawBloc', () {
    group('LoadWithdrawsEvent', () {
      blocTest<WithdrawBloc, WithdrawState>(
        'should emit [LoadingState, LoadedState] when loading successfully',
        build: () => bloc,
        act: (bloc) => bloc.add(LoadWithdrawsEvent()),
        expect: () => [isA<LoadingState>(), isA<LoadedState>()],
      );
    });

    group('RequestWithdrawEvent', () {
      blocTest<WithdrawBloc, WithdrawState>(
        'should emit [LoadingState, SuccessState] when request succeeds',
        build: () => bloc,
        act: (bloc) => bloc.add(RequestWithdrawEvent(amount: 1000.0)),
        expect: () => [isA<LoadingState>(), isA<SuccessState>()],
      );
    });

    group('Edge Cases and Error Handling', () {
      // Testes de cenários extremos
    });
  });
}
```

### Cenários de Erro Obrigatórios

Para cada evento de Bloc, teste no mínimo:

1. **Success case:** comportamento padrão esperado
2. **Error case:** falha genérica da API/repository
3. **Offline case:** usuário sem conectividade (`ErrorOfflineState`)
4. **Timeout case:** falha por timeout (`ErrorTimeoutState`)
5. **User session case:** sessão expirada (`ErrorUserSessionState`)
6. **Empty data case:** resposta vazia mas válida
7. **Specific business errors:** falhas específicas do negócio

```dart
group('Edge Cases and Error Handling', () {
  blocTest<WithdrawBloc, WithdrawState>(
    'should emit [LoadingState, ErrorOfflineState] when offline',
    build: () {
      when(() => connectivityHelperMock.isConnectionDown())
          .thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWithdrawsEvent()),
    expect: () => [isA<LoadingState>(), isA<ErrorOfflineState>()],
    verify: (bloc) {
      verify(() => connectivityHelperMock.isConnectionDown()).called(1);
      verifyNoMoreInteractions(connectivityHelperMock);
      verifyNoMoreInteractions(repositoryMock); // Não deve chamar repository
    },
  );

  blocTest<WithdrawBloc, WithdrawState>(
    'should emit [LoadingState, ErrorTimeoutState] when timeout occurs',
    build: () {
      when(() => connectivityHelperMock.isConnectionDown())
          .thenAnswer((_) async => false);
      when(() => repositoryMock.getWithdraws())
          .thenAnswer((_) async => const Left(TimeoutFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWithdrawsEvent()),
    expect: () => [isA<LoadingState>(), isA<ErrorTimeoutState>()],
  );
});
```

### Verificação de Parâmetros e Interações

```dart
// ✅ Correto - verificar parâmetros específicos
verify(() => repository.getItems(page: '1', status: 'active')).called(1);

// ❌ Evitar - usar any() genérico
verify(() => repository.getItems(page: any(named: 'page'))).called(1);
```

**Verificações obrigatórias:**
- Verifique o número exato de chamadas: `.called(1)`, `.called(2)`, `never`
- Use `verifyInOrder()` quando a ordem das chamadas for importante
- Use `verifyNoMoreInteractions()` para garantir que nenhuma chamada não esperada foi feita
- Verifique todas as dependências em sequência

```dart
verify: (bloc) {
  verify(() => connectivityHelper.isConnectionDown()).called(1);
  verify(() => repository.getData()).called(1);
  verify(() => databaseHelper.save()).called(1);
  verifyNoMoreInteractions(connectivityHelper);
  verifyNoMoreInteractions(repository);
  verifyNoMoreInteractions(databaseHelper);
  
  // Verificar estado final
  final state = bloc.state as LoadedState;
  expect(state.data, isNotEmpty);
  expect(bloc.internalList?.length, 5);
}
```

### Uso de seed para Estados Iniciais

```dart
blocTest<AffiliationBloc, AffiliationState>(
  'should approve request and update list when approve succeeds',
  seed: () => AffiliationLoadedState(
    requests: [
      pendingRequest,
      approvedRequest,
    ],
  ),
  build: () {
    when(() => repositoryMock.approveRequest(requestId: any(named: 'requestId')))
        .thenAnswer((_) async => const Right(true));
    return bloc;
  },
  act: (bloc) => bloc.add(ApproveRequestEvent(requestId: '123')),
  expect: () => [
    isA<AffiliationLoadingState>(),
    isA<AffiliationLoadedState>(),
  ],
  verify: (bloc) {
    final state = bloc.state as AffiliationLoadedState;
    final approvedItem = state.requests.firstWhere((r) => r.id == '123');
    expect(approvedItem.status, AffiliationStatus.approved);
  },
);
```

### Funções Auxiliares para Mocks

Após finalizar todos os testes e garantir que passam, revise e crie funções auxiliares para mocks que se repetem 2 ou mais vezes:

```dart
// Funções auxiliares locais
void mockOnlineConnection() {
  when(() => connectivityHelperMock.isConnectionDown())
      .thenAnswer((_) async => false);
}

void mockOfflineConnection() {
  when(() => connectivityHelperMock.isConnectionDown())
      .thenAnswer((_) async => true);
}

void mockRepositorySuccess(List<AffiliationRequest> data) {
  when(() => repositoryMock.getAllRequests())
      .thenAnswer((_) async => Right(data));
}

void mockDatabaseSave() {
  when(() => databaseHelperMock.saveRequests(any()))
      .thenAnswer((_) async => const Right(true));
}
```

**Regras:**
- Crie funções auxiliares apenas quando usadas 2+ vezes
- Funções usadas uma única vez devem ser inline no teste
- Prefira helpers da pasta `/test/core/helpers` quando possível

## Testes de Models

### Estrutura de Testes
```dart
void main() {
  group('WithdrawModel', () {
    group('fromApi', () {
      test('should create model from valid API data', () {
        // Arrange
        const data = WithdrawModelFixture.validData;

        // Act
        final model = WithdrawModel.fromApi(map: data);

        // Assert
        expect(model.id, '123');
        expect(model.amount, 1000.0);
        expect(model.status, WithdrawStatus.pending);
      });

      test('should throw exception when data is invalid', () {
        // Arrange
        const data = WithdrawModelFixture.invalidData;

        // Act & Assert
        expect(
          () => WithdrawModel.fromApi(map: data),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });
}
```

## Testes de Entities

### Testes de Equality Obrigatórios

Use a função auxiliar `HelpersTestUtils.testObjectEquality` para testar igualdade:

```dart
import 'package:flutter-template/core/utils/helpers_test_utils.dart';

void main() {
  group('WithdrawEntity', () {
    group('Equality', () {
      test('should implement equality correctly', () {
        HelpersTestUtils.testObjectEquality(
          baseInstance: WithdrawEntityFixture.baseInstance,
          instanceWithSameProps: WithdrawEntityFixture.instanceWithSameProps,
          instanceWithDifferentProps: WithdrawEntityFixture.instanceWithDifferentProps,
        );
      });
    });
  });
}
```

**IMPORTANTE:** Sempre use `HelpersTestUtils.testObjectEquality` para garantir:
- Padronização nos testes
- Evitar duplicação de código
- Cobrir todos aspectos de igualdade (`==`, `hashCode`, `props`)

## Testes de Events do Bloc

### Estrutura de Testes
```dart
void main() {
  group('WithdrawEvent', () {
    group('RequestWithdrawEvent', () {
      test('should create event with correct properties', () {
        // Arrange
        const amount = 1000.0;

        // Act
        final event = RequestWithdrawEvent(amount: amount);

        // Assert
        expect(event.amount, amount);
      });

      test('should include properties in props for equality', () {
        // Arrange
        const amount = 1000.0;

        // Act
        final event1 = RequestWithdrawEvent(amount: amount);
        final event2 = RequestWithdrawEvent(amount: amount);
        final event3 = RequestWithdrawEvent(amount: 2000.0);

        // Assert
        expect(event1, equals(event2));
        expect(event1, isNot(equals(event3)));
      });

      test('should extend WithdrawEvent', () {
        // Arrange & Act
        final event = RequestWithdrawEvent(amount: 1000.0);

        // Assert
        expect(event, isA<WithdrawEvent>());
      });
    });
  });
}
```

**IMPORTANTE:** Não implemente testes de equality usando `HelpersTestUtils.testObjectEquality` para Events. Foque em:
1. Criação do evento
2. Verificação de propriedades
3. Verificação de que propriedades estão em `props`
4. Herança da classe base

## Testes de States do Bloc

### Estrutura de Testes
```dart
void main() {
  group('WithdrawState', () {
    test('should use final instead of const for state instances', () {
      // ✅ Correto - usar final
      final state1 = WithdrawLoadingState();
      final state2 = WithdrawLoadingState();

      // States sem atributos devem ser diferentes devido a identityHashCode
      expect(state1, isNot(equals(state2)));
    });

    group('WithdrawSuccessState', () {
      test('should include properties in props', () {
        // Arrange
        final withdraw1 = WithdrawEntityFixture.baseInstance;
        final withdraw2 = WithdrawEntityFixture.baseInstance;
        final withdraw3 = WithdrawEntityFixture.different;

        // Act
        final state1 = WithdrawSuccessState(withdraw: withdraw1);
        final state2 = WithdrawSuccessState(withdraw: withdraw2);
        final state3 = WithdrawSuccessState(withdraw: withdraw3);

        // Assert - States com mesmas propriedades devem ser iguais
        expect(state1, equals(state2));
        expect(state1, isNot(equals(state3)));
      });
    });
  });
}
```

**IMPORTANTE:** Use `final` ao invés de `const` para states em testes, pois as classes não possuem construtores const.

## Fixtures

### Fixtures de Models

#### Estrutura e Documentação
```dart
/// Fixture para testes do [WithdrawModel].
///
/// Fornece dados de exemplo representando diferentes estados de saque
/// baseados nas respostas reais da API.
class WithdrawModelFixture {
  /// Dados de um saque pendente de aprovação.
  ///
  /// Representa um saque solicitado mas ainda não processado.
  static const Map<String, dynamic> pendingWithdraw = {
    'id': '123',
    'amount': 'R$ 1.000,00',
    'status': 'pending',
    'created_at': '2024-01-15T10:30:00Z',
  };

  /// Dados de um saque aprovado e processado.
  static const Map<String, dynamic> approvedWithdraw = {
    'id': '456',
    'amount': 'R$ 2.500,00',
    'status': 'approved',
    'created_at': '2024-01-10T14:20:00Z',
    'processed_at': '2024-01-12T09:15:00Z',
  };

  /// Dados inválidos para teste de validação.
  ///
  /// Usado para testar tratamento de erros quando a API retorna dados mal-formados.
  static const Map<String, dynamic> invalidData = {
    'id': null,
    'amount': 'invalid',
    'status': 'unknown_status',
  };
}
```

#### Regras para Fixtures de Models
1. Use `static const Map<String, dynamic>` para todos os dados
2. Mantenha os dados hard coded inline exatamente como vêm da API
3. Nomeie seguindo o padrão:
   - `validData` para dados válidos padrão
   - `invalidData` para dados inválidos
   - `customData` para variações específicas
4. Documente cada método explicando seu propósito
5. Mantenha os dados realistas, copiados diretamente da API
6. Use valores formatados como na API (ex: 'R$ 1.000,00')
7. Não crie métodos intermediários - mantenha os dados diretos

### Fixtures de Entities

#### Com Model Correspondente
```dart
/// Fixture para testes do [WithdrawEntity].
///
/// As instâncias são criadas a partir dos dados do [WithdrawModelFixture]
/// para garantir consistência entre models e entities.
class WithdrawEntityFixture {
  /// Instância de saque pendente.
  static final WithdrawEntity pending = WithdrawModel.fromApi(
    map: WithdrawModelFixture.pendingWithdraw,
  );

  /// Instância de saque aprovado.
  static final WithdrawEntity approved = WithdrawModel.fromApi(
    map: WithdrawModelFixture.approvedWithdraw,
  );
}
```

#### Para Testes de Equality
```dart
/// Fixture para testes de igualdade do [WithdrawEntity].
class WithdrawEntityFixture {
  /// Instância base para comparação.
  static const WithdrawEntity baseInstance = WithdrawEntity(
    id: '123',
    amount: 1000.0,
    status: WithdrawStatus.pending,
    createdAt: '2024-01-15',
  );

  /// Instância com mesmas propriedades da base.
  static const WithdrawEntity instanceWithSameProps = WithdrawEntity(
    id: '123',
    amount: 1000.0,
    status: WithdrawStatus.pending,
    createdAt: '2024-01-15',
  );

  /// Instância com propriedades diferentes.
  static const WithdrawEntity instanceWithDifferentProps = WithdrawEntity(
    id: '456',
    amount: 2000.0,
    status: WithdrawStatus.approved,
    createdAt: '2024-01-20',
  );
}
```

#### Regras para Fixtures de Entities
1. Use `static const` para todas as instâncias
2. Nomeie as instâncias seguindo o padrão:
   - `baseInstance` para instância base de comparação
   - `instanceWithSameProps` para instância com mesmas propriedades
   - `instanceWithDifferentProps` para instância com propriedades diferentes
3. **IMPORTANTE:** Se a entity tem model correspondente, sempre use os dados do model fixture via `Model.fromApi()`
4. Documente cada instância explicando seu propósito
5. Mantenha os dados realistas e consistentes com o model fixture
6. Não crie métodos - use apenas instâncias const
7. Use construtores const para instâncias quando possível
8. Prefira propriedades const sobre métodos factory quando os valores são estáticos
9. Use factory methods apenas quando precisar de valores dinâmicos ou customização

#### IMPORTANTE: Não Permita Duplicatas
```dart
// ❌ Evitar - Dados duplicados
class MyFixture {
  static const data1 = {'id': '123', 'name': 'Test'};
  static const data2 = {'id': '123', 'name': 'Test'}; // Duplicata!
}

// ✅ Correto - Reutilize a mesma constante
class MyFixture {
  static const validData = {'id': '123', 'name': 'Test'};
  // Use validData em múltiplos testes
}
```

### Fixtures - Map vs JSON String

**IMPORTANTE:** Fixtures devem retornar `Map<String, dynamic>` ao invés de String JSON:

```dart
// ✅ Correto - Map<String, dynamic>
class UserFixture {
  static const Map<String, dynamic> validData = {
    'id': '123',
    'name': 'John Doe',
    'email': 'john@example.com',
  };
}

// ❌ Evitar - JSON String
class UserFixture {
  static const String validData = '''
  {
    "id": "123",
    "name": "John Doe",
    "email": "john@example.com"
  }
  ''';
}
```

**Razões:**
- Melhor performance (sem overhead de parsing)
- Type safety em tempo de compilação
- Facilidade de uso nos testes
- Evita erros de JSON inválido

## Mocks

### Estrutura e Documentação
```dart
/// Mock do [ApiService] para testes unitários.
///
/// Fornece métodos auxiliares para simular respostas da API
/// em diferentes cenários (sucesso, erro, timeout, etc).
class ApiServiceMock extends Mock implements ApiService {
  /// Configura comportamentos padrão do mock.
  ///
  /// Deve ser chamado no setUp() de cada teste para garantir
  /// estado inicial consistente.
  static void setupDefaults(ApiServiceMock mock) {
    when(() => mock.get(any())).thenAnswer(
      (_) async => ApiServiceMock.createSuccessResponse(data: {}),
    );
  }

  /// Cria uma resposta de sucesso simulada.
  ///
  /// Útil para mockar chamadas bem-sucedidas da API.
  static ApiResponse createSuccessResponse({
    required Map<String, dynamic> data,
  }) {
    return ApiResponse(
      statusCode: 200,
      data: data,
      success: true,
    );
  }

  /// Cria uma resposta de erro genérico.
  static ApiResponse createErrorResponse() {
    return ApiResponse(
      statusCode: 500,
      data: {},
      success: false,
    );
  }

  /// Cria uma resposta de timeout.
  static ApiResponse createTimeoutResponse() {
    return ApiResponse(
      statusCode: 408,
      data: {},
      success: false,
    );
  }

  /// Cria uma resposta de erro de sessão expirada.
  static ApiResponse createUserSessionErrorResponse() {
    return ApiResponse(
      statusCode: 401,
      data: {},
      success: false,
    );
  }
}
```

### Configuração de Mocks

#### setupDefaults
```dart
class ConnectivityHelperMock extends Mock implements ConnectivityHelper {
  static void setupDefaults(ConnectivityHelperMock mock) {
    // Comportamento padrão: online
    when(() => mock.isConnectionDown()).thenAnswer((_) async => false);
  }
}
```

#### registerFallbackValue
```dart
class ApiRequestFake extends Fake implements ApiRequest {}

setUpAll(() {
  registerFallbackValue(ApiRequestFake());
});
```

### Uso dos Métodos Utilitários

**IMPORTANTE:** Sempre use os métodos utilitários do mock ao invés de criar instâncias diretamente:

```dart
// ✅ Correto - Usar métodos utilitários
when(() => apiServiceMock.get(any())).thenAnswer(
  (_) async => ApiServiceMock.createSuccessResponse(
    data: UserModelFixture.validData,
  ),
);

// ❌ Evitar - Criar ApiResponse diretamente
when(() => apiServiceMock.get(any())).thenAnswer(
  (_) async => ApiResponse(
    statusCode: 200,
    data: UserModelFixture.validData,
    success: true,
  ),
);
```

**Métodos disponíveis:**
- `createSuccessResponse()` para respostas de sucesso
- `createErrorResponse()` para respostas de erro genérico
- `createTimeoutResponse()` para respostas de timeout
- `createUserSessionErrorResponse()` para respostas de sessão expirada

### Organização de Mocks

- Crie mocks específicos por classe em arquivos separados
- Implemente métodos `setupDefaults()` estáticos
- Use `registerFallbackValue()` para tipos complexos
- Configure mocks no `setUpAll()` para dados que não mudam
- Use `setUp()` para configurações que precisam ser resetadas

## Helpers de Teste

### Helpers Globais (`test/test_helpers.dart`)

Centralize funções auxiliares usadas em múltiplas features:

```dart
/// Configura mocks globais usados em múltiplos testes.
void setupGlobalMocks() {
  // Configuração global
}
```

### Helpers por Feature (`test/features/[feature]/[feature]_test_helpers.dart`)

Centralize funções auxiliares específicas de uma feature:

```dart
/// Configura mock do repository para retornar sucesso.
void mockGetAllDataSuccess(
  AffiliationRepositoryMock mock,
  Either<Failure?, List<AffiliationRequest>> result,
) {
  when(() => mock.getAllRequests()).thenAnswer((_) async => result);
}

/// Configura mock do repository para retornar erro.
void mockGetAllDataError(AffiliationRepositoryMock mock) {
  when(() => mock.getAllRequests())
      .thenAnswer((_) async => const Left(null));
}
```

**Regras:**
- Externalize mocks de repository em funções genéricas que recebem `Either` como parâmetro
- Permite reutilização em múltiplos testes de UseCases
- Crie funções auxiliares apenas quando usadas 2+ vezes
- Funções usadas uma única vez devem ser inline no teste

### IMPORTANTE: Use Helpers Existentes

**Sempre dar preferência aos helpers da pasta `/test/core/helpers`:**

```dart
// ✅ Correto - Usar helpers centrais
ApiServiceMock.setupDefaults(apiServiceMock);
ConnectivityHelperMock.setupDefaults(connectivityHelperMock);

// ❌ Evitar - Reconfigurar comportamentos já definidos
when(() => connectivityHelperMock.isConnectionDown())
    .thenAnswer((_) async => false); // setupDefaults() já faz isso
```

**Apenas use helpers específicos da feature quando a funcionalidade não existir nos helpers centrais.**

## Nomenclatura e Organização

### Títulos de Testes

```dart
// ✅ Bom - Claro, específico, descreve o comportamento
test('should return available balance when user has transactions', () {});
test('should throw FormatException when CPF has less than 11 digits', () {});

// ✅ Bom para Bloc - Descreve estados emitidos e cenário
blocTest<WithdrawBloc, WithdrawState>(
  'should emit [LoadingState, LoadedState] when loading withdraws successfully',
  // ...
);

// ❌ Evitar - Vago, não descreve o comportamento
test('test balance', () {});
test('CPF validation', () {});
blocTest<WithdrawBloc, WithdrawState>(
  'load withdraws',
  // ...
);
```

### Organização de Grupos

```dart
void main() {
  group('WithdrawDataSource', () {
    group('requestWithdraw', () {
      test('should return success when API call succeeds', () {});
      test('should return TimeoutFailure when request times out', () {});
      test('should return OfflineFailure when device is offline', () {});
    });
    
    group('Edge Cases and Error Handling', () {
      test('should handle null response gracefully', () {});
      test('should retry on network error', () {});
    });
  });
}
```

## Boas Práticas Gerais

### DOs - O Que Fazer
✅ Use padrão AAA (Arrange, Act, Assert) em todos os testes
✅ Use `blocTest` para testar Blocs
✅ Use Mocktail para mocks
✅ Use `HelpersTestUtils.testObjectEquality` para testes de igualdade
✅ Use fixtures existentes ao invés de dados inline
✅ Use métodos utilitários dos mocks para criar respostas
✅ Separe testes de comportamento e interação
✅ Use matchers específicos ao invés de `equals()`
✅ Organize testes espelhando estrutura de `/lib`
✅ Use `reset()` no `tearDown()`
✅ Configure mocks no `build:` para testes de Bloc
✅ Use `final` para states em testes (não `const`)
✅ Verifique parâmetros específicos nas chamadas de método
✅ Use `verifyNoMoreInteractions()` para garantir limpeza
✅ Teste todos os cenários de erro obrigatórios
✅ Documente fixtures e helpers complexos

### DON'Ts - O Que Evitar
❌ Não crie novos helpers quando existem helpers centrais
❌ Não use `any()` genérico para verificar parâmetros
❌ Não crie mocks desnecessários (use DataSource diretamente)
❌ Não permita fixtures com dados duplicados
❌ Não use JSON String ao invés de Map para fixtures
❌ Não configure mocks no `setUp()` para testes de Bloc
❌ Não use `reset()` no `setUp()` (use no `tearDown()`)
❌ Não crie funções auxiliares usadas apenas uma vez
❌ Não use `equals()` genérico quando há matcher específico
❌ Não modifique dados de fixtures ao refatorar testes
❌ Não documente testes auto-explicativos
❌ Não use `const` para states em testes

## Checklist de Qualidade

### Antes de Commitar
- [ ] Todos os testes passam
- [ ] Cobertos success, error, offline, timeout, session expired
- [ ] Fixtures criadas para dados repetidos
- [ ] Mocks usam métodos utilitários
- [ ] Verificações incluem `verifyNoMoreInteractions()`
- [ ] Parâmetros específicos verificados (não `any()`)
- [ ] Funções auxiliares criadas apenas quando usadas 2+ vezes
- [ ] `reset()` está no `tearDown()`, não no `setUp()`
- [ ] Matchers específicos usados ao invés de `equals()`
- [ ] Testes de Bloc usam `blocTest` com `verify:`
- [ ] Titles descritivos em inglês americano
- [ ] Grupos organizados por funcionalidade
- [ ] Sem dados duplicados em fixtures

### Code Review
- [ ] Estrutura de testes espelha estrutura de `/lib`
- [ ] Fixtures bem documentadas
- [ ] Mocks têm `setupDefaults()`
- [ ] Helpers existentes são reutilizados
- [ ] Testes de equality usam `HelpersTestUtils.testObjectEquality`
- [ ] Testes de Bloc verificam estado final no `verify:`
- [ ] Sem configurações redundantes de mocks
- [ ] DataSource usado diretamente em testes de UseCase

## Referências

### Documentação Oficial
- [Effective Dart: Testing](https://dart.dev/guides/testing)
- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Bloc Testing Documentation](https://bloclibrary.dev/#/testing)
- [Mocktail Package](https://pub.dev/packages/mocktail)

### Padrões do Projeto
- Sempre consulte `@/test/core/helpers` para helpers existentes
- Siga exemplos em `@/test/features/affiliation` para estrutura de Bloc
- Use `@helpers_test_utils.dart` para utilitários de teste
- Consulte arquivos `*_fixture.dart` existentes para padrões
