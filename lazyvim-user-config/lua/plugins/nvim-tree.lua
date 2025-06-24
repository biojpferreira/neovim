-- lazyvim-user-config/lua/plugins/nvim-tree.lua
return {
   "nvim-tree/nvim-tree.lua",
   dependencies = {
       "nvim-tree/nvim-web-devicons", -- Para ícones bonitos nos arquivos
   },
   opts = {
       -- Configurações que sobrescrevem ou adicionam às padrão do LazyVim
       hijack_netrw = true, -- Garante que o nvim-tree.lua assuma o controle sobre o Netrw
       open_on_setup = false, -- Não abre a árvore automaticamente ao iniciar o Neovim
       auto_reload_on_write = true, -- Recarrega a árvore automaticamente ao salvar alterações
       view = {
          width = 30, -- Largura da janela da árvore
          relativenumber = false, -- Não mostra números de linha relativos na árvore
       },
       renderer = {
          group_empty = true, -- Agrupa diretórios vazios
          full_name = true, -- Mostra o caminho completo do arquivo no cabeçalho
          root_folder_label = ":t_directory", -- Label customizado para a pasta raiz
          icons = {
              git_placement = "before", -- Coloca ícones do Git antes do nome do arquivo
              modified_placement = "after", -- Coloca ícones de modificação depois do nome
              padding = " ",
              symlink_arrow = "➜",
              show = {
                   file = true,
                   folder = true,
                   folder_arrow = true,
                   git = true,
                   modified = true
               },
               webdev_colors = true, -- Usa cores dos ícones webdev
            },
          },
         filters = {
              dotfiles = true, -- Esconde arquivos que começam com '.'
              git_ignored = true, -- Esconde arquivos ignorados pelo Git
              exclude = { "node_modules", ".git" }, -- Lista de pastas para excluir
          },
    },
keys = {
    -- Mapeamento de teclas (você pode sobrescrever o padrão do LazyVim aqui)
    { "\\","<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
    -- Adicione outros mapeamentos se quiser, por exemplo, para focar na árvore
    -- { "<leader>nf", "<cmd>NvimTreeFocus<cr>", desc = "Focus NvimTree" },
    },
}
