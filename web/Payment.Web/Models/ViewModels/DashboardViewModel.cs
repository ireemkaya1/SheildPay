using System.Collections.Generic;
using Payment.Web.Models; // Transaction modeli buradaysa

namespace Payment.Web.Models.ViewModels
{
    public class DashboardViewModel
    {
        public List<Transaction> RecentTransactions { get; set; } = new();
        public FraudResultViewModel FraudSummary { get; set; } = new();
    }
}
