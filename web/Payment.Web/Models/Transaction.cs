using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Payment.Web.Models
{
    public class Transaction
    {
        public int Id { get; set; }

        [Required]
        public string Sender { get; set; } = null!;

        [Required]
        public string Receiver { get; set; } = null!;

        [Required]
        public decimal Amount { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; }
        public bool IsFraud { get; set; }
public double FraudScore { get; set; }
public string? FraudReason { get; set; }

    }
}
