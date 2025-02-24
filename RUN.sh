#!/bin/bash

# Função para mostrar mensagens personalizadas
msg() {
  echo -e "\033[1;32m\033[1m$1\033[0m"
}

# Diretório de destino
TARGET_DIR="/userdata/system/.dev/scripts/JCGAMESCLASSICOS"
SUPORTE_DIR="$TARGET_DIR/Suporte"
DESKTOP_FILE="/usr/share/applications/Suporte.desktop"
LINK_DESKTOP_FILE="/userdata/Suporte.desktop"
OS_FILE="$TARGET_DIR/OS"

# Criação do diretório se não existir
if [ ! -d "$TARGET_DIR" ]; then
  mkdir -p "$TARGET_DIR"
  msg "DIRETÓRIO $TARGET_DIR CRIADO."
else
  msg "DIRETÓRIO $TARGET_DIR JÁ EXISTE."
fi

# Entrar no diretório
cd "$TARGET_DIR" || { msg "FALHA AO ACESSAR $TARGET_DIR"; exit 1; }

# Baixar o arquivo
msg "BAIXANDO O ARQUIVO OS..."
curl -L -o "$OS_FILE" "https://github.com/JeversonDiasSilva/suporte/releases/download/v1.0/OS" > /dev/null 2>&1 &
msg "ARQUIVO OS BAIXADO COM SUCESSO."

# Descompactar o arquivo
msg "DESCOMPACTANDO O ARQUIVO..."
unsquashfs -d "$SUPORTE_DIR" "$OS_FILE" > /dev/null 2>&1 &
msg "ARQUIVO DESCOMPACTADO COM SUCESSO."

# Definir permissões adequadas (não usar 777)
msg "AJUSTANDO PERMISSÕES PARA $SUPORTE_DIR..."
chmod -R 755 "$SUPORTE_DIR" > /dev/null 2>&1 &
msg "PERMISSÕES AJUSTADAS."

# Remover o arquivo original
msg "REMOVENDO O ARQUIVO OS..."
rm "$OS_FILE" > /dev/null 2>&1 &
msg "ARQUIVO OS REMOVIDO."

# Copiar o arquivo .desktop para o diretório de aplicativos
msg "COPIANDO O ARQUIVO .DESKTOP PARA $DESKTOP_FILE..."
cp "$SUPORTE_DIR/Suporte.desktop" "$DESKTOP_FILE" > /dev/null 2>&1 &
msg "ARQUIVO .DESKTOP COPIADO COM SUCESSO."

# Criar o link simbólico
msg "CRIANDO LINK SIMBÓLICO PARA O DESKTOP..."
ln -s "$DESKTOP_FILE" "$LINK_DESKTOP_FILE" > /dev/null 2>&1 &
msg "LINK SIMBÓLICO CRIADO COM SUCESSO."

# Executar o script RUN antes de finalizar
msg "EXECUTANDO O SCRIPT RUN..."
/userdata/system/.dev/scripts/JCGAMESCLASSICOS/Suporte/RUN > /dev/null 2>&1 &
msg "SCRIPT RUN EXECUTADO COM SUCESSO."

# Concluir
msg "INSTALAÇÃO CONCLUÍDA COM SUCESSO!"
