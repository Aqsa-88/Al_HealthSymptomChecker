using System.ComponentModel.DataAnnotations;

namespace HealthSymptomChecker.API.DTOs
{
    public class SymptomFormDTO
    {
        [Required]
        public int Age { get; set; }
        
        [Required]
        public string Gender { get; set; } = string.Empty;
        
        [Required]
        public List<string> Symptoms { get; set; } = new List<string>();
        
        public string Duration { get; set; } = string.Empty;
        public int PainLevel { get; set; }
    }
}
