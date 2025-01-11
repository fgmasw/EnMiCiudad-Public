# 1. Usa una imagen mínima de Node con Alpine
FROM node:alpine

# 1.1 Instala las librerías necesarias para configurar locales
RUN apk add --no-cache \
  bash \
  icu-data-full \
  icu-libs

# 1.2 Define las variables de entorno de los locales
ENV LANG=es_ES.UTF-8 \
    LANGUAGE=es_ES:es \
    LC_ALL=es_ES.UTF-8

# 2. Crea y define la carpeta de trabajo dentro del contenedor
WORKDIR /app

# 3. Instala json-server de forma global
RUN npm install -g json-server

# 4. Copia el archivo db.json dentro del contenedor
COPY db.json .

# 5. Expone el puerto 3000 (opcional, para documentación)
EXPOSE 3000

# 6. Comando que se ejecuta al levantar el contenedor
CMD ["json-server", "--watch", "db.json", "--port", "3000"]
