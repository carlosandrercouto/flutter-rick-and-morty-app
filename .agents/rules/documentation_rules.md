---
description: Padrões e regras para documentação do código, Doc Comments e TODOs
---
# Regras de Documentação de Código

## Princípios Gerais de Documentação

### Idioma e Convenções
- **Utiliza Português do Brasil para documentação e inglês para nome de classes, variáveis, funções, métodos, etc.**
- **Documente em Português do Brasil as lógicas complexas e decisões de código não óbvias.**
- **Siga a documentação oficial do Flutter, Bloc e Firebase para melhores práticas.**
- **Referência: [Effective Dart: Documentation](https://dart.dev/effective-dart/documentation)**

### Princípios do Effective Dart
- **✅ DO format comments like sentences** - Comece com letra maiúscula e termine com ponto final.
- **✅ DO use /// doc comments** - Use `///` para documentar membros e tipos (nunca `/** */`).
- **✅ DO start with a single-sentence summary** - Primeira frase deve ser um sumário completo.
- **✅ DO separate the first sentence into its own paragraph** - Deixe uma linha em branco após o sumário.
- **✅ PREFER brevity** - Seja breve mas completo.
- **✅ PREFER writing doc comments for public APIs** - Priorize documentação de APIs públicas.
- **❌ DON'T use block comments for documentation** - Evite `/* */` para documentação.

## Hierarquia de Documentação

### Prioridades
1. **APIs Públicas (Obrigatório)** - Toda classe, método, propriedade pública deve ter documentação.
2. **APIs de Biblioteca (Recomendado)** - Considere documentar no nível da biblioteca.
3. **APIs Internas (Opcional)** - Documente quando a lógica não for óbvia.
4. **Código Privado (Conforme necessário)** - Apenas para lógicas complexas.

### Quando Documentar
- **✅ Sempre documente:**
  - Classes, enums, extensions, mixins públicos
  - Métodos e funções públicas
  - Propriedades e getters/setters públicos
  - Constantes e enums values
  - Type aliases e callbacks
  - Parâmetros complexos ou não óbvios

- **✅ Considere documentar:**
  - Bibliotecas (library-level doc comment)
  - APIs privadas com lógica complexa
  - Workarounds e decisões de arquitetura

- **❌ Evite documentar:**
  - Código auto-explicativo
  - Overrides simples sem lógica adicional
  - Getters/setters triviais

## Doc Comments (///)

### Estrutura Básica
```dart
/// [SUMÁRIO EM UMA FRASE - PRIMEIRA LINHA]
///
/// [Descrição detalhada em parágrafos subsequentes, se necessário.
/// Use uma linha em branco para separar parágrafos.]
///
/// [Informações sobre parâmetros, retorno, exceções em prosa.]
///
/// [Exemplos de uso, se relevante.]
```

### Regras de Formatação
- **Use frases completas** - Comece com maiúscula e termine com ponto final.
- **Primeira linha = sumário completo** - Deve fazer sentido isoladamente.
- **Separe o sumário** - Deixe uma linha em branco após a primeira frase.
- **Use parágrafos** - Separe blocos de informação com linha em branco.
- **80 caracteres por linha** - Mantenha linhas de comentário em até 80 chars.

### Verbos e Estrutura de Frases

#### Funções/Métodos - Use Verbos na Terceira Pessoa
```dart
/// Calcula o saldo disponível para saque do usuário.
///
/// Considera o saldo atual, transações pendentes e limites da conta.
/// Retorna um [Either] com [Failure] em caso de erro ou [double] com o saldo.
Future<Either<Failure?, double>> calculateAvailableBalance() async {
  // implementação
}

/// Valida se o CPF fornecido é válido.
///
/// Retorna `true` se o CPF passar na validação de dígitos verificadores.
bool validateCpf(String cpf) {
  // implementação
}
```

#### Variáveis/Propriedades - Use Frases Nominais
```dart
/// O saldo atual da carteira do produtor.
///
/// Este valor é atualizado em tempo real quando novas transações ocorrem.
final double walletBalance;

/// A lista de produtos afiliados do usuário.
///
/// Contém apenas produtos com status ativo ou pendente.
final List<Product> affiliateProducts;
```

#### Booleanos - Use "Whether" + Substantivo/Gerúndio
```dart
/// Whether o usuário está autenticado no sistema.
final bool isAuthenticated;

/// Whether a conexão com a internet está disponível.
final bool isOnline;

/// Whether o saque está sendo processado.
final bool isProcessingWithdraw;
```

### Classes e Types

#### Classes - Use Frases Nominais
```dart
/// Um datasource para gerenciar operações de saque.
///
/// Esta classe é responsável por fazer chamadas à API de saques,
/// tratar erros e converter respostas em models.
///
/// Exemplo de uso:
/// ```dart
/// final datasource = WithdrawDataSource(
///   apiService: apiService,
///   firebaseCrashlytics: crashlytics,
/// );
/// final result = await datasource.requestWithdraw(amount: 1000.0);
/// ```
class WithdrawDataSource implements WithdrawRepository {
  // implementação
}
```

#### Enums - Descreva o Propósito
```dart
/// Status possíveis de uma solicitação de afiliação.
///
/// Representa o ciclo de vida de uma solicitação desde a criação
/// até sua aprovação ou recusa.
enum AffiliationStatus {
  /// Solicitação aguardando análise do produtor.
  pending,
  
  /// Solicitação aprovada pelo produtor.
  approved,
  
  /// Solicitação recusada pelo produtor.
  refused,
  
  /// Solicitação cancelada pelo afiliado.
  cancelled,
}
```

## Comentários de Supressão (ignore)

### Ignore File
```dart
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: avoid_print

/// Classe de exemplo...
class Example {
  // implementação
}
```

### Ignore Line
```dart
// ignore: avoid_print
print('Debug: valor = $value');

// ignore: unused_element
void _debugHelper() {
  // helper temporário para debug
}
```

## Referências e Links

### Usar Colchetes para Identificadores
```dart
/// Carrega os dados do [User] a partir do [userId] fornecido.
///
/// Retorna um [Either] contendo [UserSessionFailure] se a sessão expirou,
/// [OfflineFailure] se não há conexão, ou os dados do [User] em caso de sucesso.
///
/// Veja também:
/// * [SessionHelper] para gerenciar sessões de usuário
/// * [ConnectivityHelper] para verificar conectividade
Future<Either<Failure?, User>> loadUserData(String userId) async {
  // implementação
}
```

### Links para Documentação Externa
```dart
/// Implementa autenticação biométrica seguindo as guidelines do Flutter.
///
/// Baseado em: https://pub.dev/packages/local_auth
///
/// Veja também:
/// * https://developer.android.com/training/sign-in/biometric-auth
/// * https://developer.apple.com/documentation/localauthentication
class BiometricHelper {
  // implementação
}
```

## Comentários Inline (//)

### Quando Usar
```dart
/// Calcula o saldo total da carteira do usuário.
Future<double> calculateWalletBalance() async {
  // Busca transações dos últimos 30 dias para otimizar performance
  final transactions = await _getRecentTransactions(days: 30);
  
  // Aplica regra de negócio: comissões são creditadas após 7 dias
  final availableBalance = transactions
      .where((t) => t.createdAt.isBefore(DateTime.now().subtract(Duration(days: 7))))
      .fold(0.0, (sum, t) => sum + t.amount);
  
  return availableBalance;
}
```

### Explicações de Lógica Complexa
```dart
/// Valida e normaliza o CPF fornecido.
String normalizeCpf(String cpf) {
  // Remove caracteres não numéricos (pontos, hífens, espaços)
  final digitsOnly = cpf.replaceAll(RegExp(r'\D'), '');
  
  // CPF deve ter exatamente 11 dígitos após normalização
  if (digitsOnly.length != 11) {
    throw FormatException('CPF inválido: deve conter 11 dígitos');
  }
  
  return digitsOnly;
}
```

### Workarounds e TODOs

#### Formato de TODOs (Flutter Style)
```dart
// TODO(username): Descrição da tarefa a ser feita
// TODO(username): Migrar para nova API v2, https://github.com/org/repo/issues/123

/// Busca produtos usando a API v1.
///
/// Método legado mantido para compatibilidade.
@Deprecated('Use fetchProductsV2() instead')
Future<List<Product>> fetchProducts() async {
  // TODO(joao): Remover após migração completa para v2 - Sprint 45
  return _apiV1.getProducts();
}
```

#### FIXME e Hacks Temporários
```dart
/// Calcula juros compostos sobre o valor.
double calculateInterest(double principal, double rate) {
  // FIXME: Cálculo incorreto para valores acima de R$ 10.000
  // Issue: https://github.com/carlosandrercouto/app/issues/456
  // Workaround temporário até correção da fórmula
  if (principal > 10000) {
    return principal * rate * 0.95; // Aplicando fator de correção
  }
  
  return principal * rate;
}
```

## Documentação de Testes

**Para regras completas sobre testes unitários, consulte:**
**`.cursor/rules/cursorrules-unit-tests.mdc`**

Este arquivo dedicado contém:
- Estrutura e organização de testes (UseCase, Bloc, Models, Entities)
- Padrões para Fixtures, Mocks e Helpers
- Nomenclatura e boas práticas
- Checklist de qualidade
- Exemplos detalhados para cada tipo de teste

### Princípios Básicos para Documentação em Testes
- **Use doc comments (///) para fixtures e test helpers**
- **Títulos de testes em inglês americano, simples e diretos**
- **Documente apenas testes complexos ou não óbvios**
- **Evite documentar testes auto-explicativos**

## Documentação de Código de Produção (Clean Architecture)

### DataSources (Camada de Data)

#### Estrutura Completa
```dart
/// Um datasource para gerenciar operações de saque via API.
///
/// Esta classe é responsável por:
/// * Fazer chamadas à API de saques
/// * Converter respostas JSON em [WithdrawModel]
/// * Tratar erros e registrá-los no Firebase Crashlytics
/// * Mapear erros de API para [Failure] objects
///
/// Implementa [WithdrawRepository] seguindo Clean Architecture.
class WithdrawDataSource implements WithdrawRepository {
  /// Cria uma instância do [WithdrawDataSource].
  ///
  /// [apiService] é usado para fazer requisições HTTP.
  /// [firebaseCrashlytics] é usado para logging de erros.
  WithdrawDataSource({
    required this.apiService,
    required this.firebaseCrashlytics,
  });

  final ApiService apiService;
  final FirebaseCrashlytics firebaseCrashlytics;

  @override
  Future<Either<Failure?, WithdrawEntity>> requestWithdraw({
    required double amount,
  }) async {
    try {
      // Validação prévia do valor mínimo
      if (amount < 50.0) {
        return const Left(InvalidAmountFailure());
      }

      final response = await apiService.post(
        endpoint: '/withdraw/request',
        body: {'amount': amount},
      );

      if (response.success) {
        final model = WithdrawModel.fromApi(map: response.data);
        return Right(model);
      }

      return const Left(null);
    } on TimeoutException {
      return const Left(TimeoutFailure());
    } catch (error, stackTrace) {
      // Registra erro no Crashlytics para análise
      await firebaseCrashlytics.recordError(
        error,
        stackTrace,
        reason: 'Erro ao solicitar saque de R\$ $amount',
      );
      
      log('Erro ao solicitar saque: $error', name: 'WithdrawDataSource');
      return const Left(null);
    }
  }
}
```

#### Logs e Debug
```dart
/// Busca o histórico de saques do usuário.
Future<Either<Failure?, List<WithdrawEntity>>> getWithdrawHistory() async {
  try {
    // Log de debug para rastreamento em desenvolvimento
    log('Buscando histórico de saques', name: 'WithdrawDataSource');
    
    final response = await apiService.get(endpoint: '/withdraw/history');
    
    if (response.success) {
      final withdraws = (response.data['withdraws'] as List)
          .map((json) => WithdrawModel.fromApi(map: json))
          .toList();
      
      log('Histórico carregado: ${withdraws.length} saques', name: 'WithdrawDataSource');
      return Right(withdraws);
    }
    
    return const Left(null);
  } catch (error, stackTrace) {
    await firebaseCrashlytics.recordError(
      error,
      stackTrace,
      reason: 'Falha ao buscar histórico de saques',
    );
    
    return const Left(null);
  }
}
```

### Repositories (Camada de Domain)

```dart
/// Interface para operações de saque.
///
/// Define os métodos disponíveis para gerenciar saques,
/// sem expor detalhes de implementação.
///
/// Implementado por [WithdrawDataSource] na camada de data.
abstract class WithdrawRepository {
  /// Solicita um novo saque.
  ///
  /// Retorna [Right] com [WithdrawEntity] em caso de sucesso,
  /// ou [Left] com [Failure] em caso de erro.
  ///
  /// Possíveis falhas:
  /// * [InvalidAmountFailure] - Valor abaixo do mínimo permitido
  /// * [TimeoutFailure] - Timeout na requisição
  /// * [OfflineFailure] - Sem conexão com internet
  /// * `null` - Erro genérico
  Future<Either<Failure?, WithdrawEntity>> requestWithdraw({
    required double amount,
  });

  /// Busca o histórico de saques do usuário.
  ///
  /// Retorna lista vazia se não houver saques registrados.
  Future<Either<Failure?, List<WithdrawEntity>>> getWithdrawHistory();
}
```

### UseCases (Camada de Domain)

```dart
/// Caso de uso para solicitar um novo saque.
///
/// Encapsula a lógica de negócio para validar e processar
/// solicitações de saque, incluindo verificações de saldo
/// e limites diários.
///
/// Exemplo de uso:
/// ```dart
/// final useCase = RequestWithdrawUseCase(repository: repository);
/// final result = await useCase(amount: 1000.0);
/// 
/// result.fold(
///   (failure) => print('Erro: $failure'),
///   (withdraw) => print('Saque solicitado: ${withdraw.id}'),
/// );
/// ```
class RequestWithdrawUseCase {
  /// Cria uma instância do [RequestWithdrawUseCase].
  RequestWithdrawUseCase({required this.repository});

  final WithdrawRepository repository;

  /// Executa o caso de uso.
  ///
  /// Valida o [amount] e delega a solicitação para o [repository].
  ///
  /// Regras de negócio aplicadas:
  /// * Valor mínimo: R$ 50,00
  /// * Valor máximo: R$ 50.000,00
  /// * Limite diário: 3 saques
  Future<Either<Failure?, WithdrawEntity>> call({
    required double amount,
  }) async {
    // Valida valor máximo (regra de negócio)
    if (amount > 50000.0) {
      return const Left(MaxAmountExceededFailure());
    }

    return repository.requestWithdraw(amount: amount);
  }
}
```

### Entities (Camada de Domain)

```dart
/// Representa um saque no domínio da aplicação.
///
/// Esta entidade encapsula os dados essenciais de um saque,
/// independente da fonte de dados (API, banco local, etc).
///
/// Invariantes:
/// * [amount] deve ser sempre positivo
/// * [id] é único e imutável
/// * [status] define o ciclo de vida do saque
class WithdrawEntity extends Equatable {
  /// Cria uma instância de [WithdrawEntity].
  ///
  /// Lança [AssertionError] se [amount] for negativo ou zero.
  const WithdrawEntity({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.processedAt,
  }) : assert(amount > 0, 'Amount must be positive');

  /// Identificador único do saque.
  final String id;

  /// Valor solicitado em reais.
  ///
  /// Sempre positivo, validado no construtor.
  final double amount;

  /// Status atual do saque.
  ///
  /// Veja [WithdrawStatus] para possíveis valores.
  final WithdrawStatus status;

  /// Data e hora de criação da solicitação.
  final DateTime createdAt;

  /// Data e hora de processamento.
  ///
  /// Null se o saque ainda está pendente.
  final DateTime? processedAt;

  /// Whether o saque foi processado.
  ///
  /// Retorna `true` se [processedAt] não é null.
  bool get isProcessed => processedAt != null;

  @override
  List<Object?> get props => [id, amount, status, createdAt, processedAt];
}
```

### Models (Camada de Data)

```dart
/// Model para conversão de dados de saque da API.
///
/// Estende [WithdrawEntity] e adiciona lógica de serialização/deserialização.
///
/// A API retorna valores monetários como strings formatadas (ex: "R$ 1.000,00"),
/// este model converte para [double] removendo formatação.
class WithdrawModel extends WithdrawEntity {
  /// Cria uma instância de [WithdrawModel].
  const WithdrawModel({
    required super.id,
    required super.amount,
    required super.status,
    required super.createdAt,
    super.processedAt,
  });

  /// Cria um [WithdrawModel] a partir de um Map da API.
  ///
  /// Converte strings formatadas da API para tipos apropriados:
  /// * 'amount': String ("R$ 1.000,00") → double (1000.00)
  /// * 'status': String → [WithdrawStatus] enum
  /// * 'created_at': String (ISO 8601) → [DateTime]
  ///
  /// Exemplo de [map] esperado:
  /// ```json
  /// {
  ///   "id": "123",
  ///   "amount": "R$ 1.000,00",
  ///   "status": "pending",
  ///   "created_at": "2024-01-15T10:30:00Z"
  /// }
  /// ```
  factory WithdrawModel.fromApi({required Map<String, dynamic> map}) {
    return WithdrawModel(
      id: map['id'] as String,
      amount: _parseAmount(map['amount'] as String),
      status: WithdrawStatus.fromString(map['status'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      processedAt: map['processed_at'] != null
          ? DateTime.parse(map['processed_at'] as String)
          : null,
    );
  }

  /// Converte string formatada "R$ 1.000,00" para double 1000.00.
  ///
  /// Remove símbolos de moeda, pontos de milhar e converte vírgula para ponto.
  static double _parseAmount(String formattedAmount) {
    return double.parse(
      formattedAmount
          .replaceAll('R\$', '')
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .trim(),
    );
  }
}
```

### Blocs/States (Camada de Presentation)

#### Bloc
```dart
/// Gerencia o estado da funcionalidade de saques.
///
/// Coordena solicitações de saque, carregamento de histórico
/// e tratamento de erros através de eventos e estados.
///
/// Eventos suportados:
/// * [RequestWithdrawEvent] - Solicita novo saque
/// * [LoadWithdrawHistoryEvent] - Carrega histórico
/// * [CancelWithdrawEvent] - Cancela saque pendente
///
/// Veja [WithdrawState] para possíveis estados.
class WithdrawBloc extends Bloc<WithdrawEvent, WithdrawState> {
  /// Cria uma instância de [WithdrawBloc].
  WithdrawBloc({
    required this.requestWithdrawUseCase,
    required this.getHistoryUseCase,
    required this.connectivityHelper,
  }) : super(WithdrawInitialState()) {
    on<RequestWithdrawEvent>(_onRequestWithdraw);
    on<LoadWithdrawHistoryEvent>(_onLoadHistory);
  }

  final RequestWithdrawUseCase requestWithdrawUseCase;
  final GetWithdrawHistoryUseCase getHistoryUseCase;
  final ConnectivityHelper connectivityHelper;

  /// Processa evento de solicitação de saque.
  ///
  /// Verifica conectividade antes de fazer a requisição.
  /// Emite estados apropriados baseado no resultado.
  Future<void> _onRequestWithdraw(
    RequestWithdrawEvent event,
    Emitter<WithdrawState> emit,
  ) async {
    emit(WithdrawLoadingState());

    // Verifica conectividade antes de prosseguir
    if (await connectivityHelper.isConnectionDown()) {
      emit(WithdrawErrorOfflineState());
      return;
    }

    final result = await requestWithdrawUseCase(amount: event.amount);

    result.fold(
      (failure) => _handleFailure(failure, emit),
      (withdraw) => emit(WithdrawSuccessState(withdraw: withdraw)),
    );
  }

  /// Mapeia [Failure] para estados de erro apropriados.
  void _handleFailure(Failure? failure, Emitter<WithdrawState> emit) {
    if (failure is TimeoutFailure) {
      emit(WithdrawErrorTimeoutState());
    } else if (failure is UserSessionFailure) {
      emit(WithdrawErrorUserSessionState());
    } else {
      emit(WithdrawErrorState());
    }
  }
}
```

#### States
```dart
/// Estado base para a funcionalidade de saques.
///
/// Todos os estados específicos devem estender esta classe.
///
/// Usa [identityHashCode] para garantir que cada instância seja única,
/// permitindo que states sem propriedades sejam emitidos múltiplas vezes.
abstract class WithdrawState extends Equatable {
  @override
  List<Object> get props => [identityHashCode(this)];
}

/// Estado inicial do bloc.
///
/// Emitido quando o bloc é criado e nenhuma ação foi executada ainda.
class WithdrawInitialState extends WithdrawState {}

/// Estado de carregamento.
///
/// Emitido quando uma operação assíncrona está em andamento.
class WithdrawLoadingState extends WithdrawState {}

/// Estado de sucesso após solicitar um saque.
///
/// Contém os dados do saque criado.
class WithdrawSuccessState extends WithdrawState {
  /// Cria uma instância de [WithdrawSuccessState].
  WithdrawSuccessState({required this.withdraw});

  /// O saque que foi criado com sucesso.
  final WithdrawEntity withdraw;

  @override
  List<Object> get props => [withdraw];
}
```

## Logs e Debugging

### Princípios de Logging
- **Nunca use `print()` em produção** - Use `log()` da biblioteca `dart:developer`
- **Sempre nomeie seus logs** - Use o parâmetro `name` para identificar a origem
- **Inclua contexto relevante** - Adicione variáveis importantes na mensagem
- **Use níveis apropriados** - Debug, Info, Warning, Error

### Logs de Desenvolvimento (dart:developer)

```dart
import 'dart:developer' as developer;

/// Carrega dados do usuário.
Future<User> loadUser(String userId) async {
  // Log de entrada com contexto
  developer.log(
    'Carregando dados do usuário: $userId',
    name: 'UserDataSource',
  );

  final user = await _fetchUser(userId);

  // Log de sucesso com resultado
  developer.log(
    'Usuário carregado: ${user.name} (${user.email})',
    name: 'UserDataSource',
    level: 800, // Level.INFO
  );

  return user;
}

/// Processa pagamento com logging detalhado.
Future<void> processPayment(Payment payment) async {
  developer.log(
    'Iniciando processamento de pagamento',
    name: 'PaymentService',
    error: null,
    stackTrace: null,
  );

  try {
    await _process(payment);
    
    developer.log(
      'Pagamento processado com sucesso: ${payment.id}',
      name: 'PaymentService',
      level: 800,
    );
  } catch (error, stackTrace) {
    developer.log(
      'Erro ao processar pagamento: ${payment.id}',
      name: 'PaymentService',
      level: 1000, // Level.SEVERE
      error: error,
      stackTrace: stackTrace,
    );
    rethrow;
  }
}
```

### Logs de Erro (Firebase Crashlytics)

#### Logging Básico
```dart
/// Solicita saque tratando erros com Crashlytics.
Future<Either<Failure?, Withdraw>> requestWithdraw(double amount) async {
  try {
    final result = await _apiService.post('/withdraw', {'amount': amount});
    return Right(result);
  } catch (error, stackTrace) {
    // Registra erro no Crashlytics com contexto
    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: 'Falha ao solicitar saque de R\$ ${amount.toStringAsFixed(2)}',
    );

    // Também loga localmente para debug
    developer.log(
      'Erro ao solicitar saque',
      name: 'WithdrawDataSource',
      error: error,
      stackTrace: stackTrace,
    );

    return const Left(null);
  }
}
```

#### Com Informações Customizadas
```dart
/// Processa upload de imagem com logging detalhado.
Future<String> uploadImage(File image) async {
  try {
    // Adiciona informações customizadas antes do erro
    await FirebaseCrashlytics.instance.setCustomKey('image_size', image.lengthSync());
    await FirebaseCrashlytics.instance.setCustomKey('image_path', image.path);

    final url = await _uploadToServer(image);
    return url;
  } catch (error, stackTrace) {
    // Erro será registrado com as informações customizadas
    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: 'Falha ao fazer upload de imagem (${image.lengthSync()} bytes)',
      information: ['Tentativa de upload', 'User ID: ${_currentUserId}'],
      fatal: false, // Não é um erro fatal
    );

    rethrow;
  }
}
```

### Analytics (Firebase Analytics)

#### Eventos Básicos
```dart
/// Registra evento de login bem-sucedido.
Future<void> onLoginSuccess(String userId) async {
  await AnalyticsHelper.instance.sendAnalyticsEvent(
    eventName: AnalyticsEvents.userLoginSuccess,
    parameters: {
      'user_id': userId,
      'login_method': 'email',
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}

/// Registra evento de visualização de produto.
Future<void> onProductViewed(Product product) async {
  await AnalyticsHelper.instance.sendAnalyticsEvent(
    eventName: AnalyticsEvents.productViewed,
    parameters: {
      'product_id': product.id,
      'product_name': product.name,
      'category': product.category,
      'price': product.price,
    },
  );
}
```

#### Eventos de Conversão
```dart
/// Registra conclusão de compra.
Future<void> onPurchaseCompleted(Purchase purchase) async {
  await AnalyticsHelper.instance.sendAnalyticsEvent(
    eventName: AnalyticsEvents.purchaseCompleted,
    parameters: {
      'transaction_id': purchase.id,
      'value': purchase.totalAmount,
      'currency': 'BRL',
      'items': purchase.items.length,
      'payment_method': purchase.paymentMethod,
    },
  );
}
```

## Documentação de Widgets (UI)

### Widgets Customizados

```dart
/// Um botão customizado seguindo o design system do app.
///
/// Este widget encapsula o estilo padrão de botões, incluindo
/// cores, espaçamento, estados de loading e disabled.
///
/// Exemplo de uso:
/// ```dart
/// CustomButton(
///   text: 'Solicitar Saque',
///   onPressed: () => _requestWithdraw(),
///   isLoading: state is LoadingState,
/// )
/// ```
///
/// Veja também:
/// * [CustomOutlinedButton] para botões com borda
/// * [CustomTextButton] para botões de texto
class CustomButton extends StatelessWidget {
  /// Cria um [CustomButton].
  ///
  /// [text] é obrigatório e não pode estar vazio.
  /// [onPressed] pode ser null para botões desabilitados.
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
  }) : assert(text != '', 'Text cannot be empty');

  /// O texto exibido no botão.
  final String text;

  /// Callback executado quando o botão é pressionado.
  ///
  /// Se null, o botão ficará desabilitado.
  final VoidCallback? onPressed;

  /// Whether o botão está em estado de loading.
  ///
  /// Quando true, exibe um [CircularProgressIndicator] e desabilita o botão.
  final bool isLoading;

  /// Cor de fundo customizada do botão.
  ///
  /// Se null, usa a cor primária do tema.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        minimumSize: const Size(double.infinity, 48),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Text(text),
    );
  }
}
```

### Telas/Screens

```dart
/// Tela de solicitação de saque.
///
/// Permite o usuário informar o valor desejado e solicitar um saque.
/// Valida o valor mínimo, exibe o saldo disponível e histórico de saques.
///
/// Requer que o usuário esteja autenticado e tenha saldo disponível.
class WithdrawScreen extends StatelessWidget {
  /// Rota desta tela.
  static const routeName = '/withdraw';

  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WithdrawBloc(
        requestWithdrawUseCase: context.read(),
        getHistoryUseCase: context.read(),
        connectivityHelper: context.read(),
      )..add(LoadWithdrawHistoryEvent()),
      child: const _WithdrawScreenContent(),
    );
  }
}
```

## Annotations e Metadados

### @deprecated
```dart
/// Busca produtos usando a API v1.
///
/// Este método está obsoleto e será removido na versão 3.0.
/// Use [fetchProductsV2] para a nova implementação.
@Deprecated('Use fetchProductsV2() instead. Will be removed in v3.0')
Future<List<Product>> fetchProducts() async {
  return _apiV1.getProducts();
}
```

### @visibleForTesting
```dart
/// Helper interno para parsing de valores monetários.
///
/// Visível apenas para testes. Não deve ser usado fora da classe.
@visibleForTesting
static double parseMoneyString(String value) {
  return double.parse(
    value.replaceAll('R\$', '').replaceAll('.', '').replaceAll(',', '.').trim(),
  );
}
```

### @protected
```dart
abstract class BaseRepository {
  /// Converte [Failure] para mensagem amigável ao usuário.
  ///
  /// Método protegido disponível para subclasses.
  @protected
  String getErrorMessage(Failure failure) {
    if (failure is TimeoutFailure) {
      return 'Tempo esgotado. Tente novamente.';
    }
    return 'Erro inesperado. Tente novamente.';
  }
}
```

## Markdown em Doc Comments

### Listas
```dart
/// Gerencia operações de autenticação do usuário.
///
/// Funcionalidades suportadas:
/// * Login com email/senha
/// * Login com biometria
/// * Login social (Google, Facebook, Apple)
/// * Recuperação de senha
/// * Logout
///
/// Todos os métodos retornam [Either<Failure, User>].
class AuthService {
  // implementação
}
```

### Code Blocks
```dart
/// Valida um CPF brasileiro.
///
/// Exemplo:
/// ```dart
/// final isValid = CpfValidator.validate('123.456.789-00');
/// if (isValid) {
///   print('CPF válido');
/// }
/// ```
///
/// Formato aceito:
/// ```
/// 123.456.789-00  // Com formatação
/// 12345678900     // Sem formatação
/// ```
class CpfValidator {
  // implementação
}
```

### Links
```dart
/// Implementa autenticação via Firebase Auth.
///
/// Documentação oficial:
/// https://firebase.google.com/docs/auth
///
/// Veja também:
/// * [BiometricHelper] para autenticação biométrica
/// * [SessionHelper] para gerenciar sessões
class FirebaseAuthService {
  // implementação
}
```

## Boas Práticas Gerais

### DO: Formatação e Clareza
✅ **Comece com letra maiúscula e termine com ponto final**
✅ **Primeira frase = sumário completo que faz sentido sozinho**
✅ **Use parágrafos separados por linha em branco**
✅ **Mantenha linhas em até 80 caracteres**
✅ **Use verbos na terceira pessoa para métodos**
✅ **Use frases nominais para propriedades**
✅ **Use "Whether" para propriedades booleanas**

### DO: Conteúdo Útil
✅ **Documente o "porquê", não o "o quê"**
✅ **Explique decisões não óbvias**
✅ **Inclua exemplos de uso para APIs complexas**
✅ **Liste possíveis exceções/falhas**
✅ **Documente comportamentos edge cases**
✅ **Use colchetes [] para referenciar identificadores**

### DON'T: O Que Evitar
❌ **Não use block comments (/* */) para documentação**
❌ **Não repita o que o código já diz**
❌ **Não documente o óbvio**
❌ **Não deixe documentação desatualizada**
❌ **Não use linguagem informal ou gírias**
❌ **Não documente getters/setters triviais**

## Checklist de Qualidade

### Antes de Commitar
- [ ] Toda classe pública tem doc comment com sumário
- [ ] Métodos públicos têm doc comments explicando propósito
- [ ] Parâmetros não óbvios estão documentados
- [ ] Possíveis exceções/failures estão listadas
- [ ] Exemplos de uso incluídos quando apropriado
- [ ] Links para documentação externa quando relevante
- [ ] Primeira frase faz sentido isoladamente
- [ ] Identificadores referenciados com colchetes []
- [ ] Sem erros de português ou gramática
- [ ] Comentários inline explicam lógicas complexas
- [ ] TODOs seguem formato: `// TODO(username): descrição`
- [ ] Logs usam `log()` ao invés de `print()`
- [ ] Erros críticos registrados no Crashlytics

