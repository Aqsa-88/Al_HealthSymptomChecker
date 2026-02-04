using System.Text;
using System.Text.Json;

namespace HealthSymptomChecker.API.Services
{
    public interface IAIIntegrationService
    {
        Task<(string Severity, string Details)> AnalyzeSymptomsAsync(List<string> symptoms);
    }

    public class AIIntegrationService : IAIIntegrationService
    {
        private readonly HttpClient _httpClient;

        public AIIntegrationService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<(string Severity, string Details)> AnalyzeSymptomsAsync(List<string> symptoms)
        {
            try
            {
                var aiRequest = new { symptoms = symptoms };
                var content = new StringContent(JsonSerializer.Serialize(aiRequest), Encoding.UTF8, "application/json");

                // Call AI Engine
                var response = await _httpClient.PostAsync("http://127.0.0.1:8000/predict", content);
                
                if (response.IsSuccessStatusCode)
                {
                    var resultJson = await response.Content.ReadAsStringAsync();
                    using var doc = JsonDocument.Parse(resultJson);
                    string severity = "Unknown";
                    
                    if (doc.RootElement.TryGetProperty("severity", out var severityElement))
                    {
                        severity = severityElement.GetString() ?? "Unknown";
                    }
                    return (severity, resultJson);
                }
                
                return ("Error connecting to AI", "{}");
            }
            catch (Exception ex)
            {
                return ("Error", $"{{\"error\": \"{ex.Message}\"}}");
            }
        }
    }
}
