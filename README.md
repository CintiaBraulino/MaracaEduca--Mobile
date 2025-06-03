
# 📱 **App Mobile: Mapeamento de Escolas Públicas de Maracanaú**

## 🌟 Visão Geral do Projeto

Bem-vindo ao **Sistema de Mapeamento de Escolas Públicas de Maracanaú**\! Este aplicativo, desenvolvido em Flutter, é a interface móvel principal para que usuários (cidadãos, pais, alunos, gestores) possam acessar informações detalhadas sobre as escolas públicas do município de Maracanaú, Ceará.

Nosso objetivo é proporcionar uma **experiência móvel fluida, intuitiva e rica em recursos**, permitindo que os usuários:

  * Localizem escolas facilmente no mapa.
  * Acessem dados detalhados de cada instituição.
  * Forneçam feedback valioso sobre as escolas.
  * Tenham acesso a relatórios e análises de dados educacionais.

Este aplicativo se integra diretamente com o conjunto de **microsserviços do backend** para garantir dados atualizados e funcionalidades robustas.

-----

## ✨ Funcionalidades em Destaque

O aplicativo móvel será desenvolvido com as seguintes funcionalidades chave:

  * **Geolocalização e Mapa Interativo:** Exibição das escolas no mapa, permitindo zoom, pan e interação com marcadores para obter detalhes.
  * **Autenticação de Usuários:** Login e registro seguro para diferentes perfis de usuário (via JWT).
  * **Detalhes das Escolas:** Visualização de informações completas sobre cada escola (endereço, contato, infraestrutura, etc. – CRUD de dados).
  * **Funcionalidade de Busca:** Filtro e busca de escolas por nome, bairro ou outros critérios.
  * **Relatórios e Análises:** Acesso a gráficos e dados analíticos resumidos sobre as escolas (via Serviço de Relatórios).
  * **Envio de Feedback:** Um canal para os usuários enviarem comentários, sugestões ou relatar problemas sobre as escolas.
  * **Design Responsivo e Adaptativo:** Interface otimizada para diferentes tamanhos de tela de smartphones e tablets.

-----

## 🛠️ Tecnologias Utilizadas

Este aplicativo está sendo construído com as seguintes tecnologias e integrações:

  * **Flutter:** Framework UI para construção nativa de aplicativos para mobile (iOS e Android) a partir de uma única base de código.
  * **Dart:** Linguagem de programação utilizada pelo Flutter.
  * **Estado do Aplicativo:** 
  * **Requisições HTTP:** 
  * **Integração de Mapa:** 
  * **Autenticação:** 

-----


## 🚀 Começando (Setup Local)

Siga estes passos para configurar e executar o aplicativo em seu ambiente de desenvolvimento.

### Pré-requisitos

  * **Flutter SDK**: [Versão recomendada, ex: 3.x.x ou superior]. Siga a documentação oficial do Flutter para instalação: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
  * **Editor de Código**: Visual Studio Code com a extensão Flutter, ou Android Studio/IntelliJ IDEA com os plugins Dart e Flutter.
  * **Dispositivo/Emulador**: Um emulador Android ou iOS configurado, ou um dispositivo físico.
  * **Backend Rodando**: Certifique-se de que os microsserviços do seu backend estejam rodando e acessíveis.

### Instalação

1.  **Clone o repositório** do aplicativo Flutter:

    ```bash
    git clone https://github.com/CintiaBraulino/MaracaEduca--Mobile/
    ```

2.  **Navegue** até o diretório do projeto:

    ```bash
    cd MaracaEduca--Mobile
    ```

3.  **Instale as dependências** do projeto:

    ```bash
    flutter pub get
    ```

### Configuração do Ambiente

  * **Variáveis de Ambiente:** Pode ser necessário configurar variáveis de ambiente (ex: `API_BASE_URL` para seus microsserviços, chaves de API para Google Maps) em um arquivo `.env` ou similar.
      * Exemplo de `lib/config/app_config.dart` (ou similar):
        ```dart
        class AppConfig {
          static const String baseUrlAuth = 'http://10.0.2.2:8080/api/auth'; // Android Emulator localhost
          static const String baseUrlSchools = 'http://10.0.2.2:3000/api/schools';
          static const String googleMapsApiKey = 'SUA_CHAVE_AQUI'; // Se usar Google Maps
        }
        ```

### Rodando o Aplicativo

1.  Certifique-se de que um emulador/simulador esteja rodando ou um dispositivo físico esteja conectado.

2.  Execute o aplicativo:

    ```bash
    flutter run
    ```

    Ou selecione o dispositivo/emulador no seu IDE e clique em "Run".

-----

## 💡 Estrutura de Projeto (Sugestão)

Para um projeto Flutter de médio a grande porte, uma estrutura bem organizada é fundamental. Considere algo como:

```
lib/
├── api/             
│   ├── auth_api.dart
│   ├── school_api.dart
│   └── ...
├── auth/           
│   ├── auth_repository.dart
│   ├── auth_provider.dart (se usar Provider/Riverpod)
│   ├── login_screen.dart
│   └── signup_screen.dart
├── config/         
│   └── app_config.dart
├── data/          
│   ├── models/      
│   └── repositories/
│       ├── school_repository.dart
│       └── user_repository.dart
├── features/       
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── home_viewmodel.dart (ou bloc/cubit)
│   ├── map/
│   │   ├── map_screen.dart
│   │   └── map_controller.dart
│   ├── schools/
│   │   ├── school_detail_screen.dart
│   │   └── school_list_screen.dart
│   ├── reports/
│   └── feedback/
├── services/        
│   ├── geolocation_service.dart
│   └── notification_service.dart
├── shared/          
│   ├── widgets/
│   ├── utils/
│   └── themes/
├── main.dart       
├── routes.dart      
└── app_constants.dart
```

-----

## 👨‍💻 Nossa DEMO

<div align="center">
 ![Frame 35](https://github.com/user-attachments/assets/ab3dfcea-07f5-4383-9f95-de9f09fb0642)
 
 ![Frame 36](https://github.com/user-attachments/assets/79cc81f3-58a8-4f80-aeb8-0fbdafbb4738)
 
 ![Frame 37](https://github.com/user-attachments/assets/450b810d-b7b9-45c1-81de-1dcf5b0aae76)
</div>

-----

## 📄 Licença

Este projeto está licenciado sob a [Nome da Licença, ex: MIT License]. Consulte o arquivo `LICENSE` na raiz do repositório para mais detalhes.

-----

## ✉️ Contato

Para dúvidas, sugestões ou suporte, sinta-se à vontade para abrir uma issue neste repositório.

