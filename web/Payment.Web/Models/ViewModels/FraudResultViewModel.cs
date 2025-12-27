namespace Payment.Web.Models.ViewModels
{
    public class FraudResultViewModel
    {
        // ✅ Predict / Fraud sonucunda kullanılan alanlar
        public bool IsFraud { get; set; }
        public int FraudScore { get; set; }
        public string FraudReason { get; set; } = "";

        // ✅ Dashboard özetinde kullanılan alanlar (CS0117 fix)
        public int TotalTransactions { get; set; }
        public int FraudCount { get; set; }
        public int NormalCount { get; set; }
    }
}

