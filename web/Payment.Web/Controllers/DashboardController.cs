using Microsoft.AspNetCore.Mvc;
using Payment.Web.Data;
using Payment.Web.Models.ViewModels;
using System.Linq;

namespace Payment.Web.Controllers
{
    public class DashboardController : Controller
    {
        private readonly AppDbContext _context;

        public DashboardController(AppDbContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            var recentTransactions = _context.Transactions
                .OrderByDescending(x => x.CreatedAt)
                .Take(5)
                .ToList();

            var totalCount = _context.Transactions.Count();
            var fraudCount = _context.Transactions.Count(x => x.IsFraud);

            var model = new DashboardViewModel
            {
                RecentTransactions = recentTransactions,
                FraudSummary = new FraudResultViewModel
                {
                    TotalTransactions = totalCount,
                    FraudCount = fraudCount,
                    NormalCount = totalCount - fraudCount
                }
            };

            return View(model);
        }
    }
}
