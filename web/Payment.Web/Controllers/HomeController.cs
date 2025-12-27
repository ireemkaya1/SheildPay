using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Payment.Web.Models;

namespace Payment.Web.Controllers;

public class HomeController : Controller
{
    public IActionResult Index()
{
    var role = HttpContext.Session.GetString("Role");

    if (string.IsNullOrEmpty(role))
    {
        return RedirectToAction("Login", "Account");
    }
    
    if (role == "Admin")
        return RedirectToAction("Index", "Dashboard");

    return RedirectToAction("Index", "Transactions");
}

    public IActionResult Privacy()
    {
        return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
