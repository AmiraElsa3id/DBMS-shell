#!/bin/bash

# Validation functions

# Validate database name (alphanumeric and underscore only)
validate_db_name() {
    local name="$1"
    if [[ -z "$name" ]] || [[ ! "$name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        return 1
    fi
    return 0
}

# Validate table name
validate_table_name() {
    local name="$1"
    if [[ -z "$name" ]] || [[ ! "$name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        return 1
    fi
    return 0
}

# Validate column name
validate_column_name() {
    local name="$1"
    if [[ -z "$name" ]] || [[ ! "$name" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        return 1
    fi
    return 0
}

# Validate data type
validate_datatype() {
    local dtype="$1"
    for supported in "${SUPPORTED_TYPES[@]}"; do
        if [[ "$dtype" == "$supported" ]]; then
            return 0
        fi
    done
    return 1
}

# Validate value against data type
validate_value() {
    local value="$1"
    local dtype="$2"
    
    case "$dtype" in
        int)
            [[ "$value" =~ ^-?[0-9]+$ ]] && return 0 || return 1
            ;;
        float)
            [[ "$value" =~ ^-?[0-9]*\.?[0-9]+$ ]] && return 0 || return 1
            ;;
        string)
            # Check for field separator in string
            [[ "$value" != *"$FIELD_SEPARATOR"* ]] && return 0 || return 1
            ;;
        *)
            return 1
            ;;
    esac
}

# Check if database exists
db_exists() {
    local db_name="$1"
    [[ -d "$DB_ROOT/$db_name" ]]
}

# Check if table exists
table_exists() {
    local db_name="$1"
    local table_name="$2"
    [[ -f "$DB_ROOT/$db_name/${table_name}.meta" ]]
}