# 📘 Azure Container Apps (ACA) - Guia de Bolso

[![Azure](https://img.shields.io/badge/Azure-Container%20Apps-blue?logo=microsoft-azure)](https://azure.microsoft.com/services/container-apps/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Portuguese](https://img.shields.io/badge/Language-Portuguese-yellow.svg)](README.md)

O **Azure Container Apps** é um serviço de contêineres **serverless** construído sobre Kubernetes (AKS), mas abstraindo toda a complexidade de gestão do cluster. Ele é desenhado para microsserviços, escalabilidade baseada em eventos (KEDA) e exposição HTTP/HTTPS simplificada.

> **Resumo em uma frase:** É como se o Kubernetes e o AWS Lambda tivessem um filho, focado em rodar microsserviços Docker sem que você precise gerenciar nós ou servidores.

## 📋 Índice

- [De-Para: AWS ECS vs. Azure Container Apps](#-de-para-aws-ecs-vs-azure-container-apps)
- [Arquitetura Básica](#-arquitetura-básica)
- [Principais Diferenciais](#-principais-diferenciais-por-que-usar)
- [Modelo de Custos](#-modelo-de-custos)
- [Limitações vs. ECS](#️-limitações-vs-ecs)
- [Exemplo Prático (Bicep)](#️-exemplo-de-bicep-infrastructure-as-code)
- [Links Úteis](#-links-úteis)

---

## 🔄 De-Para: AWS ECS vs. Azure Container Apps

Se você vem do ecossistema AWS ECS, utilize esta tabela para traduzir os conceitos rapidamente:

| Conceito AWS ECS | Conceito Azure Container Apps | Explicação Prática |
| :--- | :--- | :--- |
| **Cluster** | **Environment** | A "borda" de segurança e rede. Aplicativos no mesmo *Environment* compartilham a mesma VNET, Logs e podem se comunicar via DNS interno. |
| **Service** | **Container App** | O seu microsserviço individual (API, Site, Worker). É aqui que você define o Ingress (URL), Segredos e regras de escala. |
| **Task Definition** | **Revision** | A "receita" imutável da versão do seu app (Imagem + CPU + RAM + Vars de Ambiente). Mudou a receita? O Azure cria uma nova Revisão automaticamente. |
| **Task** | **Replica** | A instância viva rodando. Se escalar para 5, você tem 5 réplicas daquela revisão rodando. |
| **Application Load Balancer** | **Ingress (Gerenciado)** | O ACA já vem com um Ingress Controller (Envoy) embutido. Você não precisa provisionar e pagar por um Load Balancer separado. |
| **CloudWatch Alarms (Scaling)** | **KEDA (Nativo)** | O motor de escala. Diferente do ECS que foca em CPU/RAM, o ACA escala nativamente por **eventos** (Qtd. mensagens na fila, requisições HTTP simultâneas). |

---

## 🧩 Arquitetura Básica

### 1. Environment (O "Condomínio")
É o recurso pai. Você cria **um** Environment e coloca **vários** Container Apps (microsserviços) dentro dele.
* **Benefício:** Simplifica a rede. Apps no mesmo Environment chamam uns aos outros pelo nome: `http://minha-api`.
* **Custo:** No plano *Consumption*, você paga quase nada pelo Environment, apenas pelos Apps rodando.

### 2. Container App (A "Casa")
É onde sua aplicação vive. Ele gerencia o ciclo de vida e versões.
* Possui uma URL pública (se `external: true`) ou privada.
* Suporta divisão de tráfego (Ex: 80% para versão v1, 20% para versão v2).

### 3. Revision (O "Snapshot")
Toda vez que você muda uma imagem Docker ou uma variável de ambiente, o ACA cria uma **nova** Revisão.
* **Imutável:** Uma vez criada, não se edita. Serve para rollback instantâneo se a nova versão falhar.

---

## 🚀 Principais Diferenciais (Por que usar?)

### 1. Scale to Zero (Escala a Zero)
Esta é a maior diferença para o ECS tradicional.
* **No ECS:** Geralmente você mantém no mínimo 1 Task rodando (custo 24/7).
* **No ACA:** Se não houver requisições HTTP ou mensagens na fila, o ACA desliga **tudo** (0 réplicas). Você para de pagar CPU/Memória. Assim que chega uma requisição, ele "acorda" em segundos.

### 2. KEDA (Kubernetes Event-Driven Autoscaling)
Escalar baseado em CPU é coisa do passado para microsserviços. O ACA escala baseado no trabalho real:
* *Exemplo:* "Se tiver mais de 100 mensagens na fila do RabbitMQ, suba 10 réplicas."
* *Exemplo:* "Se tiver mais de 50 requisições HTTP simultâneas, suba mais uma réplica."

### 3. Dapr (Distributed Application Runtime)
Suporte nativo a "sidecars" do Dapr para facilitar a conexão com bancos de dados, filas e Pub/Sub sem precisar embutir SDKs pesados no código da aplicação.

---

## 💰 Modelo de Custos

### Consumption Plan (Padrão)
* **Environment:** ~$0 (apenas taxa mínima de infraestrutura)
* **Container Apps:** Paga apenas pelo que usa (CPU + Memória por segundo)
* **Scale to Zero:** Custo $0 quando não há tráfego
* **Exemplo:** App que roda 2h/dia = ~$5-15/mês vs ECS que custaria $30-50/mês

### Dedicated Plan
* **Workload Profiles:** Você reserva capacidade (como EC2 Reserved)
* **Melhor para:** Apps com tráfego constante 24/7
* **Custo:** Mais previsível, mas sem scale-to-zero

---

## ⚠️ Limitações vs. ECS

| Aspecto | Azure Container Apps | AWS ECS |
| :--- | :--- | :--- |
| **Controle do Cluster** | Zero (totalmente gerenciado) | Alto (você gerencia EC2/Fargate) |
| **Networking Avançado** | Limitado (VNET básica) | Completo (VPC, Security Groups) |
| **Persistent Storage** | Apenas Azure Files | EBS, EFS, FSx |
| **GPU Support** | Não disponível | Suporte completo |
| **Windows Containers** | Limitado | Suporte completo |
| **Compliance** | Menos certificações | Mais opções (GovCloud, etc.) |

**Quando usar ECS:** Aplicações enterprise com requisitos específicos de rede, storage ou compliance.
**Quando usar ACA:** Microsserviços modernos, APIs REST, aplicações event-driven.

---

## 🛠️ Exemplo de Bicep (Infrastructure as Code)

> **Nota:** Azure Container Apps usa Bicep/ARM, não YAML puro como Kubernetes.

Um manifesto simples de um app público que escala de 1 a 10 réplicas:

```bicep
// main.bicep
resource containerApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: 'minha-api-node'
  location: 'eastus'
  properties: {
    // Vínculo com o Environment
    managedEnvironmentId: containerAppEnv.id
    
    configuration: {
      ingress: {
        external: true          // Acessível pela internet
        targetPort: 3000        // Porta interna do container
        transport: 'auto'       // HTTP/HTTP2 automático
      }
      secrets: [
        {
          name: 'db-connection'
          value: 'Server=...;Database=...'
        }
      ]
    }
    
    template: {
      containers: [
        {
          name: 'app-container'
          image: 'meuacr.azurecr.io/minha-api:v1'
          resources: {
            cpu: json('0.5')      // 0.5 vCPU
            memory: '1Gi'         // 1GB RAM
          }
          env: [
            {
              name: 'DB_CONNECTION'
              secretRef: 'db-connection'
            }
          ]
        }
      ]
      scale: {
        minReplicas: 1            // Para produção (evita cold start)
        maxReplicas: 10
        rules: [
          {
            name: 'http-scaling'
            http: {
              metadata: {
                concurrentRequests: '50'  // Escala se > 50 req simultâneas
              }
            }
          }
        ]
      }
    }
  }
}

// Environment separado (reutilizável)
resource containerAppEnv 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: 'meu-env-prod'
  location: 'eastus'
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalytics.properties.customerId
        sharedKey: logAnalytics.listKeys().primarySharedKey
      }
    }
  }
}
```

### Deploy via Azure CLI:
```bash
# Criar Resource Group
az group create --name rg-exemplo --location eastus

# Deploy do Bicep
az deployment group create \
  --resource-group rg-exemplo \
  --template-file main.bicep

# Ver a URL pública
az containerapp show \
  --name minha-api-node \
  --resource-group rg-exemplo \
  --query properties.configuration.ingress.fqdn
```

---

## 🔗 Links Úteis

- [Documentação Oficial - Azure Container Apps](https://docs.microsoft.com/azure/container-apps/)
- [Pricing Calculator](https://azure.microsoft.com/pricing/calculator/)
- [Azure CLI - Container Apps](https://docs.microsoft.com/cli/azure/containerapp)
- [Bicep Templates](https://github.com/Azure/bicep)
- [KEDA Scalers](https://keda.sh/docs/scalers/)
- [Dapr Documentation](https://docs.dapr.io/)

---

## 👨‍💻 Sobre

Este guia foi criado como material de estudo sobre Azure Container Apps, focando na comparação com AWS ECS para facilitar a migração de conhecimento entre as plataformas.

**Contribuições são bem-vindas!** Se encontrar algum erro ou quiser adicionar conteúdo, fique à vontade para abrir uma issue ou pull request.

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.# azure-container-apps
