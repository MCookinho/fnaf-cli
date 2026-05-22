# Save/Load system - Linux port of io.cmd

save_game() {
    mkdir -p "$DATA_DIR"
    cat > "$DATA_DIR/freddy" << EOF
[freddy]
level=${freddy_level:-1}
EOF
}

read_game() {
    local file_path="$1"
    local var_name="$2"
    if [[ -f "$file_path" ]]; then
        local value
        value=$(grep "^level=" "$file_path" | cut -d= -f2)
        eval "$var_name=$value"
    fi
}
