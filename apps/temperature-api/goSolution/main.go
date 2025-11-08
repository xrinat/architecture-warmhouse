package main

import (
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"time"
)

// TemperatureResponse Структура для JSON-ответа
type TemperatureResponse struct {
	Location    string  `json:"location"`
	Temperature float64 `json:"temperature"`
}

// temperatureHandler обрабатывает запросы к /temperature
func temperatureHandler(w http.ResponseWriter, r *http.Request) {
	// Получаем параметр location из URL
	location := r.URL.Query().Get("location")
	if location == "" {
		location = "unknown"
	}

	// Инициализируем новый генератор случайных чисел
	// Это предпочтительный способ в Go 1.20+
	rGen := rand.New(rand.NewSource(time.Now().UnixNano()))

	// Генерируем случайную температуру от -10.0 до 35.0
	// (Генерируем число от 0.0 до 45.0, затем вычитаем 10.0)
	temp := (rGen.Float64() * 45.0) - 10.0
	// Округляем до одного знака после запятой
	temp = float64(int(temp*10)) / 10

	// Создаем ответ
	response := TemperatureResponse{
		Location:    location,
		Temperature: temp,
	}

	// Устанавливаем заголовок Content-Type
	w.Header().Set("Content-Type", "application/json")
	
	// Логируем запрос
	log.Printf("Запрос для location='%s', ответ: temp=%.1f", location, temp)

	// Кодируем ответ в JSON и отправляем
	if err := json.NewEncoder(w).Encode(response); err != nil {
		log.Printf("Ошибка при кодировании JSON-ответа: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
	}
}

func main() {
	http.HandleFunc("/temperature", temperatureHandler)

	port := "8081"
	fmt.Printf("Сервер 'temperature-api' запущен на порту %s\n", port)
	fmt.Println("Ожидание запросов на http://localhost:8081/temperature?location=...")
	// Слушаем на всех интерфейсах внутри контейнера
	log.Fatal(http.ListenAndServe(":"+port, nil))
}