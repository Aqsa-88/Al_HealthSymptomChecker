using HealthSymptomChecker.API.Data;
using HealthSymptomChecker.API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HealthSymptomChecker.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SymptomController : ControllerBase
    {
        private readonly AppDbContext _context;

        public SymptomController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Symptom>>> GetSymptoms()
        {
            return await _context.Symptoms.ToListAsync();
        }
    }
}
