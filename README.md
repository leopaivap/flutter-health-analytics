# 🥗 Nutri### Principais Funcionalidades:

- 📊 **Dashboard Nutricional Interativo** com visualização de calorias consumidas vs. queimadas
- 🤖 **Predição de Peso** usando princípios termodinâmicos (7700 kcal ≈ 1kg)
- 📈 **Gráficos Temporais** de balanço calórico mensal
- 🔥 **Análise por Categorias** (Café da Manhã, Almoço, Jantar, Exercícios, etc.)
- 📉 **Análise de Tendências** com estatísticas avançadas, média móvel e projeção de peso
- 🧠 **Sistema de Recomendações Personalizadas** baseado em análise de dados e machine learning
- 📤 **Exportação de Relatórios** em CSV e PDF
- 💡 **Insights Inteligentes** sobre padrões alimentares e de atividade física
- 📜 **Histórico Completo** com busca, filtros e modal detalhadoytics

**Um aplicativo mobile de Monitoramento Nutricional e Predição de Peso usando Ciência de Dados**

---

## 📋 Objetivo

O **NutriHealth Analytics** é um aplicativo Flutter desenvolvido para monitorar ingestão e gasto calórico, oferecendo análises inteligentes sobre saúde nutricional e predições de peso corporal baseadas em algoritmos de Data Science.

### Principais Funcionalidades:

- 📊 **Dashboard Nutricional Interativo** com visualização de calorias consumidas vs. queimadas
- 🤖 **Predição de Peso com IA** usando princípios termodinâmicos (7700 kcal ≈ 1kg)
- 📈 **Gráficos Temporais** de balanço calórico mensal
- 🔥 **Análise por Categorias** (Café da Manhã, Almoço, Jantar, Exercícios, etc.)
- � **Análise de Tendências** com estatísticas avançadas, média móvel e projeção de peso
- 🧠 **Sistema de Recomendações IA** com sugestões personalizadas baseadas em machine learning
- �📤 **Exportação de Relatórios** em CSV e PDF
- 💡 **Insights Inteligentes** sobre padrões alimentares e de atividade física
- 📜 **Histórico Completo** com busca, filtros e modal detalhado

---

## 🚀 Como Instalar e Executar

### Pré-requisitos:

- Flutter SDK (versão 3.0 ou superior)
- Dart SDK
- Editor de código (VS Code, Android Studio, etc.)
- Emulador Android/iOS ou dispositivo físico

### Passos de Instalação:

1. **Clone o repositório:**

```bash
git clone <url-do-repositorio>
cd app3_ciencia_dados
```

2. **Instale as dependências:**

```bash
flutter pub get
```

3. **Execute o aplicativo:**

```bash
flutter run
```

Para executar em um navegador web:

```bash
flutter run -d chrome
```

---

## 📂 Estrutura do Projeto

```
lib/
├── models/
│   └── health_record_model.dart      # Modelo de dados de registros nutricionais
├── services/
│   ├── data_repository.dart          # Geração de dados e algoritmo de predição
│   └── export_service.dart           # Exportação CSV/PDF
├── screens/
│   ├── home_container.dart           # Container com navegação bottom bar (5 telas)
│   ├── dashboard_screen.dart         # Dashboard principal com gráficos
│   ├── categories_screen.dart        # Análise por categorias com pie chart
│   ├── trends_screen.dart            # Análise de tendências e estatísticas avançadas
│   ├── recommendations_screen.dart   # Sistema de recomendações IA
│   └── history_screen.dart           # Histórico com busca e filtros
└── main.dart                         # Ponto de entrada do aplicativo
```

### Arquitetura:

- **Camada Model**: Define estruturas de dados (`HealthRecordModel`, `RecordType`)
- **Camada Service**: Lógica de negócio (geração de dados mock, algoritmos de predição, exportação)
- **Camada View**: Interface do usuário (Flutter Widgets, fl_chart para gráficos)

---

## 🎯 Como Usar

### 1. Dashboard Principal (Tela 1)

Ao abrir o app, você verá:

- **Card de Boas-Vindas**: Resumo do número de registros analisados
- **Card de Predição de Peso**: Projeção de ganho/perda de peso nos próximos 30 dias
- **Cards Estatísticos**: Total de ingestão, queima e balanço calórico
- **Gráfico Temporal**: Evolução do balanço calórico mensal

