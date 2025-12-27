namespace Payment.Web.Models.ViewModels
{
    public class RateViewModel
    {
        public string From { get; set; } = string.Empty;
        public string To { get; set; } = string.Empty;
        public decimal Rate { get; set; }
        public string Date { get; set; } = string.Empty;
    }
}
