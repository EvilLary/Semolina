pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int diff: 0
    property var locData: {}
    property var rawWeatherData: {}
    property string city: ""

    property QtObject weatherData: QtObject {

        readonly property string temperature: root.rawWeatherData?.current_weather?.temperature ?? "n/a"
        readonly property string apparentTemp: root.rawWeatherData?.hourly?.apparent_temperature ?? '0'
        readonly property string temperatureUnit: root.rawWeatherData?.current_weather_units?.temperature ?? "°"

        readonly property string humidity: root.rawWeatherData?.hourly?.relativehumidity_2m ?? '0'

        readonly property string windSpeed: root.rawWeatherData?.current_weather?.windspeed ?? "n/a"
        readonly property string windSpeedUnit: root.rawWeatherData?.current_weather_units?.windspeed ?? "Km/h"

        readonly property string windDirection: root.rawWeatherData?.current_weather?.winddirection ?? "0"
        readonly property string windDirectionUnit: root.rawWeatherData?.current_weather_units?.winddirection ?? "°"

        readonly property string weatherCode: root.rawWeatherData?.current_weather?.weathercode ?? "1000"
        readonly property bool isDay: (root.rawWeatherData?.current_weather?.is_day == 1) ? true : false

        property string weatherIcon
        property string weatherDescription
    }
    Process {
        id: fetchWeather
        command: ['sh','-c',`weather-Cli get ${root.city} --raw`]
        running: false
        stdout: SplitParser {
            splitMarker: '\n'
            onRead: data => {
                if (root.diff == 0) {
                    root.locData = JSON.parse(data)
                    root.diff += 1
                }
                else if (root.diff == 1) {
                    root.rawWeatherData = JSON.parse(data)
                    root.diff = 0
                }
            }
        }
        onExited: root.resolveWeatherCodes()
    }
    Timer {
        running: true
        repeat: true
        interval: 1000 * 60 * 60 * 1.5
        triggeredOnStart: false
        onTriggered: root.refresh()
    }
    function refresh(): void {
        fetchWeather.running = true
    }
    // switch(true) {

    //     case (code == 0):
    //         return root.weatherData.isDay ? "weather-clear" : "weather-clear-night";
    //     case (code >= 1 && code < 4):
    //         return root.weatherData.isDay ? "weather-few-clouds" : "weather-few-clouds-night";
    //     case (code >= 4 && code < 16):
    //         return "weather-mist"
    //     case ((code == 28) || (code >= 40 && code < 50)):
    //         return "weather-fog";
    //     case (code == 27):
    //         return "weather-hail";
    //     case ((code >= 50 && code < 68) || (code >=  20 && code > 26)):
    //         return "weather-freezing-rain";
    //     case (code == 68 || code == 69):
    //         return "weather-snow-rain";
    //     case (code >= 70 && code < 80):
    //         return root.weatherData.isDay ? "weather-snow-scattered" : "weather-snow-scattered-night"
    //     case ((code >= 80 && code < 100) || (code == 29)):
    //         return root.weatherData.isDay ? "weather-storm" : "weather-storm-night"
    //     defualt:
    //         return "weather-none-available";

    // }
    function resolveWeatherCodes(): void {
        switch (root.weatherData.weatherCode) {
            case "0":
                root.weatherData.weatherDescription = "Clear Sky"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-clear" : "weather-clear-night"
                break;
            case "1":
                root.weatherData.weatherDescription = "Mainly Clear"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-few-clouds" : "weather-few-clouds-night"
                break;
            case "2":
                root.weatherData.weatherDescription = "Party Cloudy"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-few-clouds" : "weather-few-clouds-night"
                break;
            case "3":
                root.weatherData.weatherDescription = "Overcast"
                root.weatherData.weatherIcon = "weather-overcast"
                break;
            case "45":
                root.weatherData.weatherDescription = "Fog"
                root.weatherData.weatherIcon = "weather-fog"
                break;
            case "48":
                root.weatherData.weatherDescription = "Depositing Rime Fog"
                root.weatherData.weatherIcon = "weather-fog"
                break;
            case "51":
                root.weatherData.weatherDescription = "Light Drizzle"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-showers-scattered-day" : "weather-showers-scattered-night"
                break;
            case "53":
                root.weatherData.weatherDescription = "Moderate Drizzle"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-showers" : "weather-showers-night"
                break;
            case "55":
                root.weatherData.weatherDescription = "Dense Drizzle"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-showers" : "weather-showers-night"
                break;
            case "56":
                root.weatherData.weatherDescription = "Light Freezing Drizzle"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-showers" : "weather-showers-night"
                break;
            case "57":
                root.weatherData.weatherDescription = "Dense Freezing Drizzle"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-showers" : "weather-showers-night"
                break;
            case "61":
                root.weatherData.weatherDescription = "Slight Rain"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-showers" : "weather-showers-night"
                break;
            case "63":
                root.weatherData.weatherDescription = "Moderate Rain"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-storm" : "weather-storm-night"
                break;
            case "65":
                root.weatherData.weatherDescription = "Heavy Rain"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-storm" : "weather-storm-night"
                break;
            case "66":
                root.weatherData.weatherDescription = "Light Freezing Rain"
                root.weatherData.weatherIcon = "weather-freezing-rain"
                break;
            case "67":
                root.weatherData.weatherDescription = "Heavy Freezing Rain"
                root.weatherData.weatherIcon = "weather-freezing-rain"
                break;
            case "71":
                root.weatherData.weatherDescription = "Slight Snow Fall"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-snow-scattered-day" : "weather-snow-scattered-night"
                break;
            case "73":
                root.weatherData.weatherDescription = "Moderate Snow Fall"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-snow" : "weather-snow-night"
                break;
            case "75":
                root.weatherData.weatherDescription = "Heavy Snow Fall"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-snow" : "weather-snow-night"
                break;
            case "77":
                root.weatherData.weatherDescription = "Snow Grains"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-snow" : "weather-snow-night"
                break;
            case "80":
                root.weatherData.weatherDescription = "Slight Rain Showers"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-showers-scattered-day" : "weather-showers-scattered-night"
                break;
            case "81":
                root.weatherData.weatherDescription = "Moderate Rain Showers"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-showers" : "weather-showers-night"
                break;
            case "82":
                root.weatherData.weatherDescription = "Violent Rain Showers"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-showers" : "weather-showers-night"
                break;
            case "85":
                root.weatherData.weatherDescription = "Slight Snow Showers"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-snow-scattered-day" : "weather-snow-scattered-night"
                break;
            case "86":
                root.weatherData.weatherDescription = "Heavy Snow Showers"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-snow" : "weather-snow-night"
                break;
            case "95":
                root.weatherData.weatherDescription = "Thunderstorm"
                root.weatherData.weatherIcon = root.weatherData.isDay ? "weather-storm" : "weather-storm-night"
                break;
            case "96":
                root.weatherData.weatherDescription = "Thunderstorm with Light Hail"
                root.weatherData.weatherIcon = "weather-hail"
                break;
            case "99":
                root.weatherData.weatherDescription = "Thunderstorm with Heavy Hail"
                root.weatherData.weatherIcon = "weather-hail"
                break;
            default:
                root.weatherData.weatherDescription = "Unknown"
                root.weatherData.weatherIcon = "weather-none-available"
                break;
        }
    }
}
