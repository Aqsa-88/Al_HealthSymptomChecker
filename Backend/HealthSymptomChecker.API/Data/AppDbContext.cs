using Microsoft.EntityFrameworkCore;
using HealthSymptomChecker.API.Models;

namespace HealthSymptomChecker.API.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<User> Users { get; set; }
        public DbSet<Symptom> Symptoms { get; set; }
        public DbSet<UserRequest> UserRequests { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configure Users
            modelBuilder.Entity<User>().HasIndex(u => u.Username).IsUnique();

            // Seed Symptoms (Crucial for Frontend Search)
            modelBuilder.Entity<Symptom>().HasData(
                new Symptom { Id = 1, Name = "Headache" },
                new Symptom { Id = 2, Name = "Fever" },
                new Symptom { Id = 3, Name = "Nausea" },
                new Symptom { Id = 4, Name = "Dizziness" },
                new Symptom { Id = 5, Name = "Cough" },
                new Symptom { Id = 6, Name = "Fatigue" },
                new Symptom { Id = 7, Name = "Chest Pain" },
                new Symptom { Id = 8, Name = "Shortness of Breath" }
            );
        }
    }
}
