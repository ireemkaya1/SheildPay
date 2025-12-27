using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Payment.Web.Migrations
{
    public partial class AddFraudFields : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsFraud",
                table: "Transactions",
                type: "tinyint(1)",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<double>(
                name: "FraudScore",
                table: "Transactions",
                nullable: false,
                defaultValue: 0.0);

            migrationBuilder.AddColumn<string>(
                name: "FraudReason",
                table: "Transactions",
                nullable: true);
        }

protected override void Down(MigrationBuilder migrationBuilder)
{
    migrationBuilder.DropColumn(
        name: "IsFraud",
        table: "Transactions");

    migrationBuilder.DropColumn(
        name: "FraudScore",
        table: "Transactions");

    migrationBuilder.DropColumn(
        name: "FraudReason",
        table: "Transactions");
}
    }}