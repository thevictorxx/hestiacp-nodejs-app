# HestiaCP con Aplicaccion de Nodejs

La ejecución de aplicaciones de Node en HestiaCP puede llegar a ser un poco complicado, con este script crearas un *template* dentro de HestiaCP que podrá ser seleccionado por medio de las **plantillas de proxy** dentro de la configuración del dominio.

![proxy_template_example](/img/001.png)

## ¿Cómo funciona?

Realiza un `proxy pass` de todas las peticiones que llegan al dominio hacia el puerto en el que corre la aplicación, además crea una carpeta en el directorio para el almacenamiento de la aplicación misma.

![folder_nodeapp](/img/002.png)

> Por el momento no corre ningún script automático para la ejecución de la aplicación, pero se recomienda la utilización de [PM2](https://pm2.keymetrics.io/).

## ¿Cómo se usa?

Debes clonar este repositorio en la maquina en la que se utilizara, una vez hecho existen dos métodos, el método manual y el por script.

### Método por Script

La ejecución del script debe ser con los permisos del usuario sudo, ya que, se realizaran modificación en carpetas con acceso restringido.

**1.-** Otorgamos los permisos para la ejecución del script

```bash
chmod +x ./create.sh
```

**2.-** Luego ejecutamos el script indicando el puerto que deseamos utilizar.

```bash
sudo ./create.sh -p 3000
```

#### Opciones

| Opción | Default                                      |                                                              |
| ------ | -------------------------------------------- | ------------------------------------------------------------ |
| -p     | `3000`                                       | Puerto deseado.                                              |
| -d     | `/usr/local/hestia/data/templates/web/nginx` | Directorio donde se crearan los template.                    |
| -f     | `nodeapp`                                    | Nombre del directorio que se creara dentro del dominio para almacenar los archivos de la aplicación. |

#### Post ejecución 

![script_execution](/img/003.png)



### Método Manual

**1.-** Debes copiar los 3 archivos que se encuentran dentro de la carpeta `files` dentro de la carpeta donde HestiaCP administra los templates para los dominios que se crean, en la ruta **`/usr/local/hestia/data/templates/web/nginx`**.

```bash
cp ./files/nodeapp.* /usr/local/hestia/data/templates/web/nginx/
```

**2.-** Debes otorgar los permisos que requiere cada archivo

```bash
sudo chmod 644 nodeapp.tpl
```
```bash
sudo chmod 644 nodeapp.stpl
```
```bash
sudo chmod 755 nodeapp.sh
```

> El archivo esta configurado solo para el puerto 3000, si deseas otro puerto debes los archivos `.tpl` y `.stpl` poniendo el puerto deseado, en cada archivo debes realizar dos cambios si deseas cambiar el puerto.
