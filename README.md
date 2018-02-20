# rapi-sync

> NOT  PRODUCTION READY! 
    This is simple example of use RAPI for sync.

ИНСТРУКЦИЯ
--
0. папку со скриптами добавить в исключения брандмауэра windows

1. создать необходимые папки на терминале (in, out)

2. отредактировать файл config.cmd

    - REMOTE_UPLOAD_FOLDER - папка на терминале, в которую будут отправляться файлы

    - LOCAL_UPLOAD_FOLDER - локальная папка, из которой будут отправляться файлы

    - REMOTE_LOAD_FOLDER - папка на терминале, из которой будут скачиваться файлы

    - LOCAL_LOAD_FOLDER - локальная  папка, в которую будут скачиваться файлы


3. sync.cmd - запуск синхронизации

ПРИМЕЧАНИЕ
--
* **sync.cmd** - запуск синхронизации (выгрузка, затем загрузка данных)
* **rapi-upload.cmd** - выгрузка данных на терминал
* **rapi-load.cmd** - загрузка данных с терминала
* папка для загрузки с терминала (REMOTE_LOAD_FOLDER) очищается после каждой успешной загрузки на компьютер 
* папка для выгрузки данных на терминал (LOCAL_UPLOAD_FOLDER) очищается после каждой успешной выгрузки 
* синхронизация в одну сторону (LOCAL_UPLOAD_FOLDER -> REMOTE_UPLOAD_FOLDER, REMOTE_LOAD_FOLDER -> LOCAL_LOAD_FOLDER )
* синхронизация перезаписывает файлы (не учитывается timestamp)
* слэши в конфиге должны быть как в примере ниже

ПРИМЕР КОНФИГУРАЦИИ
-
```batch
::==========================================================================
:: CONFIG
::==========================================================================

:: sync folders
set REMOTE_UPLOAD_FOLDER=/Flash Disk/win-ce-sync/in
set REMOTE_LOAD_FOLDER=/Flash Disk/win-ce-sync/out
set LOCAL_UPLOAD_FOLDER=C:\server-data
set LOCAL_LOAD_FOLDER=C:\local-data

::==========================================================================
```
