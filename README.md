# FNaF - CLI Edition (Linux)

Five Nights at Freddy's recriado no terminal para Linux.

Port do [fnaf-terminal](https://github.com/136MasterNR/fnaf-terminal) (Batch/Windows) para Bash/Linux.

## Requisitos

- **mpg123** - reprodução de áudio MP3
- Terminal com suporte a ANSI true color (24-bit)

### Instalação do mpg123

```bash
# Arch Linux
sudo pacman -S mpg123

# Debian/Ubuntu
sudo apt install mpg123

# Fedora
sudo dnf install mpg123

# openSUSE
sudo zypper install mpg123

# Gentoo
sudo emerge media-sound/mpg123
```

## Como jogar

```bash
git clone https://github.com/peuborges/fnaf-cli.git
cd fnaf-cli
./fnaf-cli
```

Recomendado: terminal com no mínimo 185x52 caracteres, fonte monoespaçada.

## Controles

### Tela de título
- **W**/**1**/**N**: Selecionar "New Game"
- **S**/**2**/**C**: Selecionar "Continue"
- **A**/**Espaço**/**Enter**: Iniciar a noite
- **`** ou **~**: Modo Custom Night

### Durante o jogo
- **Q**: Fechar/Abrir porta esquerda
- **A**: Luz esquerda
- **E**: Fechar/Abrir porta direita
- **D**: Luz direita
- **Espaço**: Abrir câmeras
  - **0-9**: Selecionar câmera
  - **-**: Câmera 11
- **Tab**: Mutar voice call
- **H**: Buzinar o nariz do Freddy
- **CTRL+W**: Vitória instantânea

## Créditos

- **Original (Windows/Batch)**: [136MasterNR/fnaf-terminal](https://github.com/136MasterNR/fnaf-terminal)
- **Office remake**: [reddit.com/r/fivenightsatfreddys](https://www.reddit.com/r/fivenightsatfreddys/comments/gqd36m/fnaf1_office_remake/)
- **Five Nights At Freddy's**: Scott Cawthon

Não afiliado ou endossado por Scott Cawthon.
