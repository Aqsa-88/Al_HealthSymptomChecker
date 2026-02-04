using System;

namespace HealthSymptomChecker.API.Models
{
    public class UserRequest
    {
        public int Id { get; set; }
        public int? UserId { get; set; }
        public string SymptomsList { get; set; } = string.Empty;
        public string Duration { get; set; } = string.Empty;
        public int PainLevel { get; set; }
        public int Age { get; set; }
        public string Gender { get; set; } = string.Empty;
        public string PredictedSeverity { get; set; } = string.Empty;
        public string AIResponseJson { get; set; } = string.Empty;
        public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    }
}
