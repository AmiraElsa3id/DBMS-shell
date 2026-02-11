#!/bin/bash

# Connect to Database

connect_database() {
    print_header "CONNECT TO DATABASE"
    
    read -p "Enter database name: " db_name
    
    # Validate database name
    if ! validate_db_name "$db_name"; then
        echo "Error: Invalid database name."
        pause
        return
    fi
    
    # Check if database exists
    if ! db_exists "$db_name"; then
        echo "Error: Database '$db_name' does not exist."
        pause
        return
    fi
    
    # Database connected - show table menu
    table_menu "$db_name"
}

# Table Menu
table_menu() {
    local db_name="$1"
    
    while true; do
        clear
        print_header "DATABASE: $db_name - TABLE MENU"
        echo ""
        echo "1. Create Table"
        echo "2. List Tables"
        echo "3. Drop Table"
        echo "4. Insert into Table"
        echo "5. Select From Table"
        echo "6. Delete From Table"
        echo "7. Update Table"
        echo "8. Back to Main Menu"
        echo ""
        read -p "Enter your choice [1-8]: " choice
        
        case $choice in
            1)
                source "$SCRIPT_DIR/table/create_table.sh"
                create_table "$db_name"
                ;;
            2)
                source "$SCRIPT_DIR/table/list_tables.sh"
                list_tables "$db_name"
                ;;
            3)
                source "$SCRIPT_DIR/table/drop_table.sh"
                drop_table "$db_name"
                ;;
            4)
                source "$SCRIPT_DIR/table/insert.sh"
                insert_into_table "$db_name"
                ;;
            5)
                source "$SCRIPT_DIR/table/select.sh"
                select_from_table "$db_name"
                ;;
            6)
                source "$SCRIPT_DIR/table/delete.sh"
                delete_from_table "$db_name"
                ;;
            7)
                source "$SCRIPT_DIR/table/update.sh"
                update_table "$db_name"
                ;;
            8)
                return
                ;;
            *)
                echo ""
                echo "Error: Invalid choice. Please enter 1-8."
                pause
                ;;
        esac
    done
}