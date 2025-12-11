# 📚 Wiki - NutriHealth Analytics

**Projeto III - Ciência de Dados**  
**Desenvolvedores:** Gustavo, Alves, Leonardo Paiva e Salomão Ferreira

---

## 📖 Índice

1. [Descrição do Tema e Justificativa](#1-descrição-do-tema-e-justificativa)
2. [Origem dos Dados Utilizados](#2-origem-dos-dados-utilizados)
3. [Técnicas de Ciência de Dados Aplicadas](#3-técnicas-de-ciência-de-dados-aplicadas)
4. [Funcionalidades Extras Implementadas](#4-funcionalidades-extras-implementadas)
5. [Dificuldades Enfrentadas e Soluções](#5-dificuldades-enfrentadas-e-soluções)
6. [Sugestões de Melhorias Futuras](#6-sugestões-de-melhorias-futuras)

---

## 1. Descrição do Tema e Justificativa

### 🎯 Tema

**Monitoramento Nutricional e Predição de Peso Corporal**

### 📝 Descrição

O **NutriHealth Analytics** é um aplicativo mobile que transforma dados nutricionais em insights acionáveis sobre saúde e composição corporal. Diferente de aplicativos tradicionais de contagem de calorias, este projeto aplica **Ciência de Dados** para prever tendências de peso futuras baseadas em padrões de consumo e gasto calórico.

### ✅ Justificativa

#### Por que este tema é relevante?

1. **Problema de Saúde Pública:**

   - A OMS estima que mais de 1,9 bilhão de adultos estão acima do peso
   - 650 milhões sofrem de obesidade
   - Monitoramento nutricional é essencial para prevenção de doenças metabólicas

2. **Lacuna Tecnológica:**

   - A maioria dos apps apenas registra calorias, sem predizer impactos futuros
   - Falta de aplicação de modelos preditivos acessíveis ao usuário comum

3. **Aplicação Prática de Data Science:**

   - Permite demonstrar conceitos como:
     - Geração de dados sintéticos realistas
     - Algoritmos de predição baseados em princípios científicos
     - Análise de séries temporais
     - Visualização de dados com gráficos interativos

4. **Impacto Social:**
   - Empoderar usuários com conhecimento sobre como seus hábitos afetam seu peso
   - Incentivar mudanças de comportamento baseadas em dados concretos

---

## 2. Origem dos Dados Utilizados

### 📊 Fonte de Dados

#### **Dados Sintéticos Gerados Algoritmicamente**

Devido à natureza acadêmica do projeto e para garantir privacidade, os dados são **gerados sinteticamente** pelo arquivo `data_repository.dart`. No entanto, a geração segue **padrões realistas** baseados em:

#### Fundamentos Científicos:

1. **Taxa Metabólica Basal (TMB):**

   - Adulto médio: 1500-1800 kcal/dia
   - Referência: Equação de Harris-Benedict

2. **Ingestão Calórica Diária:**

   - Café da Manhã: 250-600 kcal
   - Almoço: 500-1000 kcal
   - Jantar: 400-800 kcal
   - Lanches: 100-350 kcal
   - Suplementos: 80-300 kcal
   - **Total médio:** 1800-2500 kcal/dia

3. **Gasto Calórico por Exercícios:**
   - Musculação: 200-500 kcal/sessão
   - Cardio: 300-700 kcal/sessão
   - Esportes: 350-700 kcal/sessão
   - Caminhada: 100-300 kcal/sessão

#### Fontes de Referência:

- **National Institutes of Health (NIH)** - Tabelas de gasto calórico
- **USDA (U.S. Department of Agriculture)** - Valores nutricionais de alimentos
- **American College of Sports Medicine (ACSM)** - Guidelines de exercício

### 🔄 Estrutura dos Dados

```dart
HealthRecordModel {
  String id;            // Identificador único
  String titulo;        // Descrição (ex: "Arroz, feijão, frango")
  double calorias;      // Valor em kcal
  DateTime data;        // Timestamp do registro
  String categoria;     // Ex: "Almoço", "Musculação"
  RecordType tipo;      // Enum: ingestao ou gasto
}
```

### 📁 Arquivo CSV Auxiliar

O arquivo `dados_nutricao.csv` (na raiz do projeto) contém exemplos de registros nutricionais que podem ser usados como referência ou para extensões futuras do projeto.

---

## 3. Técnicas de Ciência de Dados Aplicadas

### 🧠 1. Geração de Dados Sintéticos (Data Synthesis)

**Localização:** `lib/services/data_repository.dart`

**Técnica:**

- Uso de distribuições aleatórias controladas (`Random`)
- Simulação de padrões temporais (6 meses de histórico)
- Variação realista baseada em estudos nutricionais

**Código-chave:**

```dart
// Exemplo: Geração de refeições com variação realista
double calorias = 500 + _random.nextDouble() * 500; // 500-1000 kcal
```

**Propósito:**

- Criar dataset de teste sem necessidade de coleta manual
- Permitir demonstração de algoritmos preditivos

---

### 🤖 2. Algoritmo de Predição de Peso (Regression Analysis)

**Localização:** `lib/services/data_repository.dart` → `calculateWeightProjection()`

#### **Fundamento Científico:**

Baseado no princípio termodinâmico de que:

```
7700 kcal de déficit/superávit ≈ 1kg de gordura corporal
```

#### **Metodologia:**

**Passo 1:** Calcular balanço calórico diário médio dos últimos 30 dias

```dart
double balancoMedioDiario = (totalIngestao - totalGasto) / 30;
```

**Passo 2:** Projetar balanço acumulado nos próximos 30 dias

```dart
double balancoProjetado30Dias = balancoMedioDiario * 30;
```

**Passo 3:** Converter para kg usando constante científica

```dart
const double KCAL_POR_KG = 7700.0;
double projecaoKg = balancoProjetado30Dias / KCAL_POR_KG;
```

#### **Exemplo Prático:**

```
Balanço médio: +200 kcal/dia
Projeção 30 dias: +200 × 30 = +6000 kcal
Ganho de peso: 6000 / 7700 = +0.78 kg
```

#### **Classificação de Tendência:**

- `ganho`: projeção > +0.5 kg
- `perda`: projeção < -0.5 kg
- `estável`: -0.5 kg ≤ projeção ≤ +0.5 kg

**Nível de Confiança:**

- **Alta:** > 100 registros nos últimos 30 dias
- **Média:** 50-100 registros
- **Baixa:** < 50 registros

---

### 📊 3. Análise de Séries Temporais (Time Series Analysis)

**Localização:** `lib/services/data_repository.dart` → `groupByMonth()`

**Técnica:**

- Agregação de dados por mês
- Cálculo de balanço líquido mensal
- Visualização de tendências com `fl_chart`

**Código-chave:**

```dart
Map<String, double> monthlyBalance = {};
for (var record in records) {
  String monthKey = '${record.data.month}/${record.data.year}';
  monthlyBalance[monthKey] += record.caloriasLiquidas;
}
```

**Aplicação:**

- Identificar padrões sazonais (ex: aumento de ingestão em dezembro)
- Detectar mudanças de comportamento ao longo do tempo

---

### 📈 4. Visualização de Dados (Data Visualization)

**Biblioteca:** `fl_chart`

#### Gráficos Implementados:

1. **Line Chart (Gráfico de Linha):**

   - Exibe balanço calórico mensal nos últimos 6 meses
   - Permite identificar tendências visuais

2. **Estatísticas em Cards:**
   - Total de ingestão
   - Total de queima
   - Balanço líquido

**Código-chave:**

```dart
LineChart(
  LineChartData(
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        gradient: LinearGradient(...),
      ),
    ],
  ),
)
```

---

### 🔍 5. Agregação e Sumarização de Dados

**Localização:** `lib/services/data_repository.dart`

**Técnicas:**

- `groupByCategory()`: Agrupa calorias por categoria
- `calculateStatistics()`: Calcula totais e médias
- `countByCategory()`: Conta frequência de registros

**Código-chave:**

```dart
Map<String, double> categoryTotals = {};
for (var record in records) {
  categoryTotals[record.categoria] =
    (categoryTotals[record.categoria] ?? 0) + record.calorias;
}
```

---

## 4. Funcionalidades Extras Implementadas

### ✨ Funcionalidades Obrigatórias (Atendidas)

✅ **Coleta de Dados:** Geração sintética realista  
✅ **Limpeza:** Validação de tipos e valores  
✅ **Análise:** Agregações e estatísticas  
✅ **Predição:** Algoritmo de peso corporal  
✅ **Visualização:** Gráficos interativos com fl_chart

### 🚀 Funcionalidades Extras (Diferenciais)

1. **Exportação CSV Real:**

   - Download de arquivo CSV com todos os registros
   - Formato compatível com Excel/Google Sheets

2. **Relatório PDF (HTML):**

   - Geração de relatório visual completo
   - Inclui predição, estatísticas e histórico
   - Pronto para impressão

3. **Categorização Detalhada:**

   - 5 categorias de ingestão (Café da Manhã, Almoço, Jantar, Lanche, Suplemento)
   - 5 categorias de gasto (Musculação, Cardio, Esportes, Caminhada, TMB)

4. **Interface Responsiva:**

   - Suporte a mobile, tablet e web
   - Design moderno com cores temáticas (verde = saúde)

5. **Indicadores Visuais de Tendência:**
   - Ícones dinâmicos (📈 ganho, 📉 perda, ⚖️ estável)
   - Cores contextuais (laranja para ganho, azul para perda)

---

## 5. Dificuldades Enfrentadas e Soluções

### 🚧 Desafio 1: Geração de Dados Realistas

**Problema:**

- Dados completamente aleatórios geravam padrões irrealistas
- Exemplo: Almoços de 5000 kcal ou exercícios de 10 kcal

**Solução:**

- Implementar faixas de valores baseadas em estudos nutricionais
- Usar `min + random.nextDouble() * (max - min)` para distribuições controladas

```dart
// Antes (irrealista):
double calorias = _random.nextDouble() * 5000;

// Depois (realista):
double calorias = 500 + _random.nextDouble() * 500; // 500-1000 kcal
```

---

### 🚧 Desafio 2: Algoritmo de Predição Preciso

**Problema:**

- Primeira versão usava médias simples sem considerar períodos recentes
- Predições não refletiam mudanças de comportamento

**Solução:**

- Filtrar apenas os últimos 30 dias (janela temporal)
- Calcular balanço médio diário neste período
- Adicionar sistema de confiança baseado em quantidade de dados

```dart
// Filtro temporal
DateTime thirtyDaysAgo = now.subtract(const Duration(days: 30));
List<HealthRecordModel> recentRecords = records
    .where((r) => r.data.isAfter(thirtyDaysAgo))
    .toList();
```

---

### 🚧 Desafio 3: Visualização de Gráficos

**Problema:**

- Biblioteca `fl_chart` tem API complexa
- Dificuldade em configurar tooltips e labels

**Solução:**

- Estudar documentação oficial e exemplos
- Criar funções auxiliares para formatação de dados
- Usar `LineTouchData` para tooltips interativos

```dart
lineTouchData: LineTouchData(
  touchTooltipData: LineTouchTooltipData(
    getTooltipItems: (touchedSpots) {
      return touchedSpots.map((spot) {
        return LineTooltipItem(
          '${spot.y.toStringAsFixed(0)} kcal',
          const TextStyle(color: Colors.white),
        );
      }).toList();
    },
  ),
)
```

---

### 🚧 Desafio 4: Exportação de Arquivos

**Problema:**

- Web não permite acesso direto ao sistema de arquivos
- Necessário usar blobs e downloads programáticos

**Solução:**

- Usar `universal_html` para compatibilidade web
- Criar objetos `Blob` e simular clique em `<a>` tag

```dart
final blob = html.Blob([bytes], 'text/csv;charset=utf-8');
final url = html.Url.createObjectUrlFromBlob(blob);
final anchor = html.document.createElement('a') as html.AnchorElement
  ..href = url
  ..download = 'NutriHealth_${DateTime.now()}.csv';
anchor.click();
```

---

### 🚧 Desafio 5: Refatoração de Código Existente

**Problema:**

- Projeto original era financeiro, precisava ser transformado em nutricional
- Manter estrutura enquanto muda lógica de negócio

**Solução:**

- Mapear conceitos financeiros → nutricionais:
  - `Receita` → `Ingestão Calórica`
  - `Despesa` → `Gasto Calórico`
  - `Saldo` → `Balanço Líquido`
  - `Predição de Gastos` → `Predição de Peso`
- Renomear classes e variáveis de forma consistente
- Adaptar algoritmos mantendo a arquitetura limpa

---

## 6. Sugestões de Melhorias Futuras

### 🔮 Curto Prazo (1-3 meses)

1. **Integração com APIs de Nutrição:**

   - Conectar com **USDA FoodData Central** para dados reais de alimentos
   - Permitir buscar alimentos por nome e obter calorias automaticamente

2. **Entrada Manual de Dados:**

   - Adicionar formulários para usuário registrar refeições
   - Interface para adicionar exercícios personalizados

3. **Persistência Local:**

   - Usar `sqflite` (SQLite) para armazenar dados no dispositivo
   - Permitir histórico personalizado do usuário

4. **Notificações Push:**
   - Lembrar usuário de registrar refeições
   - Alertar sobre tendências de ganho/perda excessivos

---

### 🚀 Médio Prazo (3-6 meses)

5. **Machine Learning Avançado:**

   - Implementar **Regressão Linear** real com biblioteca `ml_linalg`
   - Treinar modelos personalizados por usuário
   - Predição multi-variável (peso, IMC, % gordura)

6. **Reconhecimento de Imagens:**

   - Usar **TensorFlow Lite** para identificar alimentos por foto
   - Estimar porções e calorias automaticamente

7. **Integração com Wearables:**

   - Conectar com Apple Health / Google Fit
   - Sincronizar dados de exercícios automaticamente

8. **Gamificação:**
   - Sistema de conquistas (ex: "7 dias de déficit calórico")
   - Rankings e desafios entre amigos

---

### 🌟 Longo Prazo (6-12 meses)

9. **Backend com API REST:**

   - Desenvolver servidor em Node.js/Python
   - Armazenar dados na nuvem (Firebase/Supabase)
   - Permitir sincronização entre dispositivos

10. **Análise Preditiva Avançada:**

    - Implementar **LSTM (Long Short-Term Memory)** para previsões de séries temporais
    - Prever não apenas peso, mas também riscos de saúde

11. **Planos Personalizados:**

    - Gerar planos alimentares automáticos baseados em metas
    - Sugestões de exercícios para atingir objetivos

12. **Dashboards Comparativos:**
    - Comparar seus dados com médias populacionais
    - Benchmarking por idade, gênero, altura

---

### 🔬 Pesquisa e Desenvolvimento

13. **Publicação Científica:**

    - Coletar dados anonimizados de usuários
    - Publicar estudo sobre eficácia de predições de peso

14. **Parcerias com Nutricionistas:**
    - Validar algoritmos com profissionais de saúde
    - Certificar app para uso clínico

---

## 📚 Referências Bibliográficas

1. **Harris, J. A., & Benedict, F. G. (1918).** A biometric study of human basal metabolism. _Proceedings of the National Academy of Sciences_, 4(12), 370-373.

2. **USDA FoodData Central.** U.S. Department of Agriculture. Disponível em: https://fdc.nal.usda.gov/

3. **American College of Sports Medicine (ACSM).** Guidelines for Exercise Testing and Prescription. 10th Edition.

4. **World Health Organization (WHO).** Obesity and overweight. Disponível em: https://www.who.int/news-room/fact-sheets/detail/obesity-and-overweight

---

## 🎓 Conclusão

O **NutriHealth Analytics** demonstra com sucesso a aplicação de **Ciência de Dados** em um contexto real de saúde e bem-estar. O projeto vai além de um simples contador de calorias ao:

1. ✅ **Aplicar algoritmos preditivos** baseados em fundamentos científicos
2. ✅ **Gerar dados sintéticos realistas** para demonstração
3. ✅ **Visualizar informações complexas** de forma acessível
4. ✅ **Exportar relatórios profissionais** para análise externa
5. ✅ **Manter código limpo e documentado** seguindo boas práticas

Este projeto serve como base sólida para expansões futuras e comprova a viabilidade de usar **Data Science** para empoderar pessoas a tomar decisões informadas sobre sua saúde.

---

**Desenvolvido com 💚 por Gustavao Alves, Leonardo Paiva e Salomão Ferreira**  
**Tópicos Especiais em Computação & Ciência de Dados - 2025**
