#!/bin/bash

# Diretório de destino
TARGET_DIR="/userdata/system/.dev/scripts/JCGAMESCLASSICOS"
SUPORTE_DIR="$TARGET_DIR/Suporte"
DESKTOP_FILE="/usr/share/applications/Suporte.desktop"
LINK_DESKTOP_FILE="/userdata/Suporte.desktop"
OS_FILE="$TARGET_DIR/OS"

# Adicionar o repositório Flathub e instalar o RustDesk via Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install flathub com.rustdesk.RustDesk -y

# Criação do diretório se não existir
if [ ! -d "$TARGET_DIR" ]; then
  mkdir -p "$TARGET_DIR"
  echo "Diretório $TARGET_DIR criado."
else
  echo "Diretório $TARGET_DIR já existe."
fi

# Entrar no diretório
cd "$TARGET_DIR" || { echo "Falha ao acessar $TARGET_DIR"; exit 1; }

# Baixar o arquivo
echo "Baixando o arquivo OS..."
curl -L -o "$OS_FILE" "https://github.com/JeversonDiasSilva/suporte/releases/download/v1.0/OS"
if [ $? -ne 0 ]; then
  echo "Erro ao baixar o arquivo OS."
  exit 1
fi
echo "Arquivo OS baixado com sucesso."

# Descompactar o arquivo
echo "Descompactando o arquivo..."
unsquashfs -d "$SUPORTE_DIR" "$OS_FILE"
if [ $? -ne 0 ]; then
  echo "Erro ao descompactar o arquivo OS."
  exit 1
fi
echo "Arquivo descompactado com sucesso."

# Definir permissões adequadas
chmod -R 755 "$SUPORTE_DIR"
echo "Permissões ajustadas para $SUPORTE_DIR."

# Remover o arquivo original
rm "$OS_FILE"
echo "Arquivo OS removido."

# Copiar o arquivo .desktop para o diretório de aplicativos
echo "Copiando o arquivo .desktop para $DESKTOP_FILE..."
cp "$SUPORTE_DIR/Suporte.desktop" "$DESKTOP_FILE"
if [ $? -ne 0 ]; then
  echo "Erro ao copiar o arquivo .desktop."
  exit 1
fi
echo "Arquivo .desktop copiado com sucesso."

# Criar o link simbólico
echo "Criando link simbólico para o desktop..."
ln -s "$DESKTOP_FILE" "$LINK_DESKTOP_FILE"
if [ $? -ne 0 ]; then
  echo "Erro ao criar o link simbólico."
  exit 1
fi
echo "Link simbólico criado com sucesso."

# Definir a senha permanente no RustDesk para "Batocera2025"
echo "Configurando a senha permanente no RustDesk..."
# Esse comando depende de como o RustDesk armazena suas configurações.
# Uma abordagem pode ser editar diretamente o arquivo de configuração, se existir:
echo "password=Batocera2025" > /userdata/system/.dev/scripts/JCGAMESCLASSICOS/Suporte/config_file.conf
# Ou, se for necessário usar um comando específico para definir a senha, insira-o aqui, por exemplo:
# flatpak run com.rustdesk.RustDesk --set-password Batocera2025

batocera-save-overlay

pkill xterm
