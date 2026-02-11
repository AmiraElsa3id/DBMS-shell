#!/bin/bash

# Insert into Table

insert_into_table() {
    local db_name="$1"
    
    print_header "INSERT INTO TABLE"
    
    read -p "Enter table name: " table_name
    
    # Check if table exists
    if ! table_exists "$db_name" "$table_name"; then
        echo "Error: Table '$table_name' does not exist."
        pause
        return
    fi
    
    # Read metadata
    meta_file="$DB_ROOT/$db_name/${table_name}.meta"
    data_file="$DB_ROOT/$db_name/${table_name}.data"
    
    # Read primary key
    pk_column=$(head -n 1 "$meta_file" | cut -d: -f2)
    
    # Read column names and types
    col_names=()
    col_types=()
    
    while IFS=: read -r col_name col_type; do
        if [[ "$col_name" != "PK" ]]; then
            col_names+=("$col_name")
            col_types+=("$col_type")
        fi
    done < "$meta_file"
    
    # Get values for each column
    values=()
    pk_value=""
    
    for ((i=0; i<${#col_names[@]}; i++)); do
        while true; do
            read -p "Enter value for ${col_names[$i]} (${col_types[$i]}): " value
            
            # Validate value against data type
            if validate_value "$value" "${col_types[$i]}"; then
                # Check if this is primary key column
                if [[ "${col_names[$i]}" == "$pk_column" ]]; then
                    # Check for duplicate primary key
                    pk_value="$value"
                    pk_index=$i
                    
                    if [[ -f "$data_file" ]] && grep -q "^[^${FIELD_SEPARATOR}]*${FIELD_SEPARATOR}.*${value}" "$data_file" 2>/dev/null; then
                        # More precise check
                        duplicate=false
                        while IFS="$FIELD_SEPARATOR" read -r -a row; do
                            if [[ "${row[$pk_index]}" == "$value" ]]; then
                                duplicate=true
                                break
                            fi
                        done < "$data_file"
                        
                        if [[ "$duplicate" == true ]]; then
                            echo "Error: Primary key value '$value' already exists."
                            continue
                        fi
                    fi
                fi
                
                values+=("$value")
                break
            else
                echo "Error: Invalid value for type ${col_types[$i]}."
            fi
        done
    done
    
    # Insert row into data file
    row=$(IFS="$FIELD_SEPARATOR"; echo "${values[*]}")
    echo "$row" >> "$data_file"
    
    echo ""
    echo "Success: Row inserted successfully."
    pause
}