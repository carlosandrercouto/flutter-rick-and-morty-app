---
description: Executa a purga profunda dos caches do Flutter, resolve pacotes e reconstrói Pods no iOS
---
// turbo-all
- Limpa todos os arquivos de build gerados pelo Flutter - flutter clean
- Baixe novamente as dependencias - flutter pub get
- Limpe os pods do iOS - pod deintegrate, rm -rf pods, rm -rf Podfile.lock
- Reinstale os pods - pod install
- Caso ocorra algum problema, me informe
