# Instaladores del agente CDN

Este repositorio público contiene **solo instaladores versionados**. El código fuente, las configuraciones y los tokens del agente permanecen en [cdn-edge-agent](https://github.com/edgardoalvarez100/cdn-edge-agent), un repositorio privado.

## Versiones

- [`v0.1.7/install.sh`](v0.1.7/install.sh) — versión recomendada; mejora la capacidad del CDN para más de 1000 clientes simultáneos.
- [`v0.1.6/install.sh`](v0.1.6/install.sh) — versión anterior; acepta paquetes con `VERSION` en formato Windows.
- [`v0.1.5/install.sh`](v0.1.5/install.sh) — versión anterior; instala Docker en Ubuntu 22.04 o superior si falta.
- [`v0.1.4/install.sh`](v0.1.4/install.sh) — versión anterior.
- [`v0.1.3/install.sh`](v0.1.3/install.sh) — versión anterior.
- [`v0.1.2/install.sh`](v0.1.2/install.sh) — versión anterior.
- [`v0.1.1/install.sh`](v0.1.1/install.sh) — versión anterior.
- [`v0.1.0/install.sh`](v0.1.0/install.sh) — versión anterior.

## Requisitos

Linux, Git y una **llave SSH autorizada para leer** `edgardoalvarez100/cdn-edge-agent`. También necesita el identificador y token de un servidor creado en [el panel](https://panel.cenetwork.com.co). Sin acceso SSH al repositorio privado, el instalador no puede obtener el agente. En Ubuntu 22.04 o superior, el agente instala automáticamente Docker Engine y el plugin Compose desde el repositorio oficial de Docker si faltan; para ello requiere `sudo` o root y acceso a Internet. En otras distribuciones, Docker Engine y Compose deben estar instalados antes de comenzar.

## Instalar o actualizar a v0.1.7

```sh
curl -fL -o install-cdn.sh https://raw.githubusercontent.com/edgardoalvarez100/cdn-edge-installers/main/v0.1.7/install.sh
sh install-cdn.sh
```

Revise el archivo descargado antes de ejecutarlo. El instalador crea `~/cdn-edge-agent`; si ya existe una instalación Git limpia, la avanza a la versión elegida y reutiliza su `.env`. Puede elegir otra ruta con `INSTALL_DIR=/ruta/agent sh install-cdn.sh`.

Al instalar por primera vez, escriba el identificador y el token del panel cuando se le soliciten. Para automatizar, defina `AGENT_ID` y `AGENT_TOKEN` como variables de entorno en el servidor. El instalador privado instala Docker si hace falta, construye e inicia los contenedores, habilita su arranque después de reiniciar Linux y comprueba `/health`.

Para otras versiones, descargue el archivo del directorio correspondiente. No se permite retroceder de versión sobre una instalación existente; para ello se necesita una restauración administrada.
