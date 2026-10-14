# Instaladores del agente CDN

Este repositorio público contiene **solo instaladores versionados**. El código fuente, las configuraciones y los tokens del agente permanecen en [cdn-edge-agent](https://github.com/edgardoalvarez100/cdn-edge-agent), un repositorio privado.

## Versiones

- [`v0.1.11/install.sh`](v0.1.11/install.sh) — versión recomendada; añade diagnóstico automático de la conexión al origen.
- [`v0.1.10/install.sh`](v0.1.10/install.sh) — versión anterior; corrige el tipo de terminal del acceso SSH web.
- [`v0.1.9/install.sh`](v0.1.9/install.sh) — versión anterior; muestra las reproducciones activas de canales con sesiones Nimble.
- [`v0.1.8/install.sh`](v0.1.8/install.sh) — versión anterior; renueva las sesiones HLS del origen sin cambiar las URL locales.
- [`v0.1.7/install.sh`](v0.1.7/install.sh) — versión anterior; mejora la capacidad del CDN para más de 1000 clientes simultáneos.
- [`v0.1.6/install.sh`](v0.1.6/install.sh) — versión anterior; acepta paquetes con `VERSION` en formato Windows.
- [`v0.1.5/install.sh`](v0.1.5/install.sh) — versión anterior; instala Docker en Ubuntu 22.04 o superior si falta.
- [`v0.1.4/install.sh`](v0.1.4/install.sh) — versión anterior.
- [`v0.1.3/install.sh`](v0.1.3/install.sh) — versión anterior.
- [`v0.1.2/install.sh`](v0.1.2/install.sh) — versión anterior.
- [`v0.1.1/install.sh`](v0.1.1/install.sh) — versión anterior.
- [`v0.1.0/install.sh`](v0.1.0/install.sh) — versión anterior.

## Requisitos

Para el instalador público se necesitan Linux, Git y una **llave SSH autorizada para leer** `edgardoalvarez100/cdn-edge-agent`. También necesita el identificador y token de un servidor creado en [el panel](https://panel.cenetwork.com.co). Si el CDN no tiene acceso a GitHub, use el método mediante TAR descrito abajo; ese método no requiere Git ni llave de GitHub en el CDN. En Ubuntu 22.04 o superior, el agente instala automáticamente Docker Engine y el plugin Compose desde el repositorio oficial de Docker si faltan; para ello requiere `sudo` o root y acceso a Internet. En otras distribuciones, Docker Engine y Compose deben estar instalados antes de comenzar.

## Instalar o actualizar a v0.1.11

```sh
curl -fL -o install-cdn.sh https://raw.githubusercontent.com/edgardoalvarez100/cdn-edge-installers/main/v0.1.11/install.sh
sh install-cdn.sh
```

Revise el archivo descargado antes de ejecutarlo. El instalador crea `~/cdn-edge-agent`; si ya existe una instalación Git limpia, la avanza a la versión elegida y reutiliza su `.env`. Puede elegir otra ruta con `INSTALL_DIR=/ruta/agent sh install-cdn.sh`.

Al instalar por primera vez, escriba el identificador y el token del panel cuando se le soliciten. Para automatizar, defina `AGENT_ID` y `AGENT_TOKEN` como variables de entorno en el servidor. El instalador privado instala Docker si hace falta, construye e inicia los contenedores, habilita su arranque después de reiniciar Linux y comprueba `/health`.

Para otras versiones, descargue el archivo del directorio correspondiente. No se permite retroceder de versión sobre una instalación existente; para ello se necesita una restauración administrada.

## Instalar o actualizar sin GitHub en el servidor CDN

En un equipo autorizado que tenga el repositorio privado, cree un paquete de la versión publicada:

```sh
cd cdn-edge-agent
git fetch --tags origin
git archive --format=tar.gz --output=cdn-edge-agent-v0.1.11.tar.gz v0.1.11
```

Copie el TAR al CDN con `scp`/SFTP si dispone de SSH, con el gestor de archivos de su proveedor o con un medio extraíble. Si tiene SSH, puede usar `scp cdn-edge-agent-v0.1.11.tar.gz USUARIO@IP_DEL_CDN:/tmp/`. Después, en el servidor Linux:

```sh
mkdir -p ~/cdn-edge-agent
tar -xzf /tmp/cdn-edge-agent-v0.1.11.tar.gz -C ~/cdn-edge-agent
cd ~/cdn-edge-agent
sh install.sh
```

El servidor CDN no necesita Git ni una llave de GitHub. En la primera instalación, introduzca el identificador y token del panel. Para actualizar, extraiga una versión nueva en la misma carpeta y vuelva a ejecutar `sh install.sh`; no borre `.env`, `ssh/` ni los volúmenes Docker. El TAR creado con `git archive` no incluye `.env` ni llaves privadas. Puede comprobar la versión con `tar -xOzf cdn-edge-agent-v0.1.11.tar.gz VERSION` antes de transferirlo. El CDN sí necesita acceso al panel y al origen, y acceso a APT y al registro de imágenes Docker si aún debe instalar Docker o descargar las imágenes.
