#!/bin/bash

# Main entry point for the DBMS

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source configuration and helper files
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/helpers/validation.sh"
source "$SCRIPT_DIR/helpers/utils.sh"

# Initialize databases directory
initialize_system() {
    if [[ ! -d "$DB_ROOT" ]]; then
        mkdir -p "$DB_ROOT"
    fi
}

# Main Menu
main_menu() {
    while true; do
        clear
        print_header "DATABASE MANAGEMENT SYSTEM"
        echo ""
        echo "1. Create Database"
        echo "2. List Databases"
        echo "3. Connect to Database"
        echo "4. Drop Database"
        echo "5. Exit"
        echo ""
        read -p "Enter your choice [1-5]: " choice
        
        case $choice in
            1)
                source "$SCRIPT_DIR/database/create_db.sh"
                create_database
                ;;
            2)
                source "$SCRIPT_DIR/database/list_db.sh"
                list_databases
                ;;
            3)
                source "$SCRIPT_DIR/database/connect_db.sh"
                connect_database
                ;;
            4)
                source "$SCRIPT_DIR/database/drop_db.sh"
                drop_database
                ;;
            5)
                echo ""
                echo "Thank you for using DBMS. Goodbye!"
                exit 0
                ;;
            *)
                echo ""
                echo "Error: Invalid choice. Please enter 1-5."
                pause
                ;;
        esac
    done
}

# Initialize and run
initialize_system
main_menu