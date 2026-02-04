using HealthSymptomChecker.API.Data;
using HealthSymptomChecker.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Text;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using HealthSymptomChecker.API.Services;

namespace HealthSymptomChecker.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class AssessmentController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IAIIntegrationService _aiService;


        public AssessmentController(AppDbContext context, IAIIntegrationService aiService)
        {
            _context = context;
            _aiService = aiService;
        }

        [HttpPost]
        public async Task<ActionResult<UserRequest>> AssessSymptoms([FromBody] DTOs.SymptomFormDTO form)
        {
            if (form == null || form.Symptoms.Count == 0)
            {
                return BadRequest("No symptoms provided.");
            }

            // Use AI Service
            Console.WriteLine($"DEBUG: Received assessment request. Age: {form.Age}, Gender: {form.Gender}, Symptoms: {string.Join(",", form.Symptoms)}");
            var (severity, aiResponseJson) = await _aiService.AnalyzeSymptomsAsync(form.Symptoms);

            // Log the request
            var userRequest = new UserRequest
            {
                UserId = GetUserId(),
                SymptomsList = string.Join(",", form.Symptoms),
                Duration = form.Duration,
                PainLevel = form.PainLevel,
                Age = form.Age,
                Gender = form.Gender,
                PredictedSeverity = severity,
                AIResponseJson = aiResponseJson,
                Timestamp = DateTime.UtcNow
            };

            _context.UserRequests.Add(userRequest);
            await _context.SaveChangesAsync();

            return Ok(new { Severity = severity, Details = aiResponseJson });
        }

        private int? GetUserId()
        {

            // Simple check for the standardized "id" claim
            var claim = User.Claims.FirstOrDefault(c => c.Type == "id" || c.Type == "nameid");

            if (claim != null && int.TryParse(claim.Value, out int userId))
            {
                return userId;
            }
            return null;
        }

        [HttpGet("history")]
        public async Task<ActionResult<IEnumerable<UserRequest>>> GetHistory()
        {
            var authHeader = Request.Headers["Authorization"].ToString();
            Console.WriteLine($"DEBUG: History request received. Auth Header: {authHeader}");
            
            var userId = GetUserId();
            if (userId == null)
            {
                // For demo purposes, if no user is logged in, return latest 10
                 return await _context.UserRequests.OrderByDescending(r => r.Timestamp).Take(10).ToListAsync();
            }

            return await _context.UserRequests
                .Where(r => r.UserId == userId)
                .OrderByDescending(r => r.Timestamp)
                .ToListAsync();
        }
    }
}
