# Portal datos.gob.ar

## Instalación

Teniendo en cuenta la dificultad de implementación e incluso la cantidad de pasos para lograr un deploy exitoso, existen dos formas de instalar esta distribución de **CKAN**. 

- Si no tenés muchos conocimientos de CKAN, Docker o de administración de servidores en general, es recomendable usar la instalación **[simplificada  de Andino](#instalacion-simplificada-de-andino)**. Está pensada para que en la menor cantidad de pasos y de manera sencilla, tengas un portal de datos funcionando. 
- Si ya conocés la plataforma, tenés experiencia con Docker o simplemente, querés entender cómo funciona esta implementación, te sugiero que revises la **[instalacion avanzada de Andino](#instalacion-avanzada-de-andino)**

### Dependencias

+ DOCKER: [Guía de instalación](https://docs.docker.com/engine/installation).
+ Docker Compose: [Guía de instalación](https://docs.docker.com/compose/install/)

### Instalación simplificada

La idea detrás de esta implementación de CKAN es **que sólo te encargues de tus datos**, nada más. Por eso, si "copiás y pegás" el comando de consola, en solo unos momentos, tendrás un Andino listo para usar.
Esta clase de instalación no requiere que clones el repositorio, ya que usamos contenedores alojados en [DockerHub](https://hub.docker.com/r/datosgobar).

+ Ubuntu|Debian|RHEL|CentOS:

+ Instalación:

Para esta instalación ciertos parámetros deben ser pasados a la aplicación:

+ Email donde se mandarán los errores. `EMAIL=admin@example.com`
+ Dominio o IP de la aplicación: `HOST=datos.gob.ar`
+ Usuario de la base de datos: `DB_USER=<my db user>`
+ Password de la base de datos: `DB_PASS=<my db pass>`
+ Usuario del datastore: `STORE_USER=<my datastore user>`
+ Password del datastore: `STORE_PASS=<my datastore password>`

```bash
wget https://raw.github.com/datosgobar/portal-base/master/deploy/install.py
python ./install.py --error_email "$EMAIL" --site_host="$HOST" \
    --database_user="$DB_USER" --database_password="$DB_PASS" \
    --datastore_user="$STORE_USER" --datastore_password="$STORE_PASS" \
    --repo portal_datos.gob.ar
docker-compose -f latest.yml exec portal bash /etc/ckan_init.d/init_datosgobar.sh
docker-compose -f latest.yml up -d start_harvest start_search_update
```

### Instalación avanzada

La instalación avanzada está pensada para usuarios que quieren ver cómo funciona internamente `Andino`

Para instalar y ejecutar `Andino`, seguimos estos pasos:

+ Paso 1: Clonar repositorio.

		$ sudo mkdir /etc/datosgobar
		$ cd /etc/datosgobar
		$ sudo git clone https://github.com/datosgobar/portal_datos.gob.ar.git datosgobar
		$ cd datosgobar
		
+ Paso 2: Setear las variables de entorno para el contenedor de postgresql

        $ DB_USER=<my user>
        $ DB_PASSWORD=<my pass>
        $ sudo su -c "echo POSTGRES_USER=$DB_USER > .env"
        $ sudo su -c "echo POSTGRES_PASWORD=$DB_PASS >> .env"
        

+ Paso 3: _Construir y lanzar los contenedor de servicios usando el archivo **latest.yml**_

        $ docker-compose -f latest.yml up -d db postfix redis solr        

+ Paso 4: _Construir y lanzar el contenedor de **datosgobar** usando el archivo **latest.yml**_

		$ docker-compose -f latest.yml up -d portal
		
+ Paso 5: Inicializar la base de datos y la configuración de la aplicación:


```bash
EMAIL=admin@example.com
HOST=datos.gob.ar
DB_USER=<my db user>
DB_PASS=<my db pass>
STORE_USER=<my datastore user>
STORE_PASS=<my datastore password>
docker-compose -f latest.yml exec portal /etc/ckan_init.d/init.sh -e "$EMAIL" -h "$HOST" \
        -p "$DB_USER" -P "$DB_PASS" \
        -d "$STORE_USER" -D "$STORE_PASS"
        
docker-compose -f latest.yml exec portal bash /etc/ckan_init.d/init_datosgobar.sh

```

+ Paso 8: _Construir el contenedor de **nginx** usando el archivo **latest.yml**_

		$ docker-compose -f latest.yml up -d nginx

