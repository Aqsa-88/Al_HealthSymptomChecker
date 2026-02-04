using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace HealthSymptomChecker.API.Migrations
{
    /// <inheritdoc />
    public partial class AddDurationAndPain : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Duration",
                table: "UserRequests",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "PainLevel",
                table: "UserRequests",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Duration",
                table: "UserRequests");

            migrationBuilder.DropColumn(
                name: "PainLevel",
                table: "UserRequests");
        }
    }
}
