# README for Database Backup Script

## Description

This script is designed to create a backup of a PostgreSQL database, compress it, and transfer it to a remote server. It also automatically removes old backups, keeping only the three most recent ones.

## Requirements

- PostgreSQL (`pg_dump`)
- `gzip`
- `scp`
- `ls`
- `grep`
- `awk`
- `xargs`

All the listed utilities must be installed on your server.

## Configuration

1. **Edit the configuration parameters in the script:**
   - `DB_NAME`: The name of the database to back up.
   - `DB_USER`: The database user name.
   - `DB_PASS`: The password for the database user.
   - `BACKUP_DIR`: The path to the directory where local backups will be stored.
   - `REMOTE_SERVER`: The path to the remote server where the backup will be copied.

2. **Make the script executable:**
   ```bash
   chmod +x /path/to/script.sh
   ```

## Usage

Run the script with the following command:

```bash
/path/to/script.sh
```

The script performs the following steps:

1. **Create Backup**: Uses `pg_dump` to create a database backup and compresses it with `gzip`.
2. **Copy Backup to Remote Server**: Transfers the backup file to the specified remote server using `scp`.
3. **Remove Local Backup**: Deletes the local backup file after successful transfer.
4. **Remove Old Backups**: Deletes old backups from the local directory, keeping only the three most recent ones.

## Error Handling

The script checks for the presence of required commands and the success of each step. If any command is missing or if an error occurs at any stage, the script will terminate with an appropriate error message.

## Security

The database password is passed via the `PGPASSWORD` environment variable, which is cleared after the script finishes. Ensure that the script's execution permissions are restricted to prevent unauthorized access to the password.

## Notes

- Ensure you have permissions for the specified directories and remote server.
- Verify that the path to the remote server is correct and that you have SSH access.

If you have any questions or encounter issues, please contact your system or database administrator.