### 2. Análise por Categorias (Tela 2)

- **Gráfico de Pizza (Pie Chart)**: Distribuição percentual por categoria nutricional
- **Ranking**: Top categorias por volume calórico
- **Seletor**: Alternar entre ingestão e gasto
- **Insights**: Análise automática de padrões

### 3. Análise de Tendências (Tela 3)

**Recursos avançados de data science:**

- **Estatísticas do Período**: Balanço médio, desvio padrão, tendência de peso, consistência
- **Projeção de Peso**: Gráfico de evolução temporal baseado no balanço calórico acumulado
- **Distribuição Calórica**: Gráfico de barras por categoria
- **Média Móvel (7 dias)**: Suaviza flutuações para identificar tendências
- **Insights Automáticos**: Análise inteligente dos dados com recomendações

**Funcionalidades:**
- Filtro de período (7, 30, 90, 180 dias)
- Cálculo de variância e desvio padrão
- Projeção científica de peso (regra 7700 kcal = 1kg)

### 4. Recomendações Personalizadas (Tela 4)

**Sistema inteligente de recomendações baseado em análise de dados:**

- **Perfil Nutricional**: Análise automática do seu comportamento alimentar
- **Recomendações Priorizadas**: Alta, Média, Baixa prioridade com cores distintas
- **Fundamento Científico**: Cada recomendação é justificada com referências científicas
- **Ações Práticas**: Lista de ações concretas para implementar
- **Metas Sugeridas**: Objetivos personalizados baseados no seu perfil
- **Cálculo de Consistência**: Análise de variabilidade usando coeficiente de variação
- **Diversidade Nutricional**: Métricas de variedade alimentar

**Recomendações geradas automaticamente:**
- Ajuste de balanço calórico
- Frequência de exercícios
- Variedade alimentar
- Consistência de rotina
- Hidratação e saúde geral

### 5. Histórico Completo (Tela 5)

- **Lista de todos os registros** com ordenação cronológica
- **Busca por título**: Filtro em tempo real
- **Filtros**: Por tipo (ingestão/gasto) e categoria
- **Modal Detalhado**: Clique em um item para ver todos os detalhes

### 6. Análise de Dados

O aplicativo analisa automaticamente:

- Padrões de alimentação por categoria (Café da Manhã, Almoço, etc.)
- Gastos calóricos por tipo de exercício (Musculação, Cardio, etc.)
- Tendências de peso baseadas no balanço calórico
- **Estatísticas avançadas**: Média, desvio padrão, média móvel, projeção temporal
- **Métricas de comportamento**: Consistência, diversidade, frequência de exercícios
- **Geração de insights**: Análise contextual com recomendações personalizadas

### 7. Exportação de Relatórios

- **Botão CSV**: Baixa uma planilha com todos os registros
- **Botão PDF**: Gera um relatório HTML completo (use Ctrl+P para salvar como PDF)

---

## 👥 Créditos da Equipe

**Desenvolvedores:**

- 👨‍💻 **Leonardo Paiva**
- 👨‍💻 **Salomão Ferreira**

**Disciplina:** Projeto III - Ciência de Dados  
**Instituição:** [Sua Universidade]  
**Ano:** 2025

---

## 📖 Documentação Completa

Para informações detalhadas sobre:

- Técnicas de Ciência de Dados aplicadas
- Origem e estrutura dos dados
- Dificuldades enfrentadas e soluções
- Melhorias futuras

👉 **[Acesse a Wiki Completa](WIKI.md)**

---

## 📜 Licença

Este projeto foi desenvolvido para fins acadêmicos como parte do trabalho universitário "Projeto III".

---

## 🛠️ Tecnologias Utilizadas

- **Flutter** 3.x - Framework de UI multiplataforma
- **Dart** - Linguagem de programação
- **fl_chart** - Biblioteca para gráficos interativos
- **csv** - Exportação de dados em CSV
- **universal_html** - Geração de relatórios HTML/PDF

---

## 📞 Contato

Para dúvidas ou sugestões:

- **Leonardo Paiva**: [email/contato]
- **Salomão Ferreira**: [email/contato]

---

**Desenvolvido com 💚 usando Flutter e Data Science**
