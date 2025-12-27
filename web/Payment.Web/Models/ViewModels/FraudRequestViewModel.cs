using System.Text.Json.Serialization;

namespace Payment.Web.Models.ViewModels
{
    public class FraudRequestViewModel
    {
        [JsonPropertyName("sender")]
        public string Sender { get; set; } = "";

        [JsonPropertyName("receiver")]
        public string Receiver { get; set; } = "";

        [JsonPropertyName("amount")]
        public decimal Amount { get; set; }
    }
}
