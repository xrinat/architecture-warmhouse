using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var random = new Random();

// 1️⃣ Старый вариант — через query string
app.MapGet("/temperature", ([FromQuery] string? location) =>
{
    var locationName = !string.IsNullOrEmpty(location) ? location : "unknown";
    double temp = Math.Round((random.NextDouble() * 45.0) - 10.0, 1);

    app.Logger.LogInformation($"[QUERY] Запрос для location='{locationName}', ответ: temp={temp}");
    return Results.Ok(new { location = locationName, value = temp });
});

// 2️⃣ Новый вариант — через параметр пути /temperature/{id}
app.MapGet("/temperature/{id}", ([FromRoute] string id) =>
{
    var locationName = id;
    double temp = Math.Round((random.NextDouble() * 45.0) - 10.0, 1);

    app.Logger.LogInformation($"[ROUTE] Запрос для id='{locationName}', ответ: temp={temp}");
    return Results.Ok(new { location = locationName, value = temp });
});

app.Run();
