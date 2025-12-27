using Microsoft.AspNetCore.Mvc;

namespace Payment.Web.Controllers
{
    public class SettingsController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Profile()
        {
            return View();
        }

        public IActionResult Security()
        {
            return View();
        }
    }
}

