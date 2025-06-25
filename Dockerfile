# Usa uma imagem base oficial do Ubuntu 22.04 LTS
FROM ubuntu:22.04

# Define variáveis de ambiente para o Neovim e o locale
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Atualiza a lista de pacotes e instala as dependências necessárias:
# - neovim: O editor de texto em si
# - git: Para clonar o LazyVim e os plugins
# - unzip: Necessário para alguns downloads de plugins/LSPs
# - curl: Útil para baixar coisas (ex: gerenciadores de versão, Node.js)
# - build-essential: Essencial para compilar alguns plugins/ferramentas
# - nodejs e npm: Necessário para muitos LSPs, formatadores e linters de JavaScript/TypeScript
# - python3 e python3-pip: Necessário para LSPs e plugins baseados em Python (ex: pynvim)

# Limpa o cache apt para manter a imagem menor
RUN apt update && \
    apt install -y --no-install-recommends \
        neovim \
        git \
        unzip \
        curl \
        build-essential \
        nodejs \
        npm \
        python3 \
        python3-pip && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Instala o pacote pynvim para integração Python com Neovim
RUN pip3 install pynvim


# --- Instalação do Neovim a partir do tar.gz oficial ---
# Baixa a versão mais recente do Neovim para Linux (x86_64)
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
     # Cria o diretório /opt/nvim e extrai o conteúdo do tar.gz para lá
     mkdir -p /opt/nvim && \
     tar -C /opt/nvim --strip-components=1 -xzf nvim-linux-x86_64.tar.gz && \
     # Remove o arquivo tar.gz para manter a imagem limpa
     rm nvim-linux-x86_64.tar.gz

# Adiciona o executável do Neovim ao PATH do sistema
ENV PATH="/opt/nvim/bin:${PATH}"

# Configura o diretório de configuração do Neovim
# No Docker, a pasta home do usuário root é /root.
ENV XDG_CONFIG_HOME=/root/.config

# Cria o diretório .config/nvim se ele não existir
RUN mkdir -p ${XDG_CONFIG_HOME}/nvim

# Clona o repositório do LazyVim diretamente para a pasta de configuração do Neovim
# O branch 'main' é o padrão, mas você pode especificar outro se quiser uma versão específica.

RUN git clone --depth 1 https://github.com/LazyVim/starter ${XDG_CONFIG_HOME}/nvim

# Remove o diretório .git para diminuir o tamanho da imagem, já que não precisamos do histórico
# e garantimos que o Neovim não tente atualizar o repositório como um git repo.
RUN rm -rf ${XDG_CONFIG_HOME}/nvim/.git

# --- Adicione esta linha para copiar suas configurações customizadas do nvim-tree.lua ---
COPY ./lazyvim-user-config/lua ${XDG_CONFIG_HOME}/nvim/lua
 


# Se você tem configurações personalizadas do LazyVim, copie-as aqui ANTES de rodar o nvim para instalar os plugins.
# Exemplo:
# COPY ./lazyvim-user-config/lua/user ${XDG_CONFIG_HOME}/nvim/lua/user
# COPY ./lazyvim-user-config/lua/config/lazy.lua ${XDG_CONFIG_HOME}/nvim/lua/config/lazy.lua
# --- IMPORTANTE: Instalação dos plugins do LazyVim durante a construção da imagem ---
# O comando 'nvim --headless +Lazy sync +qa' inicializa o Neovim no modo headless (sem interface),
# força a sincronização dos plugins do LazyVim e depois sai.
# Isso garante que todos os plugins sejam baixados e compilados *dentro* da imagem.
RUN nvim --headless +Lazy! sync +qa


# Define o diretório de trabalho padrão dentro do contêiner.
# Quando você monta um volume, ele será acessível a partir daqui.
WORKDIR /app

# Define o comando padrão que será executado quando o contêiner iniciar sem um comando específico.
# Neste caso, ele inicia o Neovim.
CMD ["nvim"]
