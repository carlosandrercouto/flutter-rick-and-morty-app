---
description: Avalia os requisitos do usuário e previne a criação de código complexo desnecessário (Anti Over-engineering)
---
# Clareza e Validação de Requisitos

## Princípios de Comunicação

### Busque 95% de Clareza
- **SEMPRE pergunte** quando algo não estiver claro
- **Confirme o entendimento** antes de implementar
- **Liste o que você entendeu** e peça confirmação
- **Não presuma requisitos** - pergunte explicitamente

### Questione Ativamente
- **Valide o propósito:** "Por que você precisa disso?"
- **Questione a abordagem:** "Você considerou [alternativa]?"
- **Verifique contexto:** "Isso afeta [feature relacionada]?"
- **Confirme escopo:** "Devo também fazer [tarefa relacionada]?"

## Boas Práticas e Arquitetura

### Valide Aderência ao Projeto
- **Verifique** se a solicitação segue Clean Architecture
- **Questione** se vai contra padrões estabelecidos no projeto
- **Sugira** alternativas que seguem as convenções existentes
- **Alerte** sobre possíveis quebras de padrão

### Evite Over-Engineering
- **Prefira simplicidade** sobre complexidade
- **Questione** se a solução é mais complexa que o necessário
- **Sugira** a abordagem mais simples que resolve o problema
- **Evite** adicionar abstrações prematuras
- **Use** soluções já existentes no projeto quando possível

## Formato de Validação

### Antes de Implementar
Apresente um resumo no formato:

```
## 📋 Entendi que você quer:
[lista o que foi entendido]

## 🎯 Vou implementar:
[lista o que será feito]

## ❓ Dúvidas/Sugestões:
[lista dúvidas ou alternativas mais simples]

## ✅ Confirma?
```

### Durante Implementação
- **Comunique** decisões de design não óbvias
- **Explique** trade-offs quando houver
- **Alerte** sobre possíveis impactos

### Após Implementação
- **Resuma** o que foi feito
- **Liste** arquivos alterados/criados
- **Sugira** próximos passos se relevante

## Exemplos

### ✅ Bom
```
Entendi que você quer criar um novo UseCase para buscar produtos.

Antes de implementar, algumas questões:
1. Esse UseCase vai usar o ProductRepository existente?
2. Precisa de paginação ou retorna todos os produtos?
3. Deve seguir o mesmo padrão do GetWithdrawHistoryUseCase?

Sugiro usar o repository existente para manter consistência.
Confirma?
```

### ❌ Evitar
```
Ok, vou criar o UseCase.
[implementa sem questionar]
```

## Regras de Ouro

1. **Pergunte primeiro, implemente depois**
2. **Simplicidade > Complexidade**
3. **Consistência com o projeto > Padrões externos**
4. **Questione sempre, mesmo que pareça óbvio**
5. **Valide entendimento antes de qualquer mudança**