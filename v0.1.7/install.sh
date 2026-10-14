#!/bin/sh
set -eu

# Instalador público. El código del agente permanece en el repositorio privado.
RELEASE='v0.1.7'
SOURCE='git@github.com:edgardoalvarez100/cdn-edge-agent.git'
INSTALL_DIR=${INSTALL_DIR:-"$HOME/cdn-edge-agent"}

die() { printf 'Error: %s\n' "$1" >&2; exit 1; }
[ "$(uname -s)" = Linux ] || die 'Este instalador requiere Linux.'
command -v git >/dev/null 2>&1 || die 'Instale Git antes de continuar.'

if [ ! -e "$INSTALL_DIR" ]; then
    git clone "$SOURCE" "$INSTALL_DIR" || die 'No se pudo descargar el agente privado. Autorice una llave SSH de lectura en GitHub.'
else
    [ -d "$INSTALL_DIR/.git" ] || die "El destino ya existe y no es un repositorio Git: $INSTALL_DIR"
    [ "$(git -C "$INSTALL_DIR" remote get-url origin)" = "$SOURCE" ] || die 'El destino no corresponde al repositorio privado del agente.'
    [ "$(git -C "$INSTALL_DIR" branch --show-current)" = main ] || die 'La instalación existente debe estar en la rama main.'
    [ -z "$(git -C "$INSTALL_DIR" status --porcelain --untracked-files=no)" ] || die 'Hay cambios locales en archivos del agente. Guárdelos antes de actualizar.'
fi

git -C "$INSTALL_DIR" fetch origin "refs/tags/$RELEASE:refs/tags/$RELEASE" || die "No se pudo obtener la versión $RELEASE. Revise la llave SSH."
target=$(git -C "$INSTALL_DIR" rev-parse "refs/tags/$RELEASE^{commit}") || die "La versión $RELEASE no existe."
if [ -f "$INSTALL_DIR/.env" ]; then
    git -C "$INSTALL_DIR" merge-base --is-ancestor HEAD "$target" || die "La versión $RELEASE es anterior o incompatible con la instalada."
    git -C "$INSTALL_DIR" merge --ff-only "$target" || die 'No se pudo avanzar a la versión solicitada.'
else
    git -C "$INSTALL_DIR" checkout -B main "$target" || die 'No se pudo seleccionar la versión solicitada.'
fi

[ "$(tr -d '\015' < "$INSTALL_DIR/VERSION")" = "${RELEASE#v}" ] || die 'La etiqueta no coincide con VERSION.'
printf 'Instalando agente CDN %s desde %s\n' "$RELEASE" "$INSTALL_DIR"
(cd "$INSTALL_DIR" && sh install.sh)
