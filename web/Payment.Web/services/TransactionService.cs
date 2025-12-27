using Payment.Web.Data;
using Payment.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Payment.Web.Services
{
    public class TransactionService : ITransactionService
    {
        private readonly AppDbContext _context;

        public TransactionService(AppDbContext context)
        {
            _context = context;
        }

        public List<Transaction> GetAll()
        {
            return _context.Transactions
                .OrderByDescending(t => t.CreatedAt)
                .ToList();
        }

        public void Add(Transaction transaction)
        {
            // --- FRAUD RULE ENGINE ---
            double score = 0;
            string reason = "";

            // Rule 1: Yüksek tutar
            if (transaction.Amount >= 10000)
            {
                score += 60;
                reason += "High amount; ";
            }

            // Rule 2: Gönderen = Alıcı
            if (transaction.Sender == transaction.Receiver)
            {
                score += 40;
                reason += "Sender equals receiver; ";
            }

            // Rule 3: Gece işlemi
            var hour = DateTime.Now.Hour;
            if (hour >= 0 && hour <= 5)
            {
                score += 20;
                reason += "Night transaction; ";
            }

            // Final karar
            transaction.FraudScore = score;
            transaction.IsFraud = score >= 70;
            transaction.FraudReason = transaction.IsFraud ? reason : null;
            transaction.CreatedAt = DateTime.Now;

            _context.Transactions.Add(transaction);
            _context.SaveChanges();
        }
    }
}
