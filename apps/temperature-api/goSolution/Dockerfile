# --- Этап 1: Сборка ---
# Используем официальный образ Go в качестве сборщика
FROM golang:1.21-alpine AS builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем go.mod и go.sum для кэширования зависимостей
#COPY go.mod go.sum ./
COPY go.mod ./

# Загружаем зависимости
#RUN go mod download
RUN go mod tidy

# Копируем исходный код
COPY main.go .

# Собираем приложение
# CGO_ENABLED=0 отключает Cgo, что делает бинарник статически скомпонованным
# -ldflags="-w -s" убирает отладочную информацию, уменьшая размер
RUN CGO_ENABLED=0 go build -ldflags="-w -s" -o /temperature-api

# --- Этап 2: Финальный образ ---
# Используем минимальный образ Alpine
FROM alpine:latest

# Копируем скомпилированный бинарник из этапа сборки
COPY --from=builder /temperature-api /temperature-api

# Открываем порт, на котором будет работать приложение
EXPOSE 8081

# Команда для запуска приложения
CMD ["/temperature-api"]