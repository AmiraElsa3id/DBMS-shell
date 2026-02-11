# Shell-Based Database Management System

A lightweight, portable Database Management System implemented entirely in Bash shell scripts. This DBMS provides complete database and table operations without requiring any external database software.

## Features

### Database Operations
- Create databases
- List all databases  
- Connect to databases
- Drop databases

### Table Operations
- Create tables with custom columns
- Define primary keys
- Insert data with validation
- Update existing records
- Delete records
- Select and display data
- Drop tables
- List all tables

### Data Types Supported
- `int` - Integer values
- `string` - Text values
- `float` - Decimal numbers

### Data Integrity
- Primary key uniqueness enforcement
- Data type validation
- Input sanitization
- Field separator protection

## Project Structure

```
DBMS/
├── main.sh                 # Main entry point and menu system
├── config.sh               # Configuration settings and constants
├── helpers/                # Utility and validation functions
│   ├── utils.sh           # General utility functions
│   └── validation.sh      # Input validation functions
├── database/              # Database management scripts
│   ├── create_db.sh      # Create new databases
│   ├── list_db.sh        # List all databases
│   ├── connect_db.sh     # Connect to database and show table menu
│   └── drop_db.sh        # Delete databases
├── table/                 # Table operation scripts
│   ├── create_table.sh   # Create new tables
│   ├── list_tables.sh    # List tables in database
│   ├── drop_table.sh     # Delete tables
│   ├── insert.sh         # Insert data into tables
│   ├── update.sh         # Update existing records
│   ├── delete.sh         # Delete records
│   └── select.sh         # Select and display data
└── databases/            # Data storage directory (created automatically)
    ├── [database_name]/
    │   ├── [table].meta  # Table metadata (schema)
    │   └── [table].data  # Table data
```

## System Requirements

### Minimum Requirements
- **Operating System**: CentOS 9+ or any Unix-like system
- **Shell**: Bash 4.0+
- **Disk Space**: 10MB minimum
- **Memory**: 64MB minimum

### Software Dependencies
- `bash` - Bourne Again Shell (usually pre-installed)
- `coreutils` - Basic Unix utilities (ls, mkdir, etc.)
- `grep` - Pattern matching utility
- `cut` - Text processing utility
- `sed` - Stream editor utility

## Installation on CentOS 9+

### Step 1: Update System Packages
```bash
sudo dnf update -y
```

### Step 2: Install Required Packages
```bash
sudo dnf install -y bash coreutils grep sed
```

### Step 3: Verify Bash Installation
```bash
bash --version
# Should show bash version 4.0 or higher
```

### Step 4: Download or Clone the DBMS
```bash
# Option A: If you have the files locally, copy to desired location
cp -r /path/to/DBMS /opt/dbms

# Option B: If using git (if repository available)
git clone [repository-url] /opt/dbms
```

### Step 5: Set Proper Permissions
```bash
cd /opt/dbms

# Make all shell scripts executable
chmod +x main.sh
chmod +x database/*.sh
chmod +x table/*.sh
chmod +x helpers/*.sh
chmod +x config.sh

# Set ownership (optional, for security)
sudo chown -R $USER:$USER /opt/dbms
```

### Step 6: Create System-Wide Alias (Optional)
```bash
# Add to ~/.bashrc for easy access
echo 'alias dbms="/opt/dbms/main.sh"' >> ~/.bashrc
source ~/.bashrc
```

### Step 7: Test Installation
```bash
# Navigate to DBMS directory
cd /opt/dbms

# Run the application
./main.sh

# Or if you created the alias
dbms
```

## Quick Start Guide

### 1. Launch the DBMS
```bash
./main.sh
```

### 2. Create Your First Database
- Select option `1` (Create Database)
- Enter database name (e.g., `company_db`)
- Database will be created in `databases/company_db/`

### 3. Connect to Database
- Select option `3` (Connect to Database)
- Enter your database name (`company_db`)
- You'll see the table operations menu

### 4. Create a Table
- Select option `1` (Create Table)
- Enter table name (e.g., `employees`)
- Define columns with data types
- Set a primary key column

### 5. Insert Data
- Select option `4` (Insert into Table)
- Choose your table
- Enter values for each column

### 6. View Data
- Select option `5` (Select From Table)
- Choose your table to see all records

## Data Storage

### File Organization
- **Databases**: Stored as directories in `databases/`
- **Tables**: Each table has two files:
  - `.meta` - Contains schema definition (columns, types, primary key)
  - `.data` - Contains actual data rows

### Data Format
- **Field Separator**: `|` (pipe character)
- **Row Format**: `value1|value2|value3`
- **Metadata Format**: 
  ```
  VERSION:1.0
  PK:id
  name:string
  age:int
  salary:float
  ```

## Security Considerations

### Built-in Protections
- Input validation prevents SQL injection-like attacks
- Field separator validation prevents data corruption
- Name validation prevents directory traversal
- File permissions restrict unauthorized access

### Recommended Security Practices
- Run with appropriate user permissions
- Regular backups of the `databases/` directory
- Restrict file system access to authorized users
- Monitor system logs for unusual activity

## Advanced Usage

### Backup and Restore
```bash
# Backup entire DBMS
tar -czf dbms_backup_$(date +%Y%m%d).tar.gz /opt/dbms/

# Backup only data
tar -czf dbms_data_backup_$(date +%Y%m%d).tar.gz /opt/dbms/databases/

# Restore data
tar -xzf dbms_data_backup_20231201.tar.gz -C /opt/dbms/
```

### Performance Tips
- Keep tables under 10,000 rows for optimal performance
- Use appropriate data types to reduce file size
- Regular cleanup of deleted records
- Monitor disk space usage

## Troubleshooting

### Common Issues

#### Permission Denied
```bash
chmod +x main.sh database/*.sh table/*.sh helpers/*.sh
```

#### Command Not Found
```bash
# Ensure bash is in PATH
which bash
# Should return /bin/bash or similar

# Install missing packages
sudo dnf install -y bash coreutils grep sed
```

#### Database Not Found
- Check if database directory exists in `databases/`
- Verify database name spelling
- Ensure you're in the correct working directory

#### Table Operations Fail
- Verify table metadata file exists (`.meta`)
- Check data file permissions (`.data`)
- Ensure field separator isn't present in string values

### Debug Mode
Add debug output by modifying `main.sh`:
```bash
# Add at the top after sourcing files
set -x  # Enable debug mode
```

## Contributing

### Code Style
- Use 4 spaces for indentation
- Follow Bash best practices
- Add comments for complex logic
- Validate all user inputs

### Testing
- Test all database operations
- Verify data integrity
- Check error handling
- Test with various data types

## License

This project is open source. Feel free to modify and distribute according to your needs.

## Support

For issues and questions:
1. Check the troubleshooting section
2. Verify system requirements
3. Test with minimal data sets
4. Review log files for error messages

---

**Version**: 1.0  
**Last Updated**: 2024  
**Compatible**: CentOS 9+, RHEL 9+, Fedora 35+, Ubuntu 20.04+, Debian 11+
