using Microsoft.AspNetCore.Mvc;
using RaceDay.MVC.Services;

namespace RaceDay.MVC.Controllers
{
    public class OrganiserController : Controller
    {
        private readonly ApiService _apiService;

        public OrganiserController(ApiService apiService)
        {
            _apiService = apiService;
        }

        private bool IsOrganiser()
        {
            var role = HttpContext.Session.GetString("UserRole");
            return role == "Organiser";
        }

        // GET: /Organiser/Dashboard
        public async Task<IActionResult> Dashboard()
        {
            if (!IsOrganiser()) return RedirectToAction("Login", "Account");

            // Fetch events and summary stats from API
            var events = await _apiService.GetAsync<List<EventDto>>("events");
            return View(events ?? new List<EventDto>());
        }

        // GET: /Organiser/CreateEvent
        [HttpGet]
        public IActionResult CreateEvent()
        {
            if (!IsOrganiser()) return RedirectToAction("Login", "Account");
            return View();
        }

        // POST: /Organiser/CreateEvent
        [HttpPost]
        public async Task<IActionResult> CreateEvent(EventDto model)
        {
            if (!IsOrganiser()) return RedirectToAction("Login", "Account");

            var response = await _apiService.PostAsync("events", model);
            if (response.IsSuccessStatusCode)
            {
                TempData["Success"] = "Event created successfully!";
                return RedirectToAction("Dashboard");
            }

            ModelState.AddModelError(string.Empty, "Failed to create event.");
            return View(model);
        }
    }

    public class EventDto
    {
        public int EventID { get; set; }
        public string EventName { get; set; } = string.Empty;
        public string EventClass { get; set; } = string.Empty;
        public int TrackID { get; set; }
    }
}