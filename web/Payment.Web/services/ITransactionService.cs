using Payment.Web.Models;
using System.Collections.Generic;

namespace Payment.Web.Services
{
    public interface ITransactionService
    {
        List<Transaction> GetAll();
        void Add(Transaction transaction);
    }
}
