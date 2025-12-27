using System.Collections.Generic;
using Payment.Web.Models;

namespace Payment.Web.Models.ViewModels
{
    public class ReportViewModel
    {
        public string Title { get; set; } = "Genel Rapor";
        public int TotalCount { get; set; }
        public int FraudCount { get; set; }
        public decimal TotalAmount { get; set; }
    }
}
