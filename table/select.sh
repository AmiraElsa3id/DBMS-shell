#!/bin/bash

# Select From Table with Conditional Filtering

select_from_table() {
    local db_name="$1"
    
    print_header "SELECT FROM TABLE"
    
    read -p "Enter table name: " table_name
    
    # Check if table exists
    if ! table_exists "$db_name" "$table_name"; then
        print_error "Error: Table '$table_name' does not exist."
        pause
        return
    fi
    
    # Read metadata
    meta_file="$DB_ROOT/$db_name/${table_name}.meta"
    data_file="$DB_ROOT/$db_name/${table_name}.data"
    
    # Read column names and types
    col_names=()
    col_types=()
    while IFS=: read -r col_name col_type; do
        if [[ "$col_name" != "PK" ]]; then
            col_names+=("$col_name")
            col_types+=("$col_type")
        fi
    done < "$meta_file"
    
    echo ""
    print_info "Table: $table_name"
    echo ""
    
    # Show available columns
    echo "Available columns:"
    for ((i=0; i<${#col_names[@]}; i++)); do
        echo "  - ${col_names[$i]} (${col_types[$i]})"
    done
    echo ""
    
    # Ask if user wants to filter
    read -p "Do you want to add conditions? (y/n): " add_conditions
    
    local conditions=()
    
    if [[ "$add_conditions" =~ ^[Yy]$ ]]; then
        while true; do
            echo ""
            print_info "Add Condition:"
            
            # Select column
            read -p "Enter column name: " condition_col
            
            # Validate column exists
            local col_index=-1
            for ((i=0; i<${#col_names[@]}; i++)); do
                if [[ "${col_names[$i]}" == "$condition_col" ]]; then
                    col_index=$i
                    break
                fi
            done
            
            if [[ $col_index -eq -1 ]]; then
                print_error "Error: Column '$condition_col' not found."
                continue
            fi
            
            # Select operator
            echo "Available operators: =, !=, >, <, >=, <=, LIKE"
            read -p "Enter operator: " operator
            
            # Validate operator
            case "$operator" in
                "="|"!="|">"|"<"|">="|"<="|"LIKE") ;;
                *)
                    print_error "Error: Invalid operator '$operator'."
                    continue
                    ;;
            esac
            
            # Enter value
            read -p "Enter value: " condition_value
            
            # Store condition
            conditions+=("$col_index:$operator:$condition_value")
            
            # Ask for more conditions
            read -p "Add another condition? (y/n): " more_conditions
            if [[ ! "$more_conditions" =~ ^[Yy]$ ]]; then
                break
            fi
        done
    fi
    
    echo ""
    print_header "QUERY RESULTS"
    echo ""
    
    # Print header
    for col_name in "${col_names[@]}"; do
        printf "${CYAN}%-15s${NC}" "$col_name"
    done
    echo ""
    
    # Print separator line
    for ((i=0; i<${#col_names[@]}; i++)); do
        printf "${GRAY}%-15s${NC}" "---------------"
    done
    echo ""
    
    # Print data rows with filtering
    local row_count=0
    if [[ -f "$data_file" ]] && [[ -s "$data_file" ]]; then
        while IFS="$FIELD_SEPARATOR" read -r -a values; do
            local include_row=true
            
            # Check all conditions
            for condition in "${conditions[@]}"; do
                IFS=: read -r col_idx operator cond_value <<< "$condition"
                local actual_value="${values[$col_idx]}"
                local col_type="${col_types[$col_idx]}"
                
                # Apply condition based on operator
                case "$operator" in
                    "=")
                        if [[ "$actual_value" != "$cond_value" ]]; then
                            include_row=false
                            break
                        fi
                        ;;
                    "!=")
                        if [[ "$actual_value" == "$cond_value" ]]; then
                            include_row=false
                            break
                        fi
                        ;;
                    ">")
                        # Handle numeric and date comparison
                        if [[ "$col_type" == "int" || "$col_type" == "float" ]]; then
                            if [[ "$actual_value" -le "$cond_value" ]] 2>/dev/null; then
                                include_row=false
                                break
                            fi
                        elif [[ "$col_type" == "date" ]]; then
                            # Date comparison (YYYY-MM-DD format) - use string comparison
                            if [[ "$actual_value" < "$cond_value" || "$actual_value" == "$cond_value" ]]; then
                                include_row=false
                                break
                            fi
                        else
                            # String comparison for other types
                            if [[ "$actual_value" < "$cond_value" || "$actual_value" == "$cond_value" ]]; then
                                include_row=false
                                break
                            fi
                        fi
                        ;;
                    "<")
                        # Handle numeric and date comparison
                        if [[ "$col_type" == "int" || "$col_type" == "float" ]]; then
                            if [[ "$actual_value" -ge "$cond_value" ]] 2>/dev/null; then
                                include_row=false
                                break
                            fi
                        elif [[ "$col_type" == "date" ]]; then
                            # Date comparison (YYYY-MM-DD format) - use string comparison
                            if [[ "$actual_value" > "$cond_value" || "$actual_value" == "$cond_value" ]]; then
                                include_row=false
                                break
                            fi
                        else
                            # String comparison for other types
                            if [[ "$actual_value" > "$cond_value" || "$actual_value" == "$cond_value" ]]; then
                                include_row=false
                                break
                            fi
                        fi
                        ;;
                    ">=")
                        # Handle numeric and date comparison
                        if [[ "$col_type" == "int" || "$col_type" == "float" ]]; then
                            if [[ "$actual_value" -lt "$cond_value" ]] 2>/dev/null; then
                                include_row=false
                                break
                            fi
                        elif [[ "$col_type" == "date" ]]; then
                            # Date comparison (YYYY-MM-DD format) - use string comparison
                            if [[ "$actual_value" < "$cond_value" ]]; then
                                include_row=false
                                break
                            fi
                        else
                            # String comparison for other types
                            if [[ "$actual_value" < "$cond_value" ]]; then
                                include_row=false
                                break
                            fi
                        fi
                        ;;
                    "<=")
                        # Handle numeric and date comparison
                        if [[ "$col_type" == "int" || "$col_type" == "float" ]]; then
                            if [[ "$actual_value" -gt "$cond_value" ]] 2>/dev/null; then
                                include_row=false
                                break
                            fi
                        elif [[ "$col_type" == "date" ]]; then
                            # Date comparison (YYYY-MM-DD format) - use string comparison
                            if [[ "$actual_value" > "$cond_value" ]]; then
                                include_row=false
                                break
                            fi
                        else
                            # String comparison for other types
                            if [[ "$actual_value" > "$cond_value" ]]; then
                                include_row=false
                                break
                            fi
                        fi
                        ;;
                    "LIKE")
                        if [[ ! "$actual_value" == *"$cond_value"* ]]; then
                            include_row=false
                            break
                        fi
                        ;;
                esac
            done
            
            # Print row if it meets all conditions
            if [[ "$include_row" == true ]]; then
                for value in "${values[@]}"; do
                    printf "${WHITE}%-15s${NC}" "$value"
                done
                echo ""
                ((row_count++))
            fi
        done < "$data_file"
        
        if [[ $row_count -eq 0 ]]; then
            print_warning "No records found matching the conditions."
        else
            echo ""
            print_success "Found $row_count record(s)."
        fi
    else
        print_warning "No data found in table."
    fi
    
    echo ""
    pause
}