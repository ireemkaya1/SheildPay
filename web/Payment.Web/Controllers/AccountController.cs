using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;

namespace Payment.Web.Controllers
{
    public class AccountController : Controller
    {
        [HttpGet]
        public IActionResult Login()
        {
            // Zaten giriş yapıldıysa dashboard'a git
            var role = HttpContext.Session.GetString("Role");
            if (!string.IsNullOrEmpty(role))
                return RedirectToAction("Index", "Dashboard");

            return View();
        }

        [HttpPost]
        public IActionResult Login(string username, string password)
        {
            // Basit demo login: Admin ve User
            // İstersen bunları DB'den de çekebilirsin; ileri web için şart değil.
            if (username == "admin" && password == "123")
            {
                HttpContext.Session.SetString("Username", "admin");
                HttpContext.Session.SetString("Role", "Admin");
                return RedirectToAction("Index", "Dashboard");
            }

            if (username == "user" && password == "123")
            {
                HttpContext.Session.SetString("Username", "user");
                HttpContext.Session.SetString("Role", "User");
                return RedirectToAction("Index", "Dashboard");
            }

            ViewBag.Error = "Kullanıcı adı veya şifre hatalı.";
            return View();
        }

        [HttpGet]
        public IActionResult Logout()
        {
            HttpContext.Session.Clear();
            return RedirectToAction("Login", "Account");
        }
    }
}
