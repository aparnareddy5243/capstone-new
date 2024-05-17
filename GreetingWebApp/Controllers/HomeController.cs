// HomeController.cs
using Microsoft.AspNetCore.Mvc;

namespace YourNamespace.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Welcome(string name)
        {
            ViewData["Name"] = name;
            return View();
        }
    }
}
