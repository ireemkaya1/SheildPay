using System.ComponentModel.DataAnnotations;

namespace Payment.Web.Models.ViewModels
{
    public class TransactionCreateViewModel
    {
        [Required]
        public string Sender { get; set; } = "";

        [Required]
        public string Receiver { get; set; } = "";

        [Range(0.01, double.MaxValue)]
        public decimal Amount { get; set; }
    }
}

