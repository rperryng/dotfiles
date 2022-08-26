# Secrets

Secrets management

## Usage

`.env` files in `${XDG_CONFIG_HOME}/secrets.d` become exported as
environment variables in the shell.

Supported:
- comments
- variable expansion in assignment
- blank lines

`.env` files get run in a `bash` shell, just like with `direnv`.

###### TODO:

- [ ] Add script to validate `.env` and `.env.template` files
