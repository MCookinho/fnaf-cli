# FNaF - CLI Edition (Linux)

Five Nights at Freddy's recreated in the terminal for Linux.

Port of [fnaf-terminal](https://github.com/136MasterNR/fnaf-terminal) (Batch/Windows) to Bash/Linux.

## Requirements

- **mpg123** - MP3 audio playback
- Terminal with ANSI true color support (24-bit)

### Installing mpg123

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

## How to play

```bash
git clone https://github.com/MCookinho/fnaf-cli.git
cd fnaf-cli
./fnaf-cli
```

Recommended: terminal with at least 185x52 characters, monospace font.

## Controls

### Title screen
- **W**/**1**/**N**: Select "New Game"
- **S**/**2**/**C**: Select "Continue"
- **A**/**Space**/**Enter**: Start the night
- **`** or **~**: Custom Night mode

### During gameplay
- **Q**: Close/Open left door
- **A**: Left light
- **E**: Close/Open right door
- **D**: Right light
- **Space**: Open cameras
  - **0-9**: Select camera
  - **-**: Camera 11
- **Tab**: Mute voice call
- **H**: Honk Freddy's nose
- **CTRL+W**: Instant win

## Credits

- **Original (Windows/Batch)**: [136MasterNR/fnaf-terminal](https://github.com/136MasterNR/fnaf-terminal)
- **Office remake**: [reddit.com/r/fivenightsatfreddys](https://www.reddit.com/r/fivenightsatfreddys/comments/gqd36m/fnaf1_office_remake/)
- **Five Nights At Freddy's**: Scott Cawthon

Not affiliated with or endorsed by Scott Cawthon.
