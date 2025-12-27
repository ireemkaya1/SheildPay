using Microsoft.AspNetCore.Mvc;
using Payment.Web.Data;
using Payment.Web.Models.ViewModels;

namespace Payment.Web.Controllers
{
    public class ReportsController : Controller
    {
        private readonly AppDbContext _context;

        public ReportsController(AppDbContext context)
        {
            _context = context;
        }

        private bool IsLoggedIn()
        {
            return HttpContext.Session.GetString("Role") != null;
        }

        public IActionResult Index()
        {
            if (!IsLoggedIn())
                return RedirectToAction("Login", "Account");

            var total = _context.Transactions.Count();
            var fraud = _context.Transactions.Count(x => x.IsFraud);
            var amount = _context.Transactions.Sum(x => x.Amount);

            var model = new ReportViewModel
            {
                Title = "Genel Rapor",
                TotalCount = total,
                FraudCount = fraud,
                TotalAmount = amount
            };

            return View(model); // Views/Reports/Index.cshtml
        }
    }
}
