# Используем многостадийную сборку
FROM golang:1.24 AS builder

# Для Debian-based используем apt вместо apk
RUN apt-get update && apt-get install -y git

WORKDIR /app

# Копируем файлы зависимостей
COPY go.mod go.sum ./

# Скачиваем зависимости
RUN go mod download

# Копируем остальной код
COPY . .

# Собираем приложение
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /main main.go

# Финальный образ (используем минимальный debian:buster-slim)
FROM debian:buster-slim

WORKDIR /

# Копируем бинарник из стадии сборки
COPY --from=builder /main /main

# Точка входа
CMD ["/main"]