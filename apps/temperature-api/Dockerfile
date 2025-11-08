# Используем официальный образ SDK .NET 8 для сборки приложения
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Копируем файлы проекта
COPY temperature-api.csproj ./
RUN dotnet restore

# Копируем остальные исходники и собираем приложение
COPY . ./
RUN dotnet publish -c Release -o /app --no-restore

# Используем образ runtime для запуска
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app ./

# Открываем порт 8081
EXPOSE 8081

# Задаём переменную окружения, чтобы приложение слушало на 8081
ENV ASPNETCORE_URLS=http://+:8081

# Запуск приложения
ENTRYPOINT ["dotnet", "temperature-api.dll"]
