using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Payment.Web.Services;

namespace Payment.Web.Controllers
{
    public class NodeApiController : Controller
    {
        private readonly NodeApiClient _node;

        public NodeApiController(NodeApiClient node)
        {
            _node = node;
        }

        // /NodeApi -> direkt Health'e yönlendiriyorum
        public IActionResult Index()
        {
            return RedirectToAction(nameof(Health));
        }

        // /NodeApi/Health
        public async Task<IActionResult> Health()
        {
            var data = await _node.HealthAsync();
            return Json(data);
        }

        // /NodeApi/Rates?from=USD&to=TRY
        public async Task<IActionResult> Rates(string from = "USD", string to = "TRY")
        {
            var data = await _node.RatesAsync(from, to);
            return Json(data);
        }

        // /NodeApi/LatestTransactions?limit=5
        
    }
}
