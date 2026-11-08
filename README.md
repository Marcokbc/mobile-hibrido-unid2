# EcoRotina 🌱 — Aplicativo de Sustentabilidade

> **Atividade OAT — Desenvolvimento Mobile Híbrido (Flutter)**  
> **Faculdade UniFTC** | **Professor:** XZ6816 (`XZ6816@prof.uniftc.edu.br`)  
> **Trabalho em Dupla:** Valor 20 Pontos (10 APK + 10 Documentação)

---

## 📱 Sobre o EcoRotina
O **EcoRotina** é um aplicativo mobile híbrido desenvolvido em **Flutter** focado em resolver um dos maiores desafios do nosso tempo: a sustentabilidade no cotidiano. O app transforma pequenos hábitos diários em impactos ambientais positivos e mensuráveis, alinhando-se aos **Objetivos de Desenvolvimento Sustentável (ODS) 12 e 13 da ONU**.

### 🌟 Principais Funcionalidades & Requisitos Atendidos
- **Lista Interativa de Metas/Hábitos:** Categorizados por *Água, Energia, Resíduos, Mobilidade e Consumo*.
- **Ações na Lista:** Adicionar novos hábitos (via Modal Dialog), Concluir (checkbox dinâmico com efeito visual) e Remover (botão de lixeira com confirmação).
- **Persistência de Dados:** Salva e carrega automaticamente no disco do celular usando `shared_preferences` com serialização e desserialização em JSON.
- **Segunda Tela com Navegação:** Tela de estatísticas detalhadas acessível pelo AppBar via `Navigator.push`.
- **Diferenciais Criativos:**
  - 💧 **Calculadora de Impacto em Tempo Real:** Litros de água poupados, kWh de energia economizados e kg de CO₂ evitados calculados instantaneamente.
  - 📈 **Progresso Diário:** Barra de acompanhamento percentual das metas do dia.
  - 💡 **Dica Sustentável do Dia:** Dicas práticas e rotativas para aplicar em casa ou na universidade.
  - 🏅 **Medalhas Virtuais (Gamificação):** Conquistas desbloqueadas conforme o cumprimento dos hábitos.

---

## 📸 Capturas de Tela (Evidências)

| Tela Principal (Impacto & Metas) | Adicionar Hábito (Modal) | Conclusão & Recálculo |
| :---: | :---: | :---: |
| ![Tela Principal](doc/screenshots/01_tela_principal.png) | ![Modal Adicionar](doc/screenshots/02_modal_adicionar_habito.png) | ![Concluído](doc/screenshots/03_habito_concluido_impacto_recalculado.png) |

| Segunda Tela (Dica & Resumo) | Conquistas & ODS da ONU |
| :---: | :---: |
| ![Segunda Tela](doc/screenshots/04_segunda_tela_estatisticas_dica_dia.png) | ![Conquistas](doc/screenshots/05_medalhas_conquistas_ods_onu.png) |

---

## 📦 Como Instalar o APK no Celular Android

O arquivo executável do aplicativo já está compilado e disponível na pasta:
👉 **[`release/apk/ecorotina.apk`](release/apk/ecorotina.apk)** *(ou em `build/app/outputs/flutter-apk/app-release.apk`)*

1. Transfira o arquivo `ecorotina.apk` para o celular (via cabo USB, Drive, WhatsApp, etc.).
2. No celular, clique sobre o arquivo `.apk` baixado.
3. Se solicitado, permita a instalação a partir da fonte desconhecida.
4. Clique em **Instalar** e, ao finalizar, em **Abrir**.

---

## 🛠️ Como Executar o Projeto Localmente

### Pré-requisitos
- Flutter SDK instalado (versão 3.24 ou superior)
- Android SDK configurado

### Comandos
```bash
# Obter as dependências do pub
flutter pub get

# Executar a suíte de testes unitários e de widgets
flutter test

# Executar o aplicativo no emulador ou dispositivo conectado
flutter run

# Compilar novo arquivo APK de produção (Release)
flutter build apk
```

---

## 📄 Documentação Completa para Entrega
O documento oficial de entrega exigido na atividade está gerado em PDF:
- **PDF Oficial:** [`doc/DOCUMENTACAO_ECO_ROTINA.pdf`](doc/DOCUMENTACAO_ECO_ROTINA.pdf)
- **Versão Markdown:** [`doc/DOCUMENTACAO.md`](doc/DOCUMENTACAO.md)
- **Versão HTML:** [`doc/documentacao.html`](doc/documentacao.html)

---

## 👥 Integrantes da Dupla
- **Marco** (Preencher com Nome Completo e Matrícula)
- **(Integrante 2)** (Preencher com Nome Completo e Matrícula da Dupla)
