# Ambiente de Desenvolvimento Neovim com LazyVim no Docker

Este projeto oferece um ambiente de desenvolvimento **Neovim** completo e portátil, empacotado com **LazyVim** e suas configurações personalizadas (incluindo o explorador de arquivos **nvim-tree.lua**), tudo dentro de um contêiner **Docker**. Com ele, você terá seu editor preferido sempre pronto, sem se preocupar com as dependências do seu sistema operacional local.

-----

## Por Que Usar Este Setup?

  * **Portabilidade Extrema:** Seu ambiente de desenvolvimento é idêntico em qualquer máquina que tenha Docker, garantindo que "funciona na minha máquina" seja sempre verdade.
  * **Isolamento de Dependências:** Elimina conflitos de bibliotecas (como o famoso `GLIBC`), já que o Neovim e todos os seus plugins rodam em um ambiente isolado e controlado.
  * **Sistema Limpo:** Mantenha seu sistema operacional hospedeiro livre de instalações complexas do Neovim, Node.js, Python e outras ferramentas. Tudo fica contido no contêiner.
  * **Configuração Pré-Pronta:** Suas configurações de Neovim, LazyVim e plugins (como o `nvim-tree.lua`) já estão incluídas e serão instaladas automaticamente na construção da imagem.

-----

## Pré-requisitos

Para começar, você só precisa ter o Docker instalado na sua máquina:

  * **Docker:** Siga as instruções oficiais para instalar o Docker Desktop ou o Docker Engine: [docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)
  * **Nerd Font (Opcional, mas Recomendado):** Para desfrutar dos ícones bonitos no `nvim-tree.lua` e em outros plugins, instale uma [Nerd Font](https://www.nerdfonts.com/) no seu sistema operacional e configure seu terminal para usá-la.

-----

## Como Começar (Setup Rápido)

Siga estes passos simples para ter seu Neovim dockerizado funcionando em minutos:

### 1\. Clone Este Repositório

Comece clonando este repositório para sua máquina local. Ele contém o `Dockerfile` e as configurações essenciais.

```bash
git clone https://github.com/biojpferreira/neovim.git nvim-docker-env
cd nvim-docker-env
```
### 2\. Construa a Imagem Docker

Dentro da pasta `nvim-docker-env` que você acabou de clonar, execute o comando para construir a imagem Docker. Este processo pode levar alguns minutos, pois fará o download das dependências e instalará o Neovim com todos os plugins do LazyVim.

```bash
docker build -t meu-nvim-lazyvim .
```

  * `-t meu-nvim-lazyvim`: Atribui um nome (`tag`) à sua imagem. Você pode usar este nome para referenciá-la facilmente depois.
  * `.`: Indica que o `Dockerfile` está no diretório atual.

### 3\. Crie um Alias Conveniente

Para tornar a inicialização do Neovim no Docker tão simples quanto uma instalação local, crie um **alias** no seu shell.

1.  **Abra seu arquivo de configuração do shell:**

      * Para **Bash**: `nvim ~/.bashrc` (ou use seu editor de texto preferido)
      * Para **Zsh**: `nvim ~/.zshrc` (ou use seu editor de texto preferido)

2.  **Adicione a seguinte linha no final do arquivo:**

    ```bash
    alias docker-nvim='docker run -it --rm -v "$(pwd)":/app -w /app meu-nvim-lazyvim nvim'
    ```

      * Este alias executa o comando `docker run` que:
          * `--it --rm`: Inicia o contêiner de forma interativa e o remove automaticamente ao sair.
          * `-v "$(pwd)":/app`: Monta seu diretório de trabalho atual no diretório `/app` dentro do contêiner. Isso permite que o Neovim veja e edite seus arquivos locais.
          * `-w /app`: Define `/app` como o diretório de trabalho padrão dentro do contêiner.
          * `meu-nvim-lazyvim`: O nome da imagem Docker que você acabou de construir.
          * `nvim`: O comando para iniciar o Neovim dentro do contêiner.

3.  **Recarregue seu arquivo de configuração do shell:**
    Para que o alias funcione imediatamente, execute:

    ```bash
    source ~/.bashrc   # Se você editou .bashrc
    source ~/.zshrc    # Se você editou .zshrc
    ```

-----

## Como Usar Seu Neovim Dockerizado

Agora, usar o Neovim é tão simples quanto digitar um comando no terminal:

  * **Para abrir o Neovim no diretório atual:**

    ```bash
    docker-nvim
    ```

  * **Para abrir um arquivo específico (no diretório atual ou em um subdiretório):**

    ```bash
    docker-nvim meu_arquivo.txt
    docker-nvim src/main.rs
    ```

  * **Para abrir múltiplos arquivos:**

    ```bash
    docker-nvim arquivo1.md arquivo2.js
    ```

  * **Dentro do Neovim:**

      * Pressione `<leader>e` (que por padrão no LazyVim é `\e`) para alternar a visibilidade do explorador de arquivos (`nvim-tree.lua`).

-----

## Solução de Problemas Comuns

  * **Problemas de Versão (GLIBC, Neovim):** Este setup contorna esses problemas ao instalar uma versão recente do Neovim diretamente do GitHub e encapsular todas as dependências no Docker.
  * **Plugins Reinstalando a Cada Vez:** A imagem Docker já pré-instala todos os plugins do LazyVim durante sua construção, garantindo inicializações rápidas.
  * **Ícones Não Aparecem:** Verifique se você tem uma **Nerd Font instalada e configurada** no seu terminal local (não dentro do contêiner Docker).
  * **Configurações Não Aplicadas:** Certifique-se de que o `Dockerfile` está apontando para o seu repositório de configurações correto e que as customizações estão nas pastas esperadas (`lua/plugins/`, `lua/user/`, etc.).
