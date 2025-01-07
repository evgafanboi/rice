#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Available components
COMPONENTS=("kitty" "starship" "sway" "waybar" "alacritty")

# Function to print usage
print_usage() {
    echo -e "${BLUE}Usage: $0 [components...]${NC}"
    echo "Example: $0 kitty starship"
    echo "If no components specified, all will be installed"
}

# Function to print error and usage
print_error_usage() {
    echo -e "${RED}Error: $1${NC}"
    echo
    print_usage
    exit 1
}

# Function to check if a command exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}Error: $1 is not installed${NC}"
        return 1
    fi
}

# Function to install kitty configuration
install_kitty() {
    echo -e "${BLUE}Installing kitty configuration...${NC}"
    
    # Check dependencies
    check_command kitty || return 1
    
    # Create directory
    mkdir -p "$HOME/.config/kitty"
    
    # Copy configurations
    cp -r kitty/* "$HOME/.config/kitty/"
    
    echo -e "${GREEN}Kitty configuration installed${NC}"
}

install_alacritty() {
    echo -e "${BLUE}Installing alacritty.toml...${NC}"

    check_command alacritty || return 1

    mkdir -p "$HOME/.config/alacritty"

    cp -r alacritty/* "$HOME/.config/alacritty/"

    echo -e "${GREEN}Alacritty configuration installed${NC}"
}

# Function to install starship configuration
install_starship() {
    echo -e "${BLUE}Installing starship configuration...${NC}"
    
    # Check dependencies
    check_command starship || return 1
    
    # Copy configuration
    cp starship/starship.toml "$HOME/.config/starship.toml"
    
    echo -e "${GREEN}Starship configuration installed${NC}"
}

# Function to install sway configuration
install_sway() {
    echo -e "${BLUE}Installing sway configuration...${NC}"
    
    # Check dependencies
    check_command sway || return 1
    check_command swaybg || return 1
    
    # Create directories
    mkdir -p "$HOME/.config/sway"
    
    # Copy configurations
    cp sway/config "$HOME/.config/sway/"
    cp sway/colorscheme "$HOME/.config/sway/"
    cp sway/wallpaper.sh "$HOME/.config/sway/"
    chmod +x "$HOME/.config/sway/wallpaper.sh"
    
    echo -e "${GREEN}Sway configuration installed${NC}"
}

# Function to install waybar configuration
install_waybar() {
    echo -e "${BLUE}Installing waybar configuration...${NC}"
    
    # Check dependencies
    check_command waybar || return 1
    check_command playerctl || return 1
    
    # Create directories
    mkdir -p "$HOME/.config/waybar"
    
    # Copy configurations
    cp waybar/config.jsonc "$HOME/.config/waybar/"
    cp waybar/style.css "$HOME/.config/waybar/"
    cp waybar/power-menu.css "$HOME/.config/waybar/"
    cp waybar/playerctl.sh "$HOME/.config/waybar/"
    cp waybar/audio.py "$HOME/.config/waybar/"
    cp waybar/power-menu.sh "$HOME/.config/waybar/"
    
    # Make scripts executable
    chmod +x "$HOME/.config/waybar/"*.sh
    chmod +x "$HOME/.config/waybar/"*.py
    
    echo -e "${GREEN}Waybar configuration installed${NC}"
}

# Check if help is requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

# If no arguments provided, install all components
if [ $# -eq 0 ]; then
    components=("${COMPONENTS[@]}")
else
    components=("$@")
fi

# Validate requested components
for component in "${components[@]}"; do
    if [[ ! " ${COMPONENTS[@]} " =~ " ${component} " ]]; then
        print_error_usage "Invalid component '$component'"
    fi
done

# Show confirmation prompt
echo -e "${BLUE}The following configs will be installed:${NC}"

printf "  - %s\n" "${components[@]}"

echo -e "${BLUE}Run ./install.sh --help for custom components docs${NC}"

echo
read -p "Proceed with installation? [y/N] " -n 1 -r
echo    # New line after response

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}Installation cancelled${NC}"
    exit 1
fi

# Install requested components
for component in "${components[@]}"; do
    case $component in
        kitty)
            install_kitty
            ;;
        starship)
            install_starship
            ;;
        sway)
            install_sway
            ;;
        waybar)
            install_waybar
            ;;
	kitty)
	    install_alacritty
	    ;;
        *)
            print_error_usage "Unrecognized component '$component'"
            ;;
    esac
done

echo -e "${GREEN}Installation complete!${NC}"