### Revisão de Código
- [ ] Documentação está atualizada com mudanças
- [ ] Novos métodos públicos têm documentação
- [ ] Exemplos de código funcionam corretamente
- [ ] Documentação segue estilo do projeto
- [ ] Não há comentários redundantes
- [ ] Links externos estão funcionando

## Ferramentas e Geração de Documentação

### Gerar Documentação com dartdoc
```bash
# Gerar documentação completa
dart doc .

# Gerar e abrir no navegador
dart doc . && open doc/api/index.html
```

### Visualizar Documentação no IDE
- **VS Code**: Hover sobre símbolo
- **Android Studio/IntelliJ**: Ctrl+Q (Windows/Linux) ou Cmd+J (Mac)
- **Quick documentation popup** mostra os doc comments formatados

## Referências Oficiais

- [Effective Dart: Documentation](https://dart.dev/effective-dart/documentation)
- [Dart API Documentation Guidelines](https://dart.dev/tools/dart-doc)
- [Flutter Documentation Best Practices](https://flutter.dev/docs/development/packages-and-plugins/documentation)
- [Firebase Crashlytics Documentation](https://firebase.google.com/docs/crashlytics)
- [Firebase Analytics Documentation](https://firebase.google.com/docs/analytics)

## Arquivo de Testes Unitários

**Para regras completas sobre testes unitários, consulte:**
**`.cursor/rules/cursorrules-unit-tests.mdc`**
# Regras de Documentação de Código

## Princípios Gerais de Documentação

### Idioma e Convenções
- **Utiliza Português do Brasil para documentação e inglês para nome de classes, variáveis, funções, métodos, etc.**
- **Documente em Português do Brasil as lógicas complexas e decisões de código não óbvias.**
- **Siga a documentação oficial do Flutter, Bloc e Firebase para melhores práticas.**
- **Referência: [Effective Dart: Documentation](https://dart.dev/effective-dart/documentation)**

### Princípios do Effective Dart
- **✅ DO format comments like sentences** - Comece com letra maiúscula e termine com ponto final.
- **✅ DO use /// doc comments** - Use `///` para documentar membros e tipos (nunca `/** */`).
- **✅ DO start with a single-sentence summary** - Primeira frase deve ser um sumário completo.
- **✅ DO separate the first sentence into its own paragraph** - Deixe uma linha em branco após o sumário.
- **✅ PREFER brevity** - Seja breve mas completo.
- **✅ PREFER writing doc comments for public APIs** - Priorize documentação de APIs públicas.
- **❌ DON'T use block comments for documentation** - Evite `/* */` para documentação.

## Hierarquia de Documentação

### Prioridades
1. **APIs Públicas (Obrigatório)** - Toda classe, método, propriedade pública deve ter documentação.
2. **APIs de Biblioteca (Recomendado)** - Considere documentar no nível da biblioteca.
3. **APIs Internas (Opcional)** - Documente quando a lógica não for óbvia.
4. **Código Privado (Conforme necessário)** - Apenas para lógicas complexas.

### Quando Documentar
- **✅ Sempre documente:**
  - Classes, enums, extensions, mixins públicos
  - Métodos e funções públicas
  - Propriedades e getters/setters públicos
  - Constantes e enums values
  - Type aliases e callbacks
  - Parâmetros complexos ou não óbvios

- **✅ Considere documentar:**
  - Bibliotecas (library-level doc comment)
  - APIs privadas com lógica complexa
  - Workarounds e decisões de arquitetura

- **❌ Evite documentar:**
  - Código auto-explicativo
  - Overrides simples sem lógica adicional
  - Getters/setters triviais

## Doc Comments (///)

### Estrutura Básica
```dart
/// [SUMÁRIO EM UMA FRASE - PRIMEIRA LINHA]
///
/// [Descrição detalhada em parágrafos subsequentes, se necessário.
/// Use uma linha em branco para separar parágrafos.]
///
/// [Informações sobre parâmetros, retorno, exceções em prosa.]
///
/// [Exemplos de uso, se relevante.]
```

### Regras de Formatação
- **Use frases completas** - Comece com maiúscula e termine com ponto final.
- **Primeira linha = sumário completo** - Deve fazer sentido isoladamente.
- **Separe o sumário** - Deixe uma linha em branco após a primeira frase.
- **Use parágrafos** - Separe blocos de informação com linha em branco.
- **80 caracteres por linha** - Mantenha linhas de comentário em até 80 chars.

### Verbos e Estrutura de Frases

#### Funções/Métodos - Use Verbos na Terceira Pessoa
```dart
/// Calcula o saldo disponível para saque do usuário.
///
/// Considera o saldo atual, transações pendentes e limites da conta.
/// Retorna um [Either] com [Failure] em caso de erro ou [double] com o saldo.
Future<Either<Failure?, double>> calculateAvailableBalance() async {
  // implementação
}

/// Valida se o CPF fornecido é válido.
///
/// Retorna `true` se o CPF passar na validação de dígitos verificadores.
bool validateCpf(String cpf) {
  // implementação
}
```

#### Variáveis/Propriedades - Use Frases Nominais
```dart
/// O saldo atual da carteira do produtor.
///
/// Este valor é atualizado em tempo real quando novas transações ocorrem.
final double walletBalance;

/// A lista de produtos afiliados do usuário.
///
/// Contém apenas produtos com status ativo ou pendente.
final List<Product> affiliateProducts;
```

#### Booleanos - Use "Whether" + Substantivo/Gerúndio
```dart
/// Whether o usuário está autenticado no sistema.
final bool isAuthenticated;

/// Whether a conexão com a internet está disponível.
final bool isOnline;

/// Whether o saque está sendo processado.
final bool isProcessingWithdraw;
```

### Classes e Types

#### Classes - Use Frases Nominais
```dart
/// Um datasource para gerenciar operações de saque.
///
/// Esta classe é responsável por fazer chamadas à API de saques,
/// tratar erros e converter respostas em models.
///
/// Exemplo de uso:
/// ```dart
/// final datasource = WithdrawDataSource(
///   apiService: apiService,
///   firebaseCrashlytics: crashlytics,
/// );
/// final result = await datasource.requestWithdraw(amount: 1000.0);
/// ```
class WithdrawDataSource implements WithdrawRepository {
  // implementação
}
```

#### Enums - Descreva o Propósito
```dart
/// Status possíveis de uma solicitação de afiliação.
///
/// Representa o ciclo de vida de uma solicitação desde a criação
/// até sua aprovação ou recusa.
enum AffiliationStatus {
  /// Solicitação aguardando análise do produtor.
  pending,
  
  /// Solicitação aprovada pelo produtor.
  approved,
  
  /// Solicitação recusada pelo produtor.
  refused,
  
  /// Solicitação cancelada pelo afiliado.
  cancelled,
}
```

## Comentários de Supressão (ignore)

### Ignore File
```dart
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: avoid_print

/// Classe de exemplo...
class Example {
  // implementação
}
```

### Ignore Line
```dart
// ignore: avoid_print
print('Debug: valor = $value');

// ignore: unused_element
void _debugHelper() {
  // helper temporário para debug
}
```

## Referências e Links

### Usar Colchetes para Identificadores
```dart
/// Carrega os dados do [User] a partir do [userId] fornecido.
///
/// Retorna um [Either] contendo [UserSessionFailure] se a sessão expirou,
/// [OfflineFailure] se não há conexão, ou os dados do [User] em caso de sucesso.
///
/// Veja também:
/// * [SessionHelper] para gerenciar sessões de usuário
/// * [ConnectivityHelper] para verificar conectividade
Future<Either<Failure?, User>> loadUserData(String userId) async {
  // implementação
}
```

### Links para Documentação Externa
```dart
/// Implementa autenticação biométrica seguindo as guidelines do Flutter.
///
/// Baseado em: https://pub.dev/packages/local_auth
///
/// Veja também:
/// * https://developer.android.com/training/sign-in/biometric-auth
/// * https://developer.apple.com/documentation/localauthentication
class BiometricHelper {
  // implementação
}
```

## Comentários Inline (//)

### Quando Usar
```dart
/// Calcula o saldo total da carteira do usuário.
Future<double> calculateWalletBalance() async {
  // Busca transações dos últimos 30 dias para otimizar performance
  final transactions = await _getRecentTransactions(days: 30);
  
  // Aplica regra de negócio: comissões são creditadas após 7 dias
  final availableBalance = transactions
      .where((t) => t.createdAt.isBefore(DateTime.now().subtract(Duration(days: 7))))
      .fold(0.0, (sum, t) => sum + t.amount);
  
  return availableBalance;
}
```

### Explicações de Lógica Complexa
```dart
/// Valida e normaliza o CPF fornecido.
String normalizeCpf(String cpf) {
  // Remove caracteres não numéricos (pontos, hífens, espaços)
  final digitsOnly = cpf.replaceAll(RegExp(r'\D'), '');
  
  // CPF deve ter exatamente 11 dígitos após normalização
  if (digitsOnly.length != 11) {
    throw FormatException('CPF inválido: deve conter 11 dígitos');
  }
  
  return digitsOnly;
}
```

### Workarounds e TODOs

#### Formato de TODOs (Flutter Style)
```dart
// TODO(username): Descrição da tarefa a ser feita
// TODO(username): Migrar para nova API v2, https://github.com/org/repo/issues/123

/// Busca produtos usando a API v1.
///
/// Método legado mantido para compatibilidade.
@Deprecated('Use fetchProductsV2() instead')
Future<List<Product>> fetchProducts() async {
  // TODO(joao): Remover após migração completa para v2 - Sprint 45
  return _apiV1.getProducts();
}
```

#### FIXME e Hacks Temporários
```dart
/// Calcula juros compostos sobre o valor.
double calculateInterest(double principal, double rate) {
  // FIXME: Cálculo incorreto para valores acima de R$ 10.000
  // Issue: https://github.com/carlosandrercouto/app/issues/456
  // Workaround temporário até correção da fórmula
  if (principal > 10000) {
    return principal * rate * 0.95; // Aplicando fator de correção
  }
  
  return principal * rate;
}
```

## Documentação de Testes

**Para regras completas sobre testes unitários, consulte:**
**`.cursor/rules/cursorrules-unit-tests.mdc`**

Este arquivo dedicado contém:
- Estrutura e organização de testes (UseCase, Bloc, Models, Entities)
- Padrões para Fixtures, Mocks e Helpers
- Nomenclatura e boas práticas
- Checklist de qualidade
- Exemplos detalhados para cada tipo de teste

### Princípios Básicos para Documentação em Testes
- **Use doc comments (///) para fixtures e test helpers**
- **Títulos de testes em inglês americano, simples e diretos**
- **Documente apenas testes complexos ou não óbvios**
- **Evite documentar testes auto-explicativos**

## Documentação de Código de Produção (Clean Architecture)

### DataSources (Camada de Data)

#### Estrutura Completa
```dart
/// Um datasource para gerenciar operações de saque via API.
///
/// Esta classe é responsável por:
/// * Fazer chamadas à API de saques
/// * Converter respostas JSON em [WithdrawModel]
/// * Tratar erros e registrá-los no Firebase Crashlytics
/// * Mapear erros de API para [Failure] objects
///
/// Implementa [WithdrawRepository] seguindo Clean Architecture.
class WithdrawDataSource implements WithdrawRepository {
  /// Cria uma instância do [WithdrawDataSource].
  ///
  /// [apiService] é usado para fazer requisições HTTP.
  /// [firebaseCrashlytics] é usado para logging de erros.
  WithdrawDataSource({
    required this.apiService,
    required this.firebaseCrashlytics,
  });

  final ApiService apiService;
  final FirebaseCrashlytics firebaseCrashlytics;

  @override
  Future<Either<Failure?, WithdrawEntity>> requestWithdraw({
    required double amount,
  }) async {
    try {
      // Validação prévia do valor mínimo
      if (amount < 50.0) {
        return const Left(InvalidAmountFailure());
      }

      final response = await apiService.post(
        endpoint: '/withdraw/request',
        body: {'amount': amount},
      );

      if (response.success) {
        final model = WithdrawModel.fromApi(map: response.data);
        return Right(model);
      }

      return const Left(null);
    } on TimeoutException {
      return const Left(TimeoutFailure());
    } catch (error, stackTrace) {
      // Registra erro no Crashlytics para análise
      await firebaseCrashlytics.recordError(
        error,
        stackTrace,
        reason: 'Erro ao solicitar saque de R\$ $amount',
      );
      
      log('Erro ao solicitar saque: $error', name: 'WithdrawDataSource');
      return const Left(null);
    }
  }
}
```

#### Logs e Debug
```dart
/// Busca o histórico de saques do usuário.
Future<Either<Failure?, List<WithdrawEntity>>> getWithdrawHistory() async {
  try {
    // Log de debug para rastreamento em desenvolvimento
    log('Buscando histórico de saques', name: 'WithdrawDataSource');
    
    final response = await apiService.get(endpoint: '/withdraw/history');
    
    if (response.success) {
      final withdraws = (response.data['withdraws'] as List)
          .map((json) => WithdrawModel.fromApi(map: json))
          .toList();
      
      log('Histórico carregado: ${withdraws.length} saques', name: 'WithdrawDataSource');
      return Right(withdraws);
    }
    
    return const Left(null);
  } catch (error, stackTrace) {
    await firebaseCrashlytics.recordError(
      error,
      stackTrace,
      reason: 'Falha ao buscar histórico de saques',
    );
    
    return const Left(null);
  }
}
```

### Repositories (Camada de Domain)

```dart
/// Interface para operações de saque.
///
/// Define os métodos disponíveis para gerenciar saques,
/// sem expor detalhes de implementação.
///
/// Implementado por [WithdrawDataSource] na camada de data.
abstract class WithdrawRepository {
  /// Solicita um novo saque.
  ///
  /// Retorna [Right] com [WithdrawEntity] em caso de sucesso,
  /// ou [Left] com [Failure] em caso de erro.
  ///
  /// Possíveis falhas:
  /// * [InvalidAmountFailure] - Valor abaixo do mínimo permitido
  /// * [TimeoutFailure] - Timeout na requisição
  /// * [OfflineFailure] - Sem conexão com internet
  /// * `null` - Erro genérico
  Future<Either<Failure?, WithdrawEntity>> requestWithdraw({
    required double amount,
  });

  /// Busca o histórico de saques do usuário.
  ///
  /// Retorna lista vazia se não houver saques registrados.
  Future<Either<Failure?, List<WithdrawEntity>>> getWithdrawHistory();
}
```

### UseCases (Camada de Domain)

```dart
/// Caso de uso para solicitar um novo saque.
///
/// Encapsula a lógica de negócio para validar e processar
/// solicitações de saque, incluindo verificações de saldo
/// e limites diários.
///
/// Exemplo de uso:
/// ```dart
/// final useCase = RequestWithdrawUseCase(repository: repository);
/// final result = await useCase(amount: 1000.0);
/// 
/// result.fold(
///   (failure) => print('Erro: $failure'),
///   (withdraw) => print('Saque solicitado: ${withdraw.id}'),
/// );
/// ```
class RequestWithdrawUseCase {
  /// Cria uma instância do [RequestWithdrawUseCase].
  RequestWithdrawUseCase({required this.repository});

  final WithdrawRepository repository;

  /// Executa o caso de uso.
  ///
  /// Valida o [amount] e delega a solicitação para o [repository].
  ///
  /// Regras de negócio aplicadas:
  /// * Valor mínimo: R$ 50,00
  /// * Valor máximo: R$ 50.000,00
  /// * Limite diário: 3 saques
  Future<Either<Failure?, WithdrawEntity>> call({
    required double amount,
  }) async {
    // Valida valor máximo (regra de negócio)
    if (amount > 50000.0) {
      return const Left(MaxAmountExceededFailure());
    }

    return repository.requestWithdraw(amount: amount);
  }
}
```

### Entities (Camada de Domain)

```dart
/// Representa um saque no domínio da aplicação.
///
/// Esta entidade encapsula os dados essenciais de um saque,
/// independente da fonte de dados (API, banco local, etc).
///
/// Invariantes:
/// * [amount] deve ser sempre positivo
/// * [id] é único e imutável
/// * [status] define o ciclo de vida do saque
class WithdrawEntity extends Equatable {
  /// Cria uma instância de [WithdrawEntity].
  ///
  /// Lança [AssertionError] se [amount] for negativo ou zero.
  const WithdrawEntity({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.processedAt,
  }) : assert(amount > 0, 'Amount must be positive');

  /// Identificador único do saque.
  final String id;

  /// Valor solicitado em reais.
  ///
  /// Sempre positivo, validado no construtor.
  final double amount;

  /// Status atual do saque.
  ///
  /// Veja [WithdrawStatus] para possíveis valores.
  final WithdrawStatus status;

  /// Data e hora de criação da solicitação.
  final DateTime createdAt;

  /// Data e hora de processamento.
  ///
  /// Null se o saque ainda está pendente.
  final DateTime? processedAt;

  /// Whether o saque foi processado.
  ///
  /// Retorna `true` se [processedAt] não é null.
  bool get isProcessed => processedAt != null;

  @override
  List<Object?> get props => [id, amount, status, createdAt, processedAt];
}
```

### Models (Camada de Data)

```dart
/// Model para conversão de dados de saque da API.
///
/// Estende [WithdrawEntity] e adiciona lógica de serialização/deserialização.
///
/// A API retorna valores monetários como strings formatadas (ex: "R$ 1.000,00"),
/// este model converte para [double] removendo formatação.
class WithdrawModel extends WithdrawEntity {
  /// Cria uma instância de [WithdrawModel].
  const WithdrawModel({
    required super.id,
    required super.amount,
    required super.status,
    required super.createdAt,
    super.processedAt,
  });

  /// Cria um [WithdrawModel] a partir de um Map da API.
  ///
  /// Converte strings formatadas da API para tipos apropriados:
  /// * 'amount': String ("R$ 1.000,00") → double (1000.00)
  /// * 'status': String → [WithdrawStatus] enum
  /// * 'created_at': String (ISO 8601) → [DateTime]
  ///
  /// Exemplo de [map] esperado:
  /// ```json
  /// {
  ///   "id": "123",
  ///   "amount": "R$ 1.000,00",
  ///   "status": "pending",
  ///   "created_at": "2024-01-15T10:30:00Z"
  /// }
  /// ```
  factory WithdrawModel.fromApi({required Map<String, dynamic> map}) {
    return WithdrawModel(
      id: map['id'] as String,
      amount: _parseAmount(map['amount'] as String),
      status: WithdrawStatus.fromString(map['status'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
      processedAt: map['processed_at'] != null
          ? DateTime.parse(map['processed_at'] as String)
          : null,
    );
  }

  /// Converte string formatada "R$ 1.000,00" para double 1000.00.
  ///
  /// Remove símbolos de moeda, pontos de milhar e converte vírgula para ponto.
  static double _parseAmount(String formattedAmount) {
    return double.parse(
      formattedAmount
          .replaceAll('R\$', '')
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .trim(),
    );
  }
}
```

### Blocs/States (Camada de Presentation)

#### Bloc
```dart
/// Gerencia o estado da funcionalidade de saques.
///
/// Coordena solicitações de saque, carregamento de histórico
/// e tratamento de erros através de eventos e estados.
///
/// Eventos suportados:
/// * [RequestWithdrawEvent] - Solicita novo saque
/// * [LoadWithdrawHistoryEvent] - Carrega histórico
/// * [CancelWithdrawEvent] - Cancela saque pendente
///
/// Veja [WithdrawState] para possíveis estados.
class WithdrawBloc extends Bloc<WithdrawEvent, WithdrawState> {
  /// Cria uma instância de [WithdrawBloc].
  WithdrawBloc({
    required this.requestWithdrawUseCase,
    required this.getHistoryUseCase,
    required this.connectivityHelper,
  }) : super(WithdrawInitialState()) {
    on<RequestWithdrawEvent>(_onRequestWithdraw);
    on<LoadWithdrawHistoryEvent>(_onLoadHistory);
  }

  final RequestWithdrawUseCase requestWithdrawUseCase;
  final GetWithdrawHistoryUseCase getHistoryUseCase;
  final ConnectivityHelper connectivityHelper;

  /// Processa evento de solicitação de saque.
  ///
  /// Verifica conectividade antes de fazer a requisição.
  /// Emite estados apropriados baseado no resultado.
  Future<void> _onRequestWithdraw(
    RequestWithdrawEvent event,
    Emitter<WithdrawState> emit,
  ) async {
    emit(WithdrawLoadingState());

    // Verifica conectividade antes de prosseguir
    if (await connectivityHelper.isConnectionDown()) {
      emit(WithdrawErrorOfflineState());
      return;
    }

    final result = await requestWithdrawUseCase(amount: event.amount);

    result.fold(
      (failure) => _handleFailure(failure, emit),
      (withdraw) => emit(WithdrawSuccessState(withdraw: withdraw)),
    );
  }

  /// Mapeia [Failure] para estados de erro apropriados.
  void _handleFailure(Failure? failure, Emitter<WithdrawState> emit) {
    if (failure is TimeoutFailure) {
      emit(WithdrawErrorTimeoutState());
    } else if (failure is UserSessionFailure) {
      emit(WithdrawErrorUserSessionState());
    } else {
      emit(WithdrawErrorState());
    }
  }
}
```

#### States
```dart
/// Estado base para a funcionalidade de saques.
///
/// Todos os estados específicos devem estender esta classe.
///
/// Usa [identityHashCode] para garantir que cada instância seja única,
/// permitindo que states sem propriedades sejam emitidos múltiplas vezes.
abstract class WithdrawState extends Equatable {
  @override
  List<Object> get props => [identityHashCode(this)];
}

/// Estado inicial do bloc.
///
/// Emitido quando o bloc é criado e nenhuma ação foi executada ainda.
class WithdrawInitialState extends WithdrawState {}

/// Estado de carregamento.
///
/// Emitido quando uma operação assíncrona está em andamento.
class WithdrawLoadingState extends WithdrawState {}

/// Estado de sucesso após solicitar um saque.
///
/// Contém os dados do saque criado.
class WithdrawSuccessState extends WithdrawState {
  /// Cria uma instância de [WithdrawSuccessState].
  WithdrawSuccessState({required this.withdraw});

  /// O saque que foi criado com sucesso.
  final WithdrawEntity withdraw;

  @override
  List<Object> get props => [withdraw];
}
```

## Logs e Debugging

### Princípios de Logging
- **Nunca use `print()` em produção** - Use `log()` da biblioteca `dart:developer`
- **Sempre nomeie seus logs** - Use o parâmetro `name` para identificar a origem
- **Inclua contexto relevante** - Adicione variáveis importantes na mensagem
- **Use níveis apropriados** - Debug, Info, Warning, Error

### Logs de Desenvolvimento (dart:developer)

```dart
import 'dart:developer' as developer;

/// Carrega dados do usuário.
Future<User> loadUser(String userId) async {
  // Log de entrada com contexto
  developer.log(
    'Carregando dados do usuário: $userId',
    name: 'UserDataSource',
  );

  final user = await _fetchUser(userId);

  // Log de sucesso com resultado
  developer.log(
    'Usuário carregado: ${user.name} (${user.email})',
    name: 'UserDataSource',
    level: 800, // Level.INFO
  );

  return user;
}

/// Processa pagamento com logging detalhado.
Future<void> processPayment(Payment payment) async {
  developer.log(
    'Iniciando processamento de pagamento',
    name: 'PaymentService',
    error: null,
    stackTrace: null,
  );

  try {
    await _process(payment);
    
    developer.log(
      'Pagamento processado com sucesso: ${payment.id}',
      name: 'PaymentService',
      level: 800,
    );
  } catch (error, stackTrace) {
    developer.log(
      'Erro ao processar pagamento: ${payment.id}',
      name: 'PaymentService',
      level: 1000, // Level.SEVERE
      error: error,
      stackTrace: stackTrace,
    );
    rethrow;
  }
}
```

### Logs de Erro (Firebase Crashlytics)

#### Logging Básico
```dart
/// Solicita saque tratando erros com Crashlytics.
Future<Either<Failure?, Withdraw>> requestWithdraw(double amount) async {
  try {
    final result = await _apiService.post('/withdraw', {'amount': amount});
    return Right(result);
  } catch (error, stackTrace) {
    // Registra erro no Crashlytics com contexto
    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: 'Falha ao solicitar saque de R\$ ${amount.toStringAsFixed(2)}',
    );

    // Também loga localmente para debug
    developer.log(
      'Erro ao solicitar saque',
      name: 'WithdrawDataSource',
      error: error,
      stackTrace: stackTrace,
    );

    return const Left(null);
  }
}
```

#### Com Informações Customizadas
```dart
/// Processa upload de imagem com logging detalhado.
Future<String> uploadImage(File image) async {
  try {
    // Adiciona informações customizadas antes do erro
    await FirebaseCrashlytics.instance.setCustomKey('image_size', image.lengthSync());
    await FirebaseCrashlytics.instance.setCustomKey('image_path', image.path);

    final url = await _uploadToServer(image);
    return url;
  } catch (error, stackTrace) {
    // Erro será registrado com as informações customizadas
    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: 'Falha ao fazer upload de imagem (${image.lengthSync()} bytes)',
      information: ['Tentativa de upload', 'User ID: ${_currentUserId}'],
      fatal: false, // Não é um erro fatal
    );

    rethrow;
  }
}
```

### Analytics (Firebase Analytics)

#### Eventos Básicos
```dart
/// Registra evento de login bem-sucedido.
Future<void> onLoginSuccess(String userId) async {
  await AnalyticsHelper.instance.sendAnalyticsEvent(
    eventName: AnalyticsEvents.userLoginSuccess,
    parameters: {
      'user_id': userId,
      'login_method': 'email',
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}

/// Registra evento de visualização de produto.
Future<void> onProductViewed(Product product) async {
  await AnalyticsHelper.instance.sendAnalyticsEvent(
    eventName: AnalyticsEvents.productViewed,
    parameters: {
      'product_id': product.id,
      'product_name': product.name,
      'category': product.category,
      'price': product.price,
    },
  );
}
```

#### Eventos de Conversão
```dart
/// Registra conclusão de compra.
Future<void> onPurchaseCompleted(Purchase purchase) async {
  await AnalyticsHelper.instance.sendAnalyticsEvent(
    eventName: AnalyticsEvents.purchaseCompleted,
    parameters: {
      'transaction_id': purchase.id,
      'value': purchase.totalAmount,
      'currency': 'BRL',
      'items': purchase.items.length,
      'payment_method': purchase.paymentMethod,
    },
  );
}
```

## Documentação de Widgets (UI)

### Widgets Customizados

```dart
/// Um botão customizado seguindo o design system do app.
///
/// Este widget encapsula o estilo padrão de botões, incluindo
/// cores, espaçamento, estados de loading e disabled.
///
/// Exemplo de uso:
/// ```dart
/// CustomButton(
///   text: 'Solicitar Saque',
///   onPressed: () => _requestWithdraw(),
///   isLoading: state is LoadingState,
/// )
/// ```
///
/// Veja também:
/// * [CustomOutlinedButton] para botões com borda
/// * [CustomTextButton] para botões de texto
class CustomButton extends StatelessWidget {
  /// Cria um [CustomButton].
  ///
  /// [text] é obrigatório e não pode estar vazio.
  /// [onPressed] pode ser null para botões desabilitados.
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
  }) : assert(text != '', 'Text cannot be empty');

  /// O texto exibido no botão.
  final String text;

  /// Callback executado quando o botão é pressionado.
  ///
  /// Se null, o botão ficará desabilitado.
  final VoidCallback? onPressed;

  /// Whether o botão está em estado de loading.
  ///
  /// Quando true, exibe um [CircularProgressIndicator] e desabilita o botão.
  final bool isLoading;

  /// Cor de fundo customizada do botão.
  ///
  /// Se null, usa a cor primária do tema.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        minimumSize: const Size(double.infinity, 48),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Text(text),
    );
  }
}
```

### Telas/Screens

```dart
/// Tela de solicitação de saque.
///
/// Permite o usuário informar o valor desejado e solicitar um saque.
/// Valida o valor mínimo, exibe o saldo disponível e histórico de saques.
///
/// Requer que o usuário esteja autenticado e tenha saldo disponível.
class WithdrawScreen extends StatelessWidget {
  /// Rota desta tela.
  static const routeName = '/withdraw';

  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WithdrawBloc(
        requestWithdrawUseCase: context.read(),
        getHistoryUseCase: context.read(),
        connectivityHelper: context.read(),
      )..add(LoadWithdrawHistoryEvent()),
      child: const _WithdrawScreenContent(),
    );
  }
}
```

## Annotations e Metadados

### @deprecated
```dart
/// Busca produtos usando a API v1.
///
/// Este método está obsoleto e será removido na versão 3.0.
/// Use [fetchProductsV2] para a nova implementação.
@Deprecated('Use fetchProductsV2() instead. Will be removed in v3.0')
Future<List<Product>> fetchProducts() async {
  return _apiV1.getProducts();
}
```

### @visibleForTesting
```dart
/// Helper interno para parsing de valores monetários.
///
/// Visível apenas para testes. Não deve ser usado fora da classe.
@visibleForTesting
static double parseMoneyString(String value) {
  return double.parse(
    value.replaceAll('R\$', '').replaceAll('.', '').replaceAll(',', '.').trim(),
  );
}
```

### @protected
```dart
abstract class BaseRepository {
  /// Converte [Failure] para mensagem amigável ao usuário.
  ///
  /// Método protegido disponível para subclasses.
  @protected
  String getErrorMessage(Failure failure) {
    if (failure is TimeoutFailure) {
      return 'Tempo esgotado. Tente novamente.';
    }
    return 'Erro inesperado. Tente novamente.';
  }
}
```

## Markdown em Doc Comments

### Listas
```dart
/// Gerencia operações de autenticação do usuário.
///
/// Funcionalidades suportadas:
/// * Login com email/senha
/// * Login com biometria
/// * Login social (Google, Facebook, Apple)
/// * Recuperação de senha
/// * Logout
///
/// Todos os métodos retornam [Either<Failure, User>].
class AuthService {
  // implementação
}
```

### Code Blocks
```dart
/// Valida um CPF brasileiro.
///
/// Exemplo:
/// ```dart
/// final isValid = CpfValidator.validate('123.456.789-00');
/// if (isValid) {
///   print('CPF válido');
/// }
/// ```
///
/// Formato aceito:
/// ```
/// 123.456.789-00  // Com formatação
/// 12345678900     // Sem formatação
/// ```
class CpfValidator {
  // implementação
}
```

### Links
```dart
/// Implementa autenticação via Firebase Auth.
///
/// Documentação oficial:
/// https://firebase.google.com/docs/auth
///
/// Veja também:
/// * [BiometricHelper] para autenticação biométrica
/// * [SessionHelper] para gerenciar sessões
class FirebaseAuthService {
  // implementação
}
```

## Boas Práticas Gerais

### DO: Formatação e Clareza
✅ **Comece com letra maiúscula e termine com ponto final**
✅ **Primeira frase = sumário completo que faz sentido sozinho**
✅ **Use parágrafos separados por linha em branco**
✅ **Mantenha linhas em até 80 caracteres**
✅ **Use verbos na terceira pessoa para métodos**
✅ **Use frases nominais para propriedades**
✅ **Use "Whether" para propriedades booleanas**

### DO: Conteúdo Útil
✅ **Documente o "porquê", não o "o quê"**
✅ **Explique decisões não óbvias**
✅ **Inclua exemplos de uso para APIs complexas**
✅ **Liste possíveis exceções/falhas**
✅ **Documente comportamentos edge cases**
✅ **Use colchetes [] para referenciar identificadores**

### DON'T: O Que Evitar
❌ **Não use block comments (/* */) para documentação**
❌ **Não repita o que o código já diz**
❌ **Não documente o óbvio**
❌ **Não deixe documentação desatualizada**
❌ **Não use linguagem informal ou gírias**
❌ **Não documente getters/setters triviais**

## Checklist de Qualidade

### Antes de Commitar
- [ ] Toda classe pública tem doc comment com sumário
- [ ] Métodos públicos têm doc comments explicando propósito
- [ ] Parâmetros não óbvios estão documentados
- [ ] Possíveis exceções/failures estão listadas
- [ ] Exemplos de uso incluídos quando apropriado
- [ ] Links para documentação externa quando relevante
- [ ] Primeira frase faz sentido isoladamente
- [ ] Identificadores referenciados com colchetes []
- [ ] Sem erros de português ou gramática
- [ ] Comentários inline explicam lógicas complexas
- [ ] TODOs seguem formato: `// TODO(username): descrição`
- [ ] Logs usam `log()` ao invés de `print()`
- [ ] Erros críticos registrados no Crashlytics

### Revisão de Código
- [ ] Documentação está atualizada com mudanças
- [ ] Novos métodos públicos têm documentação
- [ ] Exemplos de código funcionam corretamente
- [ ] Documentação segue estilo do projeto
- [ ] Não há comentários redundantes
- [ ] Links externos estão funcionando

## Ferramentas e Geração de Documentação

### Gerar Documentação com dartdoc
```bash
# Gerar documentação completa
dart doc .

# Gerar e abrir no navegador
dart doc . && open doc/api/index.html
```

### Visualizar Documentação no IDE
- **VS Code**: Hover sobre símbolo
- **Android Studio/IntelliJ**: Ctrl+Q (Windows/Linux) ou Cmd+J (Mac)
- **Quick documentation popup** mostra os doc comments formatados

## Referências Oficiais

- [Effective Dart: Documentation](https://dart.dev/effective-dart/documentation)
- [Dart API Documentation Guidelines](https://dart.dev/tools/dart-doc)
- [Flutter Documentation Best Practices](https://flutter.dev/docs/development/packages-and-plugins/documentation)
- [Firebase Crashlytics Documentation](https://firebase.google.com/docs/crashlytics)
- [Firebase Analytics Documentation](https://firebase.google.com/docs/analytics)

## Arquivo de Testes Unitários

**Para regras completas sobre testes unitários, consulte:**
**`.cursor/rules/cursorrules-unit-tests.mdc`**
