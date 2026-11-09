using Microsoft.AspNetCore.Mvc;
using RaceDay.MVC.Services;

namespace RaceDay.MVC.Controllers
{
    public class ParticipantController : Controller
    {
        private readonly ApiService _apiService;

        public ParticipantController(ApiService apiService)
        {
            _apiService = apiService;
        }

        private bool IsParticipant()
        {
            var role = HttpContext.Session.GetString("UserRole");
            return role == "Participant";
        }

        // GET: /Participant/MyEnrolments
        public async Task<IActionResult> MyEnrolments()
        {
            if (!IsParticipant()) return RedirectToAction("Login", "Account");

            var enrolments = await _apiService.GetAsync<List<TeamEventDto>>("team-events");
            return View(enrolments ?? new List<TeamEventDto>());
        }

        // GET: /Participant/MyResults
        public async Task<IActionResult> MyResults()
        {
            if (!IsParticipant()) return RedirectToAction("Login", "Account");

            var results = await _apiService.GetAsync<List<ParticipantResultDto>>("participants");
            return View(results ?? new List<ParticipantResultDto>());
        }
    }

    public class TeamEventDto
    {
        public int EventTeamID { get; set; }
        public int TeamID { get; set; }
        public int EventID { get; set; }
        public string Status { get; set; } = "Confirmed"; // Colour-coded status
    }

    public class ParticipantResultDto
    {
        public int PartID { get; set; }
        public string Partname { get; set; } = string.Empty;
        public string PartCar { get; set; } = string.Empty;
        public int PartWins { get; set; }
    }
}