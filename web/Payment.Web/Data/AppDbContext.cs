using Microsoft.EntityFrameworkCore;
using Payment.Web.Models;

namespace Payment.Web.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options) { }

        public DbSet<Transaction> Transactions { get; set; }
    }
}
