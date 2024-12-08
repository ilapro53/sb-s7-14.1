# Указываем базовый образ с Node.js для сборки приложения
FROM node:14 as build

# Устанавливаем рабочую директорию в контейнере
WORKDIR /app

# Удалить все символические ссылки и файлы, связанные с yarn
RUN rm -f /usr/local/bin/yarn /usr/local/bin/yarnpkg && npm install -g yarn@1.22.19

# Копируем файл package.json и устанавливаем зависимости
COPY package.json yarn.lock ./
RUN yarn install

# Копируем все файлы проекта
COPY . .

# Собираем приложение для продакшена
RUN yarn build

# Указываем образ для раздачи собранного приложения на основе nginx
FROM nginx:alpine

# Копируем собранные файлы React-приложения в папку nginx
COPY --from=build /app/build /usr/share/nginx/html

# Экспонируем порт 80 для доступа к приложению
EXPOSE 80

# Запускаем nginx
CMD ["nginx", "-g", "daemon off;"]
