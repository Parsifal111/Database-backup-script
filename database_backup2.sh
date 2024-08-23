#!/bin/bash

# Настройки
DB_NAME="база_данных"
DB_USER="пользователь"
DB_PASS="ваш_пароль"  # Добавлен пароль
BACKUP_DIR="/путь/к/директории/бэкапов"
REMOTE_SERVER="пользователь@удаленный_сервер:/путь/к/удаленной/директории"
DATE=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_backup_${DATE}.sql.gz"

# Проверка наличия необходимых команд
for cmd in pg_dump gzip scp ls grep awk xargs; do
  if ! command -v $cmd &> /dev/null; then
    echo "Команда $cmd не найдена. Установите её и повторите попытку."
    exit 1
  fi
done

# Создание бэкапа
echo "Создание бэкапа базы данных ${DB_NAME}..."
export PGPASSWORD="${DB_PASS}"  # Установка пароля для подключения к базе данных
pg_dump -U "${DB_USER}" -F c "${DB_NAME}" | gzip > "${BACKUP_FILE}"

# Проверка успешности создания бэкапа
if [ $? -ne 0 ]; then
  echo "Ошибка при создании бэкапа!"
  exit 1
fi

# Копирование бэкапа на удаленный сервер
echo "Копирование бэкапа на удаленный сервер..."
scp "${BACKUP_FILE}" "${REMOTE_SERVER}"

# Проверка успешности копирования
if [ $? -ne 0 ]; then
  echo "Ошибка при копировании бэкапа на удаленный сервер!"
  exit 1
fi

# Удаление локального бэкапа после успешного копирования
rm "${BACKUP_FILE}"

# Удаление старых бэкапов, оставляя только 3 последних
echo "Удаление старых бэкапов, оставляя только 3 последних..."
cd "${BACKUP_DIR}" || { echo "Не удалось перейти в директорию ${BACKUP_DIR}"; exit 1; }
BACKUPS_TO_REMOVE=$(ls -tp ${DB_NAME}_backup_*.sql.gz | grep -v '/$' | awk 'NR>3')
if [ -n "$BACKUPS_TO_REMOVE" ]; then
  echo "$BACKUPS_TO_REMOVE" | xargs -I {} rm -- {}
else
  echo "Нет старых бэкапов для удаления."
fi

# Удаление переменной окружения PGPASSWORD
unset PGPASSWORD

echo "Бэкап завершен успешно!"
