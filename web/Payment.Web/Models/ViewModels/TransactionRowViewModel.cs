using System;

namespace Payment.Web.Models.ViewModels
{
    public class TransactionRowViewModel
    {
        public string Sender { get; set; } = string.Empty;
        public decimal Amount { get; set; }
        public DateTime Date { get; set; }

        // Fraud için şimdilik hazır
        public bool IsFraud { get; set; }
        public decimal FraudScore { get; set; }
    }
}
