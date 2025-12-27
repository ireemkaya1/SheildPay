using System.Threading.Tasks;
using Payment.Web.Models.ViewModels;

namespace Payment.Web.Services
{
    public interface INodeApiClient
    {
        Task<object?> HealthAsync();
        Task<RateViewModel?> RatesAsync(string from, string to);
    }
}
